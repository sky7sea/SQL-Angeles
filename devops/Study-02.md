# devops - 02

## virtual box install

## vagrant install 

## vagrant로 가상머신에 centos 7 설치
```bash
# macos
mkdir -p ~/Desktop/GitHub/SQL-Angeles/devops/vm
cd ~/Desktop/GitHub/SQL-Angeles/devops/vm

# windows
mkdir -p c:\SQL-Angeles\devops\vm
cd c:\SQL-Angeles\devops\vm

vagrant init centos/7 --minimal

code Vagrantfile
```

```
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
end
```

```
vagrant up 

"C:\Program Files\Oracle\VirtualBox\VirtualBox.exe"
```

## vm 에 접속해서 도커 설치하기

```bash
vagrant ssh 

curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

sudo usermod -aG docker vagrant

sudo systemctl enable docker #도커 재시작시 자동 

sudo reboot # 재부팅

#sudo systemctl start docker #도커 데몬 실행
#sudo docker ps -a # 도커프로세스가 돌고 
```

재부팅후 docker daemon이 돌고 있는지 확인하자.

```
vagrant ssh 
docker ps -a 
```

잘 동작한다.




