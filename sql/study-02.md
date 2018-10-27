# mssql 2017 on linux

```bash
mkdir -p ~/Desktop/mssql
cd ~/Desktop/mssql

docker run --name mssql -e 'ACCEPT_EULA=Y' -e 'MSSQL_SA_PASSWORD=StrongPassw0rd' -p 1433:1433  -d microsoft/mssql-server-linux:latest
```

## restore AdventureWorks2017

## backup 파일 다운로드 및 컨테이너에 복사

```bash
# brew install

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update

brew install wget

# bak file download
wget https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2017.bak

# create folder into container
docker exec -it mssql mkdir /var/opt/mssql/backup 

# copy into container
docker cp ~/Desktop/mssql/AdventureWorks2017.bak mssql:/var/opt/mssql/backup/AdventureWorks2017.bak
```

### sql excute

```sql
-- get localname
RESTORE filelistonly FROM DISK = '/var/opt/mssql/backup/AdventureWorks2017.bak'

--결과
--AdventureWorks2017	C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQL2017RTM\MSSQL\DATA\AdventureWorks2017.mdf	D
--AdventureWorks2017_log	C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQL2017RTM\MSSQL\DATA\AdventureWorks2017_log.ldf	L

-- 복구 
RESTORE DATABASE AdventureWorks2017 FROM DISK = '/var/opt/mssql/backup/AdventureWorks2017.bak' WITH MOVE 'AdventureWorks2017' TO '/var/opt/mssql/backup/AdventureWorks2017.mdf', MOVE 'AdventureWorks2017_Log' TO '/var/opt/mssql/backup/AdventureWorks2017.ldf', REPLACE
```

## docker stop and start

작업이 끝낫으므로 도커를 멈추고 나중에 다시 시작하자.
```bash
docker stop mssql
docker start mssql 
```

## 클라이언트로 붙여서 연습해본다. 

