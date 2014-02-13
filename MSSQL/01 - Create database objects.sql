/**********************************************************************************************************

	!!! WARNING !!!
	Running this script will drop any existing tables defined by this script.  Data that already
	exists in these tables is not backed up and WILL BE LOST.
	
	Action items before running:
	- A password must be provided for the agt_L1ServiceAgent account before the account will be created.

***********************************************************************************************************/

----------------------------------------
-- DATABASE SETUP ----------------------
----------------------------------------
USE master
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'L1') BEGIN
	CREATE DATABASE L1
	END
GO

USE L1
GO

----------------------------------------
-- TABLE SETUP -------------------------
----------------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'Protocols' AND type = 'U') BEGIN
	DROP TABLE L1.dbo.Protocols
	END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'EventLog_General' AND type = 'U') BEGIN
	DROP TABLE L1.dbo.EventLog_General
	END 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'SyslogFacilityLevels' AND type = 'U') BEGIN
	DROP TABLE L1.dbo.SyslogFacilityLevels
	END 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'SyslogSeverityLevels' AND type = 'U') BEGIN
	DROP TABLE L1.dbo.SyslogSeverityLevels
	END 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'IPv4_Records' AND type = 'U') BEGIN
	DROP TABLE L1.dbo.IPv4_Records
	END
GO


CREATE TABLE IPv4_Records (
	ADDRESS_KEY			BIGINT			NOT NULL	PRIMARY KEY,
	ADDRESS_STRING		VARCHAR(15)		NOT NULL,
	SECURITY_FLAG		INT				NULL,
	COMMENTS			NVARCHAR(4000)	NULL
)
GO

----------------------------------------
CREATE TABLE SyslogSeverityLevels (
	SEVERITY_KEY			INT				NOT NULL	PRIMARY KEY,
	SEVERITY_NAME			VARCHAR(15)		NOT NULL,
	DESCRIPTION_SHORT		VARCHAR(64)		NOT NULL,
	DESCRIPTION_LONG		VARCHAR(256)	NOT NULL
)


----------------------------------------
CREATE TABLE SyslogFacilityLevels (
	FACILITY_KEY			INT				NOT NULL	PRIMARY KEY,
	FACILITY_KEYWORD		VARCHAR(16)		NOT NULL,
	FACILITY_DESCRIPTION	VARCHAR(64)		NOT NULL
)

----------------------------------------
CREATE TABLE EventLog_General (
	EVENT_KEY						BIGINT			NOT NULL	PRIMARY KEY		IDENTITY(0,1),
	DATE_RECORDED_KEY				INT				NOT NULL	DEFAULT CONVERT(INT, CONVERT(VARCHAR(8), GETDATE(), 112)),
	DATETIME_RECORDED				DATETIME		NOT NULL	DEFAULT GETDATE(),
	EVENT_DATE_KEY					INT				NOT NULL,
	EVENT_DATETIME					DATETIME		NOT NULL,
	LOCAL_PORT						INT				NOT NULL,
	SENDER_IPV4_ADDRESS_KEY			BIGINT			NOT NULL    FOREIGN KEY REFERENCES IPv4_Records(ADDRESS_KEY),
	SENDER_PORT						INT				NOT NULL,
	PARSED_SENDER_IPV4_ADDRESS_KEY	BIGINT			NOT NULL    FOREIGN KEY REFERENCES IPv4_Records(ADDRESS_KEY),
	PRIORITY						INT				NOT NULL,
	PRIORITY_SEVERITY_KEY			INT				NOT NULL	FOREIGN KEY REFERENCES SyslogSeverityLevels(SEVERITY_KEY),
	PRIORITY_FACILITY_KEY			INT				NOT NULL	FOREIGN KEY REFERENCES SyslogFacilityLevels(FACILITY_KEY),
	MESSAGE_TAG						VARCHAR(16)		NOT NULL,
	MESSAGE_CONTENT					VARCHAR(1024)	NOT NULL
)
GO

----------------------------------------
CREATE TABLE Protocols (
	DecimalValue	INT				NOT NULL	PRIMARY KEY,
	Keyword			NVARCHAR(16),
	LongName		NVARCHAR(256)
)
GO

----------------------------------------
-- FUNCTION SETUP ----------------------
----------------------------------------
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'ConvertIPv4StringToDecimal' AND type = 'FN') BEGIN
	DROP FUNCTION dbo.ConvertIPv4StringToDecimal
	END
GO

