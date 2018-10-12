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
