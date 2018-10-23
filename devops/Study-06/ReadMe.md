# kube 

## install 

### master 
<https://kubernetes.io/docs/setup/independent/install-kubeadm/#before-you-begin>

```bash
hostnamectl set-hostname 'master'
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# firewall off
systemctl disable firewalld

# docker install
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
systemctl start docker
systemctl enable docker

modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

#host 파일 설정
cat /etc/hosts
10.10.10.1 master
10.10.10.1 node01

# 스왑오프
```
swapoff -a # 임시로 스왑 오프 재부팅시 살아남.
vi /etc/fstab  # swap을 지우기 
```


#kube 설치 

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable kubelet && systemctl start kubelet
```

### init kube

```bash
kubeadm init
# 또는 
kubeadm init --pod-network-cidr=192.168.0.0/24
```

결과값
```bash
[preflight/images] You can also perform this action in beforehand using 'kubeadm config images pull'

Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run the following as a regular user:
```

이제 실행하자.

```
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

```
You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/
```
네트워크를 적용해야하는데 weave를 적용해보자. 자세한건 링크를 보자.

```
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

```

```
You can now join any number of machines by running the following on each node
as root:

kubeadm join 192.168.0.1:6443 --token 2ez9hl.q54j4wpkackfu6ay --discovery-token-ca-cert-hash sha256:ea44e08203949ca3ea474dd87c174c58e246c089fc2612c4545ea8aaa7f4d7e6


```

### node

마스터와 같이 설치를 한다. 
마지막에 join command만 추가로 해주면된다.

결과값
```
This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the master to see this node join the cluster.
```



### master에서 

master 에서 노드가 붙엇는지 확인할 필요가 있다. 

```
kubectl get nodes
```

결과

```
NAME     STATUS     ROLES    AGE     VERSION
master   NotReady   master   16m     v1.12.1
node02   NotReady   <none>   5m44s   v1.12.1
```

kubectl describe nodes master


## dashboard 배포 

kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml



https://204.16.116.71:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/




## 내컴에 kubectl 설치 & Kubernetes설치 

```
brew install kubectl 
```

docker run -d -p 8080:8080 asbubam/hello-node
curl http://localhost:8080