CREATE FUNCTION ConvertIPv4StringToDecimal 
(
	@p_IPv4_String VARCHAR(15)
)
RETURNS BIGINT
AS
BEGIN
	DECLARE @result BIGINT
	DECLARE @rowMultiplier INT = 0
	DECLARE @xmlResults TABLE ( 
		octet INT
		)

	INSERT INTO @xmlResults
	SELECT 
		n.r.value('.', 'VARCHAR(50)')
	FROM (SELECT CAST('<r>' + REPLACE(@p_IPv4_String, '.', '</r><r>') + '</r>' AS XML)) AS s(XMLCol)
		CROSS APPLY s.XMLCol.nodes('r') AS n(r);

	-- This is magic.
	-- Assign a reverse order row number from 3 to 0 with no row sorting, multiplies the octet value
	-- by 256 ^ derived row number, then finally sums the decimalfied octets.
	WITH NumberMagic AS (
		SELECT
			x.octet * POWER(CAST(256 AS FLOAT), 4 - ROW_NUMBER() OVER (Order by (SELECT 0))) AS Scalar
		FROM @xmlResults x
		)
	SELECT
		@result = SUM(Scalar)
	FROM NumberMagic

	-- Return the result of the function
	RETURN @result

END
GO

----------------------------------------
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'ConvertIPv4DecimalToString' AND type = 'FN') BEGIN
	DROP FUNCTION dbo.ConvertIPv4DecimalToString
	END
GO

CREATE FUNCTION ConvertIPv4DecimalToString 
(
	@p_DecimalAddress BIGINT
)
RETURNS VARCHAR(15)
AS
BEGIN
	DECLARE @result VARCHAR(15)
	DECLARE @modulo BIGINT
	DECLARE @oct4 VARCHAR(3), 
			@oct3 VARCHAR(3), 
			@oct2 VARCHAR(3), 
			@oct1 VARCHAR(3)

	SET @oct4 = CONVERT(VARCHAR(3), @p_DecimalAddress / 16777216)
	SET @modulo = @p_DecimalAddress % 16777216
	SET @oct3 = CONVERT(VARCHAR(3), @modulo / 65536)
	SET @modulo = @modulo % 65536
	SET @oct2 = CONVERT(VARCHAR(3), @modulo / 256)
	SET @oct1 = CONVERT(VARCHAR(3), @modulo % 256)

	SET @result = @oct4 + '.' + @oct3 + '.' + @oct2 + '.' + @oct1

	RETURN @result

END
GO

----------------------------------------
-- SPROC SETUP -------------------------
----------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'CreateIPv4RecordFromString' AND type = 'P') BEGIN
	DROP PROCEDURE dbo.CreateIPv4RecordFromString
	END
GO

CREATE PROCEDURE CreateIPv4RecordFromString
	@p_AddressString	VARCHAR(15)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @newDecimal BIGINT = L1.dbo.ConvertIPv4StringToDecimal(@p_AddressString)

	IF NOT EXISTS (SELECT * FROM L1.dbo.IPv4_Records WHERE ADDRESS_KEY = @newDecimal) BEGIN
		INSERT INTO L1.dbo.IPv4_Records (ADDRESS_KEY, ADDRESS_STRING)
			VALUES (@newDecimal, @p_AddressString)
		END
END
GO

----------------------------------------
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'CreateIPv4RecordFromDecimal' AND type = 'P') BEGIN
	DROP PROCEDURE dbo.CreateIPv4RecordFromDecimal
	END
GO

CREATE PROCEDURE CreateIPv4RecordFromDecimal
	@p_AddressDecimal	VARCHAR(15)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @newString BIGINT = L1.dbo.ConvertIPv4DecimalToString(@p_AddressDecimal)

	IF NOT EXISTS (SELECT * FROM L1.dbo.IPv4_Records WHERE ADDRESS_KEY = @p_AddressDecimal) BEGIN
		INSERT INTO L1.dbo.IPv4_Records (ADDRESS_KEY, ADDRESS_STRING)
			VALUES (@p_AddressDecimal, @newString)
		END
END
GO

----------------------------------------
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'EventLog_Generic_CreateEntry' AND type = 'P') BEGIN
	DROP PROCEDURE dbo.EventLog_Generic_CreateEntry
	END
GO

