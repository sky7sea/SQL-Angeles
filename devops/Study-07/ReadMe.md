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


## spineker

halyard
```
mkdir ~/.hal
chmod 777 ~/.hal
chmod -R  777 ~/.kube


docker run -p 8084:8084 -p 9000:9000 \
    --name halyard --rm \
    -v ~/.hal:/home/spinnaker/.hal \
    -v ~/.kube:/home/spinnaker/.kube \
    -d \
    gcr.io/spinnaker-marketplace/halyard:stable
```

command competion
```
source <(hal --print-bash-completion)
```

## Choose a cloud provider
컨테이너로 접속해서 
```
docker exec -it halyard bash
```

```
hal config provider kubernetes enable
```

* host에서 
```
cp ~/.kube/config .hal/kubeconfig
vi ~/.hal/config 

```

* 컨테이너로 접속해서 



```
hal config provider kubernetes account add my-k8s-v2-account \
    --provider-version v2 \
    --context $(kubectl config current-context)

hal config deploy edit --type distributed --account-name my-k8s-v2-account

```

## minio
https://www.minio.io/kubernetes.html 에서설정하고 generate누른다. 

![minio-01.PNG](minio-01)

호스트에서 

vi ~/minio-deployment.yaml

```yml
apiVersion: v1
kind: Service
metadata:
  name: minio
  labels:
    app: minio
spec:
  clusterIP: None
  ports:
    - port: 9000
      name: minio
  selector:
    app: minio
---
apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  name: minio
spec:
  serviceName: minio
  replicas: 4
  template:
    metadata:
      labels:
        app: minio
    spec:
      containers:
      - name: minio
        env:
        - name: MINIO_ACCESS_KEY
          value: "admin"
        - name: MINIO_SECRET_KEY
          value: "adminsecret"
        image: minio/minio
        args:
        - server
        - http://minio-{0...3}.minio.default.svc.cluster.local/data
        ports:
        - containerPort: 9000
        # These volume mounts are persistent. Each pod in the PetSet
        # gets a volume mounted based on this field.
        volumeMounts:
        - name: data
          mountPath: /data
  # These are converted to volume claims by the controller
  # and mounted at the paths mentioned above.
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 2Gi
      # Uncomment and add storageClass specific to your requirements below. Read more https://kubernetes.io/docs/concepts/storage/persistent-volumes/#class-1
      #storageClassName:
---
apiVersion: v1
kind: Service
metadata:
  name: minio-service
spec:
  type: LoadBalancer
  ports:
    - port: 9000
      targetPort: 9000
      protocol: TCP
  selector:
    app: minio
```

kubectl create -f ~/minio-deployment.yaml


# The next two lines should be run inside the docker container only

```bash
chcon -R --reference /root/.bashrc /root/.hal/
ls -lZa /root # Make sure the SELinux context is the same for all files/folders
```

echo $MINIO_SECRET_KEY | hal config storage s3 edit --endpoint $ENDPOINT \
    --access-key-id $MINIO_ACCESS_KEY \
    --secret-access-key # will be read on STDIN to avoid polluting your
                        # ~/.bash_history with a secret

hal config storage edit --type s3


# 디플로이 

컨테이너로 접속해서 
```
docker exec -it halyard bash
hal version list
```

```
- 1.7.8 (Ozark):
  Changelog: https://gist.github.com/spinnaker-release/75f98544672a4fc490d451c14688318e
  Published: Wed Aug 29 19:09:57 UTC 2018
  (Requires Halyard >= 1.0.0)
- 1.8.7 (Dark):
  Changelog: https://gist.github.com/spinnaker-release/ebb5e45e84de5b4381b422e3c8679b5a
  Published: Fri Sep 28 17:58:52 UTC 2018
  (Requires Halyard >= 1.0.0)
- 1.9.5 (Bright):
  Changelog: https://gist.github.com/spinnaker-release/d24a2c737db49dda644169cf5fe6d56e
  Published: Mon Oct 01 17:15:37 UTC 2018
  (Requires Halyard >= 1.0.0)
- 1.10.1 (Maniac):
  Changelog: https://gist.github.com/spinnaker-release/9a46f497a6e081e1ef8f12867b0ee3c6
  Published: Wed Oct 24 17:04:36 UTC 2018
  (Requires Halyard >= 1.11)
```

```
hal config version edit --version 1.10.1
hal deploy apply
```





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


## spineker

halyard
```
mkdir ~/.hal
chmod 777 ~/.hal
chmod -R  777 ~/.kube


docker run -p 8084:8084 -p 9000:9000 \
    --name halyard --rm \
    -v ~/.hal:/home/spinnaker/.hal \
    -v ~/.kube:/home/spinnaker/.kube \
    -d \
    gcr.io/spinnaker-marketplace/halyard:stable
```

command competion
```
source <(hal --print-bash-completion)
```

## Choose a cloud provider
컨테이너로 접속해서 
```
docker exec -it halyard bash
```

```
hal config provider kubernetes enable
```

* host에서 
```
cp ~/.kube/config .hal/kubeconfig
vi ~/.hal/config 

```

* 컨테이너로 접속해서 



```
hal config provider kubernetes account add my-k8s-v2-account \
    --provider-version v2 \
    --context $(kubectl config current-context)

hal config deploy edit --type distributed --account-name my-k8s-v2-account

```

## minio
https://www.minio.io/kubernetes.html 에서설정하고 generate누른다. 

![minio-01.PNG](minio-01)

호스트에서 

vi ~/minio-deployment.yaml

