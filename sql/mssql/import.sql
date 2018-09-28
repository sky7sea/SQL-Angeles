-- get localname
RESTORE filelistonly FROM DISK = '/var/opt/mssql/backup/AdventureWorks2017.bak'

--결과
--AdventureWorks2017	C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQL2017RTM\MSSQL\DATA\AdventureWorks2017.mdf	D
--AdventureWorks2017_log	C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQL2017RTM\MSSQL\DATA\AdventureWorks2017_log.ldf	L

-- 복구 
RESTORE DATABASE AdventureWorks2017 FROM DISK = '/var/opt/mssql/backup/AdventureWorks2017.bak' WITH MOVE 'AdventureWorks2017' TO '/var/opt/mssql/backup/AdventureWorks2017.mdf', MOVE 'AdventureWorks2017_Log' TO '/var/opt/mssql/backup/AdventureWorks2017.ldf', REPLACE
