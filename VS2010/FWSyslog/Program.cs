using System;
using System.ServiceProcess;

namespace FWSyslog
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            ServiceBase.Run(new FWSyslogClass());
        }
    }
}