CREATE PROCEDURE dbo.EventLog_Generic_CreateEntry 
	@p_eventDateTime			VARCHAR(30),
	@p_localPort				INT,
	@p_senderIPv4Address		VARCHAR(15),
	@p_senderPort				INT,
	@p_parsedSenderIPv4Address	VARCHAR(15),
	@p_priority					INT,
	@p_messageTag				VARCHAR(16),
	@p_messageContent			VARCHAR(1024)
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Convert the (fail) Syslog timestamp in to an SQL DATETIME
	DECLARE @convertedEventDateTime DATETIME = CONVERT(DATETIME, @p_eventDateTime, 0)
	
	-- Sender IPv4 record search/gen
	DECLARE @senderIp BIGINT = L1.dbo.ConvertIPv4StringToDecimal(@p_senderIPv4Address)
	IF NOT EXISTS (SELECT * FROM L1.dbo.IPv4_Records WHERE ADDRESS_KEY = @senderIp) BEGIN
		EXEC CreateIPv4RecordFromString @p_senderIPv4Address
		SET @senderIp = L1.dbo.ConvertIPv4StringToDecimal(@p_senderIPv4Address)
		END
	
	-- Parsed sender IPv4 record search/gen
	DECLARE @parsedSenderIp BIGINT = L1.dbo.ConvertIPv4StringToDecimal(@p_parsedSenderIPv4Address)
	IF NOT EXISTS (SELECT * FROM L1.dbo.IPv4_Records WHERE ADDRESS_KEY = @senderIp) BEGIN
		EXEC CreateIPv4RecordFromString @p_parsedSenderIPv4Address
		SET @parsedSenderIp = L1.dbo.ConvertIPv4StringToDecimal(@p_parsedSenderIPv4Address)
		END
	
	-- Priority parsing
	DECLARE @prioritySeverity INT = @p_priority % 8
	DECLARE @priorityFacility INT = @p_priority / 8
	
	
	INSERT INTO L1.dbo.EventLog_General (
			EVENT_DATE_KEY,
			EVENT_DATETIME,
			LOCAL_PORT,
			SENDER_IPV4_ADDRESS_KEY,
			SENDER_PORT,
			PARSED_SENDER_IPV4_ADDRESS_KEY,
			PRIORITY,
			PRIORITY_SEVERITY_KEY,
			PRIORITY_FACILITY_KEY,
			MESSAGE_TAG,
			MESSAGE_CONTENT
			)
		VALUES (
			CONVERT(INT, CONVERT(VARCHAR(8), @convertedEventDateTime, 112)),	-- EVENT_DATE_KEY
			@convertedEventDateTime,											-- EVENT_DATETIME
			@p_localPort,														-- LOCAL_PORT
			@senderIp,															-- SENDER_IPV4_ADDRESS_KEY
			@p_senderPort,														-- SENDER_PORT
			@parsedSenderIp,													-- PARSED_SENDER_IPV4_ADDRESS_KEY
			@p_priority,														-- PRIORITY
			@prioritySeverity,													-- PRIORITY_SEVERITY_KEY
			@priorityFacility,													-- PRIORITY_FACILITY_KEY
			@p_messageTag,														-- MESSAGE_TAG
			@p_messageContent													-- MESSAGE_CONTENT
			)
END
GO

----------------------------------------
-- USER ACCOUNT SETUP ------------------
----------------------------------------
IF NOT EXISTS (SELECT * FROM sys.syslogins WHERE name = N'agt_L1ServiceAgent') BEGIN
	CREATE LOGIN agt_L1ServiceAgent
		WITH PASSWORD = '',  -- this must be changed before the account will be created.
		CHECK_EXPIRATION = OFF,
		CHECK_POLICY = ON;
	IF @@ERROR <> 0 BEGIN
		PRINT 'ERROR creating login ''agt_L1ServiceAgent''.'
		RETURN
		END
	PRINT 'Created login ''agt_L1ServiceAgent''.'
	END
ELSE
	PRINT 'Login ''agt_L1ServiceAgent'' already exists.'
	
IF NOT EXISTS (SELECT * FROM sys.sysusers WHERE name = N'agt_L1ServiceAgent') BEGIN
	CREATE USER agt_L1ServiceAgent
		FOR LOGIN agt_L1ServiceAgent WITH DEFAULT_SCHEMA = [dbo];
	IF @@ERROR <> 0 BEGIN
		PRINT 'ERROR creating user ''agt_L1ServiceAgent'' and/or linking with login ''agt_L1ServiceAgent''.'
		RETURN
		END
	PRINT 'Created user ''agt_L1ServiceAgent'' and linked with login ''agt_L1ServiceAgent''.'
	END
ELSE
	PRINT 'User ''agt_L1ServiceAgent'' already exists.'
	
GRANT EXECUTE ON OBJECT::L1.dbo.EventLog_Generic_CreateEntry to agt_L1ServiceAgent;
GO

PRINT 'End of script.'