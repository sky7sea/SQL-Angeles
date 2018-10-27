# study 05


## git 설치 

* windows - https://git-scm.com/download/win download and install 

* macosx - brew
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew install git
```


## gitlab project 생성

* new project => first

## ssh key 생성 

```bash
cat ~/.ssh/id_rsa.pub
# 없으면 
ssh-keygen -t rsa
enter
enter 

# 다시 
cat ~/.ssh/id_rsa.pub
```

윈도우 유저는 git bash를 실행해서 위처럼 하면된다.

## add key 
* add ssh key  :   http://localhost:8080/profile/keys 

복사해서 여기에 넣고 add 버튼 클릭

## gitlab clone
```bash
mkdir ~/Desktop/git01
cd ~/Desktop/git01
git clone ssh://git@localhost:30022/root/first.git
```

## change code 

add test file 
```
git add --all 
git commit -m test
git push 
```

## gitlab에서 확인해본다. 

http://localhost:8080/root/first

test가 생겻음을 확인하다.

## 2번째 유저를 가정하고 해보자. 
```
mkdir ~/Desktop/git02
cd ~/Desktop/git02
git clone ssh://git@localhost:30022/root/first.git
```

클론을 받으면 이제 추가된 파일까지 받는걸 알수 있다.

## github desktop을 사용해보자. 

git02/first 폴더를 드래그해서 githubdesktop에 놓는다. 

test 파일을 지운다. 

github desktop을 확인해보자.

커밋하고 푸시하자.

gitlab 웹사이트에서 확인한다.

### 백앤드 생성 

### frontend 생성 

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

## git에서 브랜치 관리법

## git flow설명 가능?





