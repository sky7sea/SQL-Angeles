# gitlab & jenkins 연동

## gitlab & jenkins docker up 

```
cd Study-06/gitlab-jenkins-vm
vagrant up
vagrant ssh 
cd /data/docker
docker-compose up -d
```

## gitlab 초기 설정

앞 강의 참고하여 초기 설정을 한다. 유저도 만들고 프로젝트도 만든다. 

http://localhost:8080

create project : test 


## git clone ( on laptop )
```
mkdir Desktop/test
cd Desktop/test
cat ~/.ssh/id_rsa.pub
```
ssh key를 gitlab에 user >> ssh-key에 추가 (http://localhost:8080/profile/keys)

```
git clone ssh://git@localhost:30022/root/test.git .
```

## restapi 생성
```
dotnet new webapi
dotnet restore 
dotnet watch run
```

http://localhost:5000/api/values 

or 

https://localhost:5001/api/values

값 확인 

## git에 푸시
```
git add --all
git commit -m "webapi added"
git push 
```


## jenkins 초기 설정 
가상 머신으로 접속한후 
```bash
vagrant ssh 
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword 
```
나온 값을 저장해둔다. 

http://localhost:9000

복사해둔 값을 넣고 설치를 진행한다. suggested plugin으로 설치하면 된다.

## jenkins ssh-key 생성 

docker exec -it jenkins ssh-keygen

엔터 엔터 엔터 

docker exec -it jenkins cat /var/jenkins_home/.ssh/id_rsa.pub

나온 값을 복사해둔다. 

## gitlab에 project에 deploy key 생성 

left menu >> setting >> repository >> deploy key >> expend

위에서 복사해둔 값을 넣는다. 

## jenkins 프로젝트 생성 
프로젝트 생성 전에 gitlab의 내부 아이피를 알아야한다. 
```
docker inspect gitlab
> "Gateway": "172.19.0.1",
> "IPAddress": "172.19.0.3",
```
아이피를 젠킨스에서 설정해야한다.

ssh키 known host 추가 
```
docker exec -it jenkins ssh 172.19.0.3 
> yes
```
create new project 

freestyle 

Source Code Management >> git >> ssh://git@172.18.0.3/root/test.git

save 클릭 >> build 클릭 

workspace 에서 코드들이 보이면 성공 

깃랩에서 코드를 가져오는건 성공 

## jenkins web hook

젠킨스에 gitlab 플러그인 설치 

프로젝트에 configure 페이지 에서 아래 체크박스를 켠다.
```
Build when a change is pushed to GitLab. GitLab webhook URL: http://localhost:9000/project/test dl
```

Advence button click >> Secret token >> generate 

생성된 키를 복사한다.

## gitlab webhook trigger 

admin >> setting >> network >> Outbound requests

http://localhost:8080/admin/application_settings/network

turn on Allow requests to the local network from hooks and services

project >> setting >> integration >> http://jenkins:8080/project/test

위에 url을 붙여 넣는다.

security key를 붙여 넣는다. 

저장 


커밋하면 자동으로 젠킨스가 실행된다.

## docker build 

기본 패키지에 dotnet core가 포함되있지 않다. 

젠킨스 이미지를 가져와서 추가해보자. 


```
vagrant ssh 
docker exec -it jenkins bash

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
wget -q https://packages.microsoft.com/config/debian/9/prod.list
sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
```

docker run -p 8081:8080 -p 50001:50001 jenkins/jenkins:lts-alpine




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














