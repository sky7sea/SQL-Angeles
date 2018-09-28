# devops - 02

## virtual box install

## vagrant install 

## vagrant로 가상머신에 centos 7 설치
```bash
cd ~/Desktop/GitHub/SQL-Angeles/devops/vm
vagrant init centos/7 --minimal

cat Vagrantfile
```

```
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
end
```

```
vagrant up 
```

## vm 에 접속해서 도커 설치하기 
```
vagrant ssh 

curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

sudo usermod -aG docker vagrant

```



