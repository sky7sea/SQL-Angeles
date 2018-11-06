## jenkins 셋업 

## git clone
```
mkdir test
cd test 
git clone ssh://git@204.16.116.84:30022/root/smiley.git .
```

## restapi 생성
```
dotnet new webapi
dotnet restore 
dotnet watch
dotnet run 
```

http://localhost/api/values

## git에 푸시
```
git add --all
git commit -m "webapi added"
git push 
```

## gitlab token 생성

gitlab http://204.16.116.84:8080/profile

access token http://204.16.116.84:8080/profile/personal_access_tokens

이름 주고 권한 주고 create personal token 

이름과 token을 복사해둔다. 

## jenkins run

```bash
mkdir /data/jenkins_home
docker pull jenkins/jenkins:lts
docker run -p 9000:8080 -p 50000:50000 jenkins/jenkins:lts -d

vagrant ssh >> docker exec -it jenkins bash 

cat /var/jenkins_home/secrets/initialAdminPassword
```

http://localhost:9000

password 

plugin 선택후 로그인

manage jenkins >> config system >> Gitlab >>

connection name : test

gitlab host url : http://204.16.116.84:8080

add credential : 
>> domain  global
kind : gitlab api token 


create project  AAA





## build후 server에 자동으로 푸시 (msbuild ms deploy 사용) 

## windows virtual box image 필요
<https://developer.microsoft.com/en-us/windows/downloads/virtual-machines>
또는 
https://app.vagrantup.com/mwrock/boxes/Windows2016

```
Vagrant.configure("2") do |config|
  config.vm.box = "mwrock/Windows2016"
end
```



## docker

### docker 기본

### docker file

도커 이미지 빌드

docker registry에 추가

이제 다른서버에서 up 



# 2nd try 

docker-compose up -d

### gitlab
gitlab setup / password

login 후 pernal api key 생성  >> user>> setting >> access token 

http://localhost:8080/profile/personal_access_tokens

name key를 복사해두면됨. 

test/fGsH297smbQsZz6YE-sH

create project : test 


### jenkins
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword

키를 복사해두고 

http://localhost:9000/ 접속해서 복사해둔 키를 넣고 설치 진행

credential >> system >> global 

manage jenkins >> configure system >> 

create new project 

freestyle 








