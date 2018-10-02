# devops - 03

## virtual box extension pack install

http://download.virtualbox.org/virtualbox/5.2.18/Oracle_VM_VirtualBox_Extension_Pack-5.2.18.vbox-extpack

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
      external_url 'http://localhost:8080'
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

## 깃허브 데이크탑 어플리케이션 설치 
* <https://desktop.github.com>
vag 
download and install 



## 깃랩 사용법 



clone 

commit 





## 깃랩 활동에 따른 이메일 받기

### mailgun 서비스 가입 및 설정

https://www.mailgun.com/ 에 회원가입을 한다.

https://app.mailgun.com/app/domains 에서 Add New Domain 을 누른다.

https://app.mailgun.com/app/domains 에서 방금 만든 도메인을 누른다.

Domain Verification & DNS 를 보면 두개의 txt 를 도메인 dns에 추가해야한다고 나온다 추가하자.

mx레코드는 이메일을 받을때 사용하는것이므로 하지 않아도 된다.

다 적용을 햇으면 check dns record now 버튼을 누르자. dns가 업데이트가 되므로 시간이 좀 걸리는 수도 있다. 실패하면 잠시후에 다시 해본다.

체크가 되면 빨간색 에러 마크가 초록색으로 바뀐다.

이제 같은 페이지에 제일 상단 Domain Information 가보자.

여기에 보면 이메일을 보낼때 필요한 정보가 다 있다. 그 정보를 깃랩 설정에 적어주면 된다.

### 깃랩에서 설정 하자. 

```
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.mailgun.org"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_authentication'] = "plain"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_user_name'] = "postmaster@mg.gitlab.com"
gitlab_rails['smtp_password'] = "XXXXXXX"
gitlab_rails['smtp_domain'] = "mg.gitlab.com"
```


## 실제 www서버를 만들어보자. 

기기에 소스코드를 넣어보자. 

## 이제 소스코드를 커밋하자. 

간단히 github client를 받자. 

## 변경 및 커밋 


git에서 브랜치 관리법


## git flow설명 가능?



## jenkins로 셋업 

docker pull jenkins/jenkins:lts





## docker
### docker 기본
### docker file
### k8s
### spinnaker - https://www.spinnaker.io/


