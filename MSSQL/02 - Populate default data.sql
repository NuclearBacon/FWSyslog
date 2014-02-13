USE L1
GO

INSERT INTO L1.dbo.Protocols (DecimalValue, Keyword, LongName) VALUES 
	(0, 'HOPOPT', 'IPv6 Hop-by-Hop Option')
    ,(1, 'ICMP', 'Internet Control Message')
    ,(2, 'IGMP', 'Internet Group Management')
    ,(3, 'GGP', 'Gateway-to-Gateway')
    ,(4, 'IPv4', 'IPv4 encapsulation')
    ,(5, 'ST', 'Stream')
    ,(6, 'TCP', 'Transmission Control')
    ,(7, 'CBT', 'CBT')
    ,(8, 'EGP', 'Exterior Gateway Protocol')
    ,(9, 'IGP', 'any private interior gateway (used by Cisco for their IGRP)')
    ,(10, 'BB-RCC-MON', 'BBN RCC Monitoring')
    ,(11, 'NVP-II', 'Network Voice Protocol')
    ,(12, 'PUP', 'PUP')
    ,(13, 'ARGUS', 'ARGUS')
    ,(14, 'EMCON', 'EMCON')
    ,(15, 'XNET', 'Cross Net Debugger')
    ,(16, 'CHAOS', 'Chaos')
    ,(17, 'UDP', 'User Datagram')
    ,(18, 'MUX', 'Multiplexing')
    ,(19, 'DCN-MEAS', 'DCN Measurement Subsystems')
    ,(20, 'HMP', 'Host Monitoring')
    ,(21, 'PRM', 'Packet Radio Measurement')
    ,(22, 'XNS-IDP', 'XEROX NS IDP')
    ,(23, 'TRUNK-1', 'Trunk-1')
    ,(24, 'TRUNK-2', 'Trunk-2')
    ,(25, 'LEAF-1', 'Leaf-1')
    ,(26, 'LEAF-2', 'Leaf-2')
    ,(27, 'RDP', 'Reliable Data Protocol')
    ,(28, 'IRTP', 'Internet Reliable Transaction')
    ,(29, 'ISO-TP4', 'ISO Transport Protocol Class 4')
    ,(30, 'NETBLT', 'Bulk Data Transfer Protocol')
    ,(31, 'MFE-NSP', 'MFE Network Services Protocol')
    ,(32, 'MERIT-INP', 'MERIT Internodal Protocol')
    ,(33, 'DCCP', 'Datagram Congestion Control Protocol')
    ,(34, '3PC', 'Third Party Connect Protocol')
    ,(35, 'IDPR', 'Inter-Domain Policy Routing Protocol')
    ,(36, 'XTP', 'XTP')
    ,(37, 'DDP', 'Datagram Delivery Protocol')
    ,(38, 'IDP', '-CMTP	IDPR Control Message Transport Proto')
    ,(39, 'TP++', 'TP++ Transport Protocol')
    ,(40, 'IL', 'IL Transport Protocol')
    ,(41, 'IPv6', 'IPv6 encapsulation')
    ,(42, 'SDRP', 'Source Demand Routing Protocol')
    ,(43, 'IPv6-Route', 'Routing Header for IPv6')
    ,(44, 'IPv6-Frag', 'Fragment Header for IPv6')
    ,(45, 'IDRP', 'Inter-Domain Routing Protocol')
    ,(46, 'RSVP', 'Reservation Protocol')
    ,(47, 'GRE', 'Generic Routing Encapsulation')
    ,(48, 'DSR', 'Dynamic Source Routing Protocol')
    ,(49, 'BNA', 'BNA')
    ,(50, 'ESP', 'Encap Security Payload')
    ,(51, 'AH', 'Authentication Header')
    ,(52, 'I-NLSP', 'Integrated Net Layer Security TUBA')
    ,(53, 'SWIPE', 'IP with Encryption')
    ,(54, 'NARP', 'NBMA Address Resolution Protocol')
    ,(55, 'MOBILE', 'IP Mobility')
    ,(56, 'TLSP', 'Transport Layer Security Protocol using Kryptonet key management')
    ,(57, 'SKIP', 'SKIP')
    ,(58, 'IPv6-ICMP', 'ICMP for IPv6')
    ,(59, 'IPv6-NoNxt', 'No Next Header for IPv6')
    ,(60, 'IPv6-Opts', 'Destination Options for IPv6')
    ,(61, '', 'any host internal protocol')
    ,(62, 'CFTP', 'CFTP')
    ,(63,	'', 'any local network')
    ,(64, 'SA', '-EXPAK	SATNET and Backroom EXPAK')
    ,(65, 'KRYPTOLAN', 'Kryptolan')
    ,(66, 'RVD', 'MIT Remote Virtual Disk Protocol')
    ,(67, 'IPPC', 'Internet Pluribus Packet Core')
    ,(68, '', 'any distributed file system')
    ,(69, 'SAT-MON', 'SATNET Monitoring')
    ,(70, 'VISA', 'VISA Protocol')
    ,(71, 'IPCV', 'Internet Packet Core Utility')
    ,(72, 'CPNX', 'Computer Protocol Network Executive')
    ,(73, 'CPHB', 'Computer Protocol Heart Beat')
    ,(74, 'WSN', 'Wang Span Network')
    ,(75, 'PVP', 'Packet Video Protocol')
    ,(76, 'BR-SAT-MON', 'Backroom SATNET Monitoring')
    ,(77, 'SUN-ND', 'SUN ND PROTOCOL-Temporary')
    ,(78, 'WB-MON', 'WIDEBAND Monitoring')
    ,(79, 'WB-EXPAK', 'WIDEBAND EXPAK')
    ,(80, 'ISO-IP', 'ISO Internet Protocol')
    ,(81, 'VMTP', 'VMTP')
    ,(82, 'SECURE-VMTP', '	SECURE-VMTP')
    ,(83, 'VINES', 'VINES')
    ,(84, 'TTP or IPTM', 'Transaction Transport Protocol or Internet Protocol Traffic Manager')
    ,(85, 'NSFNET-IGP', 'NSFNET-IGP')
    ,(86, 'DGP', 'Dissimilar Gateway Protocol')
    ,(87, 'TCF', 'TCF')
    ,(88, 'EIGRP', 'EIGRP')
    ,(89, 'OSPFIGP', 'OSPFIGP')
    ,(90, 'Sprite-RPC', 'Sprite RPC Protocol')
    ,(91, 'LARP', 'Locus Address Resolution Protocol')
    ,(92, 'MTP', 'Multicast Transport Protocol')
    ,(93, 'AX.25', 'AX.25 Frames')
    ,(94, 'IPIP', 'IP-within-IP Encapsulation Protocol')
    ,(95, 'MICP', 'Mobile Internetworking Control Pro.')
    ,(96, 'SCC-SP', 'Semaphore Communications Sec. Pro.')
    ,(97, 'ETHERIP', 'Ethernet-within-IP Encapsulation')
    ,(98, 'ENCAP', 'Encapsulation Header')
    ,(99, '', 'any private encryption scheme')
    ,(100, 'GMTP', 'GMTP')
    ,(101, 'IFMP', 'Ipsilon Flow Management Protocol')
    ,(102, 'PNNI', 'PNNI over IP')
    ,(103, 'PIM', 'Protocol Independent Multicast')
    ,(104, 'ARIS', 'ARIS')
    ,(105, 'SCPS', 'SCPS')
    ,(106, 'QNX', 'QNX')
    ,(107, 'A/N', 'Active Networks')
    ,(108, 'IPComp', 'IP Payload Compression Protocol')
    ,(109, 'SNP', 'Sitara Networks Protocol')
    ,(110, 'Compa', '-Peer	Compaq Peer Protocol')
    ,(111, 'IPX-in-IP', 'IPX in IP')
    ,(112, 'VRRP', 'Virtual Router Redundancy Protocol')
    ,(113, 'PGM', 'PGM Reliable Transport Protocol')
    ,(114, '', 'any 0-hop protocol')
    ,(115, 'L2TP', 'Layer Two Tunneling Protocol')
    ,(116, 'DDX', 'D-II Data Exchange (DDX)')
    ,(117, 'IATP', 'Interactive Agent Transfer Protocol')
    ,(118, 'STP', 'Schedule Transfer Protocol')
    ,(119, 'SRP', 'SpectraLink Radio Protocol')
    ,(120, 'UTI', 'UTI')
    ,(121, 'SMP', 'Simple Message Protocol')
    ,(122, 'SM', 'Simple Multicast Protocol')
    ,(123, 'PTP', 'Performance Transparency Protocol')
    ,(124, 'ISIS over IPv4', '')
    ,(125, 'FIRE', '')
    ,(126, 'CRTP', 'Combat Radio Transport Protocol')
    ,(127, 'CRUDP', 'Combat Radio User Datagram')
    ,(128, 'SSCOPMCE', '')
    ,(129, 'IPLT', '')
    ,(130, 'SPS', 'Secure Packet Shield')
    ,(131, 'PIPE', 'Private IP Encapsulation within IP')
    ,(132, 'SCTP', 'Stream Control Transmission Protocol')
    ,(133, 'FC', 'Fibre Channel')
    ,(134, 'RSVP-E2E-IGNORE', '')
    ,(135, 'Mobility Header', '')
    ,(136, 'UDPLite', '')
    ,(137, 'MPLS-in-IP', '')
    ,(138, 'manet', 'MANET Protocols')
    ,(139, 'HIP', 'Host Identity Protocol')
    ,(140, 'Shim6', 'Shim6 Protocol')
    ,(141, 'WESP', 'Wrapped Encapsulating Security Payload')
    ,(142, 'ROHC', 'Robust Header Compression')
	,(253, '', 'Used for experimentation and testing')
    ,(254, '', 'Used for experimentation and testing')
    ,(255, 'Reserved', '')

