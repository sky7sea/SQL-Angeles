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

## jenkins run 

docker pull jenkins/jenkins:lts

docker run -p 9000:8080 -p 50000:50000 jenkins/jenkins:lts




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






