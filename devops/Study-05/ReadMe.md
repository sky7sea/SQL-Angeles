
## project 생성  - gitlab

## git clone => git commit => git push 

## project clone 

## project code add 

## git commit 

## git에서 브랜치 관리법

## git flow설명 가능?

## 백앤드 생성 

## frontend 생성 



## docker

### docker 기본

### docker file

도커 이미지 빌드

docker registry에 추가

이제 다른서버에서 up 



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

### k8s



## install 3 vm 

master node01 node02

vagrant up 

## install kube 

* Master



```bash
sudo bash
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
echo '1' > /proc/sys/net/ipv4/ip_forward
swapoff -a

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl
systemctl enable kubelet.service
systemctl start kubelet.service
exit
```

확인 

kubectl version

* init 

```
sudo yum install kubeadm  -y
kubeadm init
```

* Node


### spinnaker - https://www.spinnaker.io/

### traffic - reverse proxy

