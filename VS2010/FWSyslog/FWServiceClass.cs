using System;
using System.ServiceProcess;
using System.Diagnostics;
using System.Threading;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Net;
using System.Net.Sockets;
using System.Net.NetworkInformation;

using res = FWSyslog.Properties.Resources;

namespace FWSyslog
{
    class FWSyslogClass : ServiceBase
    {
        private Thread listenerThread;
        private int listenPort;
        private IPAddress defaultGateway = null;
        private UdpClient client;

        private string logGroup = res.WindowsEventLog_Group;
        
        private string sqlConnString;

        private Timer timLogger; // Used to prevent wasting CPU cycles in unloaded while loop where DoEvents doesn't help.
        private int sqlUpdateInterval = 50; // in ms
        private List<L1GenericRecord> sqlMessageQueue = new List<L1GenericRecord>();

        private bool serviceIsStopping = false;  // trap to stop listener callback from firing during service shutdown

        // Class constructor.
        public FWSyslogClass()
        {
            this.ServiceName = res.Service_Name;
            this.CanStop = Convert.ToBoolean(res.Service_CanStop);
            this.AutoLog = Convert.ToBoolean(res.Service_AutoLog);
            this.CanPauseAndContinue = Convert.ToBoolean(res.Service_CanPauseAndContinue);

            if (!EventLog.SourceExists(res.Service_Name))
                EventLog.CreateEventSource(res.Service_Name, logGroup);
        }

        // Called when the service is (re)started by Windows.
        protected override void OnStart(string[] args)
        {
            //base.OnStart(args);

            serviceIsStopping = false;

            sqlConnString = ConfigurationManager.ConnectionStrings["L1DatabaseConnection"].ToString();
            try
            {
                listenPort = Convert.ToInt16(ConfigurationManager.AppSettings["listenPort"]);
            }
            catch (Exception e)
            {
                listenPort = Convert.ToInt16(res.DefaultSetting_listenport);
                string CustomMessage = "Configuration error: 'listenport' could not be read.  Using default value: {0}\r\n\r\nError details:\r\n{1}";
                EventLog.WriteEntry(res.Service_Name, String.Format(CustomMessage, listenPort.ToString(), e.Message, EventLogEntryType.Error));
            }
            
            
            timLogger = new Timer(timLogger_Callback, null, sqlUpdateInterval, Timeout.Infinite);

            listenerThread = new Thread(new ThreadStart(Listener));
            listenerThread.IsBackground = false;
            listenerThread.Start();

            EventLog.WriteEntry(res.Service_Name, "FWSyslog started.", EventLogEntryType.Information);
        }

        // Called when the service is stopped by anything.
        protected override void OnStop()
        {
 	        // base.OnStop();
            serviceIsStopping = true;

            if (listenerThread != null)
                listenerThread.Abort();

            if (client != null)
                client.Close();

            EventLog.WriteEntry(res.Service_Name, "FWSyslog stopped.", EventLogEntryType.Information);
        }

        // Callback handler for the message queue timer, timLogger.
        // This is what chews on the SQL message queue and sends the data in it to the SQL server.
        private void timLogger_Callback(Object state)
        {
            if (sqlMessageQueue.Count > 0)  // check the queue for messages
            {
                L1GenericRecord tempRecord;
                lock (sqlMessageQueue)
                {
                    tempRecord = sqlMessageQueue[0];
                    sqlMessageQueue.RemoveAt(0);
                }

                try
                {
                    using (SqlConnection con = new SqlConnection(sqlConnString))
                    {
                        using (SqlCommand cmd = new SqlCommand("EventLog_Generic_CreateEntry", con))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.Add("@p_eventDateTime", SqlDbType.VarChar).Value = tempRecord.eventDateTime;
	                        cmd.Parameters.Add("@p_localPort", SqlDbType.Int).Value = tempRecord.localPort;
	                        cmd.Parameters.Add("@p_senderIPv4Address", SqlDbType.VarChar).Value = tempRecord.senderIpAddress;
	                        cmd.Parameters.Add("@p_senderPort", SqlDbType.Int).Value = tempRecord.senderPort;
                            cmd.Parameters.Add("@p_parsedSenderIPv4Address", SqlDbType.VarChar).Value = tempRecord.parsedIpAddress;
	                        cmd.Parameters.Add("@p_priority", SqlDbType.Int).Value = tempRecord.priority;
	                        cmd.Parameters.Add("@p_messageTag", SqlDbType.VarChar).Value = tempRecord.messageTag;
                            cmd.Parameters.Add("@p_messageContent", SqlDbType.VarChar).Value = tempRecord.messageContent;

                            con.Open();
                            cmd.ExecuteNonQuery();
                        }
                    } 
                }
                catch (Exception e)
                {
                    // TODO:  add more robust error logging/handling that doesn't simply say "I broke" then shut down the service without outside input.
                    EventLog.WriteEntry(res.Service_Name, "Callback tick - ERROR! Details below:\r\n\r\n" + e.Message, EventLogEntryType.Error);
                }
            }
            
            // Reset the timer for the next pass.
            // TODO: embed this in to the if() block if the service is changed to stop itself on errors.
            timLogger.Change(sqlUpdateInterval, Timeout.Infinite);
        }