DECLARE @UA_Index INT = 143, @UA_End INT = 252
WHILE (@UA_Index <= @UA_End)
BEGIN
	INSERT INTO L1.dbo.Protocols (DecimalValue, Keyword, LongName) VALUES (@UA_Index, '', 'Unassigned')
	SET @UA_Index = @UA_Index + 1
END


INSERT INTO L1.dbo.SyslogSeverityLevels (SEVERITY_KEY, SEVERITY_NAME, DESCRIPTION_SHORT, DESCRIPTION_LONG)
VALUES
	(0, 'Emergency', 'System is unusable.', 'A "panic" condition usually affecting multiple apps/servers/sites. At this level it would usually notify all tech staff on call.'),
	(1, 'Alert', 'Action must be taken immediately.', 'Should be corrected immediately, therefore notify staff who can fix the problem. An example would be the loss of a primary ISP connection.'),
	(2, 'Critical', 'Critical conditions.', 'Should be corrected immediately, but indicates failure in a secondary system, an example is a loss of a backup ISP connection.'),
	(3, 'Error', 'Error conditions.', 'Non-urgent failures, these should be relayed to developers or admins; each item must be resolved within a given time.'),
	(4, 'Warning', 'Warning conditions.', 'Warning messages, not an error, but indication that an error will occur if action is not taken, e.g. file system 85% full - each item must be resolved within a given time.'),
	(5, 'Notice', 'Normal but significant condition.', 'Events that are unusual but not error conditions - might be summarized in an email to developers or admins to spot potential problems - no immediate action required.'),
	(6, 'Informational', 'Informational messages.', 'Normal operational messages - may be harvested for reporting, measuring throughput, etc. - no action required.'),
	(7, 'Debug', 'Debug-level messages.', 'Info useful to developers for debugging the application, not useful during operations.')


