# kube

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



