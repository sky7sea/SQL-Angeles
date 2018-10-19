# study-04

## virtual box re-install

## virtual box plugin install
꼭 해야함. 
<http://download.virtualbox.org/virtualbox/5.2.18/Oracle_VM_VirtualBox_Extension_Pack-5.2.18.vbox-extpack>

## vagrant re-install

## vagant up 
```bash
cd /Users/ragon/Desktop/SQL-Angeles/devops/Study-04
vagrant up
vagrant ssh # vm으로 접속
```
으로 확인

http://localhost:8080





## git에서 브랜치 관리법

## git flow설명 가능?

## jenkins로 셋업 

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

### k8s

### spinnaker - https://www.spinnaker.io/

### traffic - reverse proxy


