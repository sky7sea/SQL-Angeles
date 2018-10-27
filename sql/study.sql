select *
from sys.databases

select @@VERSION

-- Create a new database called 'Sample'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
  SELECT name
FROM sys.databases
WHERE name = N'Sample'
)
CREATE DATABASE Sample
GO

-- sample 디비가 생겻는지 확인
select *
from sys.databases


SELECT
  *
FROM
  SYSOBJECTS
WHERE
  xtype = 'U';
GO

RESTORE DATABASE AdventureWorks2017 FROM DISK = '/var/opt/mssql/backup/AdventureWorks2017.bak' WITH MOVE 'AdventureWorks2017' TO '/var/opt/mssql/backup/AdventureWorks2017.mdf', MOVE 'AdventureWorks2017_Log' TO '/var/opt/mssql/backup/AdventureWorks2017.ldf', REPLACE

use AdventureWorks2017

SELECT
  *
FROM
  SYSOBJECTS
WHERE
  xtype = 'U'
Order by name
GO


select * from Purchasing.Vendor