```yml
apiVersion: v1
kind: Service
metadata:
  name: minio
  labels:
    app: minio
spec:
  clusterIP: None
  ports:
    - port: 9000
      name: minio
  selector:
    app: minio
---
apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  name: minio
spec:
  serviceName: minio
  replicas: 4
  template:
    metadata:
      labels:
        app: minio
    spec:
      containers:
      - name: minio
        env:
        - name: MINIO_ACCESS_KEY
          value: "admin"
        - name: MINIO_SECRET_KEY
          value: "adminsecret"
        image: minio/minio
        args:
        - server
        - http://minio-{0...3}.minio.default.svc.cluster.local/data
        ports:
        - containerPort: 9000
        # These volume mounts are persistent. Each pod in the PetSet
        # gets a volume mounted based on this field.
        volumeMounts:
        - name: data
          mountPath: /data
  # These are converted to volume claims by the controller
  # and mounted at the paths mentioned above.
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 2Gi
      # Uncomment and add storageClass specific to your requirements below. Read more https://kubernetes.io/docs/concepts/storage/persistent-volumes/#class-1
      #storageClassName:
---
apiVersion: v1
kind: Service
metadata:
  name: minio-service
spec:
  type: LoadBalancer
  ports:
    - port: 9000
      targetPort: 9000
      protocol: TCP
  selector:
    app: minio
```

kubectl create -f ~/minio-deployment.yaml

ENDPOINT: The fully-qualifed endpoint Minio is reachable on. 
If Minio is running on the same machine as Spinnaker,
 this might be http://204.16.116.84:9001.

vi ~/.hal/default/profiles/front50-local.yml

spinnaker.s3.versioning: false


호스트에서 

```bash
chcon -R --reference /root/.bashrc /root/.hal/
ls -lZa /root # Make sure the SELinux context is the same for all files/folders
```

도커에서 
```bash
docker exec -it halyard bash
echo adminsecret | hal config storage s3 edit \
    --endpoint http://204.16.116.84:9001 \
    --access-key-id admin \
    --secret-access-key 
# will be read on STDIN to avoid polluting your ~/.bash_history with a secret

hal config storage edit --type s3
```


# 디플로이 

컨테이너로 접속해서 
```
docker exec -it halyard bash
hal version list
```

```
- 1.7.8 (Ozark):
  Changelog: https://gist.github.com/spinnaker-release/75f98544672a4fc490d451c14688318e
  Published: Wed Aug 29 19:09:57 UTC 2018
  (Requires Halyard >= 1.0.0)
- 1.8.7 (Dark):
  Changelog: https://gist.github.com/spinnaker-release/ebb5e45e84de5b4381b422e3c8679b5a
  Published: Fri Sep 28 17:58:52 UTC 2018
  (Requires Halyard >= 1.0.0)
- 1.9.5 (Bright):
  Changelog: https://gist.github.com/spinnaker-release/d24a2c737db49dda644169cf5fe6d56e
  Published: Mon Oct 01 17:15:37 UTC 2018
  (Requires Halyard >= 1.0.0)
- 1.10.1 (Maniac):
  Changelog: https://gist.github.com/spinnaker-release/9a46f497a6e081e1ef8f12867b0ee3c6
  Published: Wed Oct 24 17:04:36 UTC 2018
  (Requires Halyard >= 1.11)
```

```
hal config version edit --version 1.10.1
hal deploy apply
```




## kube dashboard설치 

kubectl get pods --all-namespaces | grep dashboard

$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

To access Dashboard from your local workstation you must create a secure channel to your Kubernetes cluster. Run the following command:
```
$ kubectl proxy
```

kubectl -n kube-system edit service kubernetes-dashboard

화면에서 yml을 수정한다. 

clusterIp를 nodeport로 변경한다. 

kubectl -n kube-system get service kubernetes-dashboard

Dashboard has been exposed on port 31707 (HTTPS). 
Now you can access it from your browser at: https://<master-ip>:31707.

https://www.com:31707

확인이 가능하다. 

로그인은 token이나 kube설정으로 가능하네?

kubectl get secrets

NAME                  TYPE                                  DATA   AGE
default-token-6pb8d   kubernetes.io/service-account-token   3      3h20m

kubectl describe secrets default-token-6pb8d

```
Name:         default-token-6pb8d
Namespace:    default
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: default
              kubernetes.io/service-account.uid: 05de009b-da2b-11e8-a5ac-0026b95e309d

Type:  kubernetes.io/service-account-token

Data
====
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImRlZmF1bHQtdG9rZW4tNnBiOGQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGVmYXVsdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjA1ZGUwMDliLWRhMmItMTFlOC1hNWFjLTAwMjZiOTVlMzA5ZCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmRlZmF1bHQifQ.4YPh4OG1HVxooKqMkZh8eljlbmXZAsM8bIC31_OeuattuhR4-Kt8tcKOXmYQG9Bi3H-reY6-RmWGTGIVRuQhluE0mJHdCoTju7Smgwxdh4ku9oJ_I04KZ-S9DPh8xcwO720noCOJ3WJBRiPTrRA7M_W_AeSEcgTXXgyAuH5fG6gyZvu6oG6lE192Yj9-7ddJzIzBsMndJ5MMemC3WHLsfFCY8NgUq0q9_noTSPEdzuvu3MClJWa2u0FrrlM4T_P3ggmbYCz_eX4yAyPFnhFqV6CUQvhvxQJGu9mF0iugrkKPqGpv_Oznlc0R9h0upztaZcf-lUwIi8VxpluztlwkUQ
ca.crt:     1025 bytes
namespace:  7 bytes
```

토큰을 복사하면 접혹이 된다.


서비스 포트 확인





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

## git에서 브랜치 관리법

## git flow설명 가능?




### spinnaker - https://www.spinnaker.io/

### traffic - reverse proxy