        // Gets the IP address of the gateway.  This should be the only IP address sending info to this app.
        private IPAddress GetDefaultGateway()
        {
            var card = NetworkInterface.GetAllNetworkInterfaces().FirstOrDefault();
            if (card == null)
                return null;
            return card.GetIPProperties().GatewayAddresses.FirstOrDefault().Address;
        }

        // SylogGroup message listener, threaded by listenerThread on service startup.
        private void Listener()
        {
            defaultGateway = GetDefaultGateway();
            if (client == null)
            {
                try
                {
                    client = new UdpClient(listenPort);
                    client.BeginReceive(new AsyncCallback(ListenerCallbackHandler), null);
                }
                catch (Exception e)
                {
                    // TODO:  add more robust error logging/handling that doesn't simply say "I broke" then shut down the service without outside input.
                    EventLog.WriteEntry(res.Service_Name, "UdpClient setup - ERROR! Details below:\r\n\r\n" + e.Message, EventLogEntryType.Error);
                }
            }
        }

        // Event handler for when the UDP client gets a hit.
        private void ListenerCallbackHandler(IAsyncResult result)
        {
            // Service shutdown check - we probably got bad data for this capture, so don't bother with it.
            if (serviceIsStopping)
                return;

            // Grab sender data and the message from the UdpClient.
            IPEndPoint RemoteIPEndPoint = new IPEndPoint(IPAddress.Any, listenPort);
            byte[] received = client.EndReceive(result, ref RemoteIPEndPoint);

            // Set the client back up for the next message.  Effectively loops this method over itself and discards the Listener thread from things.
            try
            {
                client.BeginReceive(new AsyncCallback(ListenerCallbackHandler), null);
            }
            catch (Exception e)
            {
                // TODO:  add more robust error logging/handling that doesn't simply say "I broke" then shut down the service without outside input.
                EventLog.WriteEntry(res.Service_Name, "UdpClient setup - ERROR! Details below:\r\n\r\n" + e.Message, EventLogEntryType.Error);
            }

            ProcessSylogMessage(Encoding.ASCII.GetString(received, 0, received.Length), RemoteIPEndPoint);
        }

        // Parses the Syslog message in to its base parts and adds them to the message queue.
        private void ProcessSylogMessage(string message, IPEndPoint remoteEndpoint)
        {
            // example case:
            // <142>Feb 03 16:18:17 192.168.1.254 igmp: bridge0: querier ver 3 sending general query
            //     ↑               ↑             ↑    ↑
            //     parse index 1   |             pi 3 |
            //                     pi 2               pi 4

            L1GenericRecord tmpStruct;
            int parseIndex1, parseIndex2, parseIndex3, parseIndex4;
            
            // locally collected info not needing to be parsed from message
            tmpStruct.senderIpAddress = remoteEndpoint.Address.ToString();
            tmpStruct.senderPort = remoteEndpoint.Port;
            tmpStruct.localPort = listenPort;

            // parse priority tag
            parseIndex1 = message.IndexOf(">");
            tmpStruct.priority = Convert.ToInt16(message.Substring(1, parseIndex1 - 1));

            // parse event timestamp, which, for some crazy reason, doesn't include the year
            // EDGE CASE:  potential issue with a log line being received before the new year and being parsed after it
            // EC Solution:  post-new year's query that finds records logged months in to the future and retarding by 1 year.
            parseIndex2 = message.IndexOf(" ", parseIndex1 + 10);
            tmpStruct.eventDateTime = message.Substring(parseIndex1 + 1, parseIndex2 - (parseIndex1 + 1));
            tmpStruct.eventDateTime = tmpStruct.eventDateTime.Insert(
                tmpStruct.eventDateTime.IndexOf(" ", 4),
                " " + DateTime.Now.Year.ToString()
                );
            
            // parse host IP address
            parseIndex3 = message.IndexOf(" ", parseIndex2 + 1);
            tmpStruct.parsedIpAddress = message.Substring(parseIndex2 + 1, parseIndex3 - (parseIndex2 + 1));

            // parse message tag
            parseIndex4 = message.IndexOf(":", parseIndex3);
            tmpStruct.messageTag = message.Substring(parseIndex3 + 1, parseIndex4 - (parseIndex3 + 1));

            // parse message
            switch (tmpStruct.messageTag)
            {
                //case "fw,fwmon":  
                //    TBI: FwFwMonParcer()
                //    break;
                default:
                    tmpStruct.messageContent = message.Substring(parseIndex4 + 2);
                    break;
            }

            lock (sqlMessageQueue)
            {
                sqlMessageQueue.Add(tmpStruct);
            }
        }

        // Structure to hold parsed SylogGroup messages bound for the SQL database.
        private struct L1GenericRecord
        {
            public string parsedIpAddress; // ipaddress the sender claimed to be
            public string senderIpAddress; // ipaddress the message was actually received from
            public int senderPort;
            public int localPort;

            public int priority;
            public string eventDateTime; // letting the SQL server handle the conversion to DATETIME; easier for moving the data.

            public string messageTag;
            public string messageContent;
        }

    }
}
