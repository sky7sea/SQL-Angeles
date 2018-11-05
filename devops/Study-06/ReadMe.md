## jenkins 셋업 

## git clone 

## restapi 생성
```
dotnet new webapi
dotnet restore 
dotnet watch 
```

http://localhost


## git에 푸시


docker pull jenkins/jenkins:lts

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






