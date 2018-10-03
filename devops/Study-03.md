# devops - 03

## 윈도우 git 을 설치

## 깃허브 데이크탑 어플리케이션 설치 
* <https://desktop.github.com> download and install 


## virtual box extension pack install

<http://download.virtualbox.org/virtualbox/5.2.18/Oracle_VM_VirtualBox_Extension_Pack-5.2.18.vbox-extpack>

다운로드후 더블클릭.

## vagrant virtualbox plugin install
```
vagrant up
vagrant plugin install vagrant-vbguest
vagrant halt
vagrant up 
```

## 기존 내용 snapshot
```bash
vagrant snapshot save init
```

## vagrant 설정 변경
```bash
code C:\SQL-Angeles\devops\vm\Vagrantfile
```

```
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4048"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end  
end
```

## docker-compose install
```
vagrant ssh 

sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
docker-compose -h
```

## gitlab 설치 

참고 https://docs.gitlab.com/omnibus/docker/

```bash
vagrant ssh 
sudo mkdir -p /data/docker/gitlab
sudo chown -R vagrant:vagrant /data
cd /data/docker/gitlab
vi docker-compose.yml
```

```yml
---
web:
  image: 'gitlab/gitlab-ce:latest'
  restart: always
  hostname: 'localhost'
  environment:
    GITLAB_OMNIBUS_CONFIG: |
      external_url 'http://localhost'
      # Add any other gitlab.rb configuration here, each on its own line
      gitlab_rails['gitlab_shell_ssh_port'] = 30022
  ports:
    - '80:80'
    - '443:443'
    - '30022:22'
  volumes:
    - '/srv/gitlab/config:/etc/gitlab'
    - '/srv/gitlab/logs:/var/log/gitlab'
    - '/srv/gitlab/data:/var/opt/gitlab'
```

```
cd /data/docker/gitlab
docker-compose up -d
```

## 잘 안되면 다음 시도
```
docker exec gitlab_web_1 update-permissions
docker restart gitlab_web_1
docker logs -f gitlab_web_1
```

## gitlab webpage 확인

<http://localhost:8080>


## after gitlab install snapshot
```
vagrant snapshot save after-gitlab
vagrant snapshot list
```

## 회원가입 취소 

초기 화면에서 회원가입이 있으면 회사 내부만 쓰려고 하던 목적에 맞지 않는다. 없애보자.

http://gitlab.xgridcolo.com/admin/application_settings
로그인 » admin area » Sign-up restrictions » Sign-up enabled 을 off하면된다.

## 유저 추가
http://gitlab.xgridcolo.com/admin/users/new 에서 유저를 추가한다. 그리고 유저 리스트로 가면 설정버튼이 보인다.

설정버튼을 눌러서 들어가면 비밀번호를 세팅할수 있다.

이제 사용자에게 알려줘서 접속하라고 하면된다.



## email notification 
* <https://teamsmiley.github.io/2018/09/06/docker-gitlab/> 여기 참고

## 깃랩 사용법 

## generate ssh key 




## add ssh key to gitlab

## git clone terminal

## change code 

## git push - terminal

## github desktop application

## add local repository

## change code 

## commit and push 

여기까지 동영상 

<https://www.youtube.com/watch?v=xl-DsO2y5Vs>
