FWSyslog0.1
===========

Syslog broadcast recorder for 2-Wire 3800HGV-B gateways.

About
--------------
This is a pretty straight forward, no frills attached Windows service created primarily as a development learning experience.  The service monitors a specified UPD port for Syslog messages, parses them, and finally stores them in an MSSQL database.  Since this service was written with the 3800HGV-B gateway in mind, and since that device's Syslog messages deviate from standards, this logger will likely not work with properly formatted Syslog messages.

Installation / Configuration
--------------
(Pending)
