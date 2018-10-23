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



## 실습

vi hello-node.yml

```yml
---
apiVersion: v1
kind: Pod
metadata:
  name: hello-node
  labels:
    service-name: hello-node
spec:
  containers:
  - name: hello-node
    image: asbubam/hello-node
    readinessProbe:
      httpGet:
        path: /
        port: 8080
    livenessProbe:
      httpGet:
        path: /
        port: 8080

---
apiVersion: v1
kind: Service
metadata:
  name: hello-node
spec:
  type: LoadBalancer
  ports:
  - port: 8080
    nodePort: 8080
  selector:
    service-name: hello-node
```

service type은 다음중 하나 고를수 있다. 

* LoadBalancer
* NodePort
* ClusterIP

```bash
# kubectl get pods 명령으로 Pod list를 조회해보면 아직 아무것도 없다.
$ kubectl get pods
No resources found.

# kubectl create -f {yaml 파일명} 으로 Pod을 생성한다.
$ kubectl create -f hello-node.yml
pod "hello-node" created
service "hello-node" created

# kubectl get pods 결과에 1개의 Pod이 생성되고 있음을 확인할 수 있다.
$ kubectl get pods
NAME         READY     STATUS              RESTARTS   AGE
hello-node   0/1       ContainerCreating   0

# Pod이 정상적으로 실행되면 잠시 후에 아래와 같이 STATUS가 Running으로 update된다.
$ kubectl get pods
NAME         READY     STATUS    RESTARTS   AGE
hello-node   1/1       Running   0          13s

$ kubectl describe pods


# localhost:8080에 접속해서 Hello World! 가 출력됨을 확인한다.
$ curl http://192.168.0.2:31806
Hello World!
```

kubectl delete pods hello-node
kubectl delete svc hello-node


## expose 

kubectl expose rc hello-rc --name=hello-svc --target-port=8080 --type=NodePort

kubectl describe svc hello-svc

```
Name:                     hello-svc
Namespace:                default
Labels:                   app=hello-world
Annotations:              <none>
Selector:                 app=hello-world
Type:                     NodePort
IP:                       10.106.99.220
Port:                     <unset>  8080/TCP
TargetPort:               8080/TCP
NodePort:                 <unset>  31295/TCP <== here
Endpoints:                10.40.0.10:8080,10.40.0.11:8080,10.40.0.12:8080 + 7 more...
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```

curl 192.168.0.1:31295  

결과값 확인됨 

kubectl을  yml로 변경해보자.

$ kubectl get svc
NAME         TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
hello-node   LoadBalancer   10.104.128.151   <pending>     8080:30690/TCP   6h2m
hello-svc    NodePort       10.106.99.220    <none>        8080:31295/TCP   5m57s

$ kubectl delete svc hello-svc
service "hello-svc" deleted