INSERT INTO L1.dbo.SyslogFacilityLevels (FACILITY_KEY, FACILITY_KEYWORD, FACILITY_DESCRIPTION)
VALUES
	(0, 'kern', 'kernel messages'),
	(1, 'user', 'user-level messages'),
	(2, 'mail', 'mail system'),
	(3, 'daemon', 'system daemons'),
	(4, 'auth', 'security/authorization messages'),
	(5, 'syslog', 'messages generated internally by syslogd'),
	(6, 'lpr', 'line printer subsystem'),
	(7, 'news', 'network news subsystem'),
	(8, 'uucp', 'UUCP subsystem'),
	(9, '', 'clock daemon'),
	(10, 'authpriv', 'security/authorization messages'),
	(11, 'ftp', 'FTP daemon'),
	(12, '-', 'NTP subsystem'),
	(13, '-', 'log audit'),
	(14, '-', 'log alert'),
	(15, 'cron', 'clock daemon'),
	(16, 'local0', 'local use 0 (local0)'),
	(17, 'local1', 'local use 1 (local1)'),
	(18, 'local2', 'local use 2 (local2)'),
	(19, 'local3', 'local use 3 (local3)'),
	(20, 'local4', 'local use 4 (local4)'),
	(21, 'local5', 'local use 5 (local5)'),
	(22, 'local6', 'local use 6 (local6)'),
	(23, 'local7', 'local use 7 (local7)')