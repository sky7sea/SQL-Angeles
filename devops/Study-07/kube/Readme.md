https://medium.com/humanscape-tech/kubernetes-%EB%8F%84%EC%9E%85-%EC%A0%84-minikube-%EC%82%AC%EC%9A%A9%EA%B8%B0-2eb2b6d8e444


minikube start


eval $(minikube docker-env)


kubectl run hello-node --image=hello-node:v1 --port=8080 --image-pull-policy=Never

kubectl get pods

error 

docker build -t hello-node:v1 .

kubectl get pods

kubectl get events

kubectl config view

외부에서 엑세스 가능하게 만들려면 아래 명령어를 통해 외부로 노출시켜야합니다.

kubectl expose deployment hello-node --type=LoadBalancer

docker build -t hello-node:v2 .


kubectl set image deployment/hello-node hello-node=hello-node:v2 
kubectl set image deployment/hello-node hello-node=hello-node:v2 

서비스 삭제 

kubectl delete service hello-node

우선 클러스터 안에 hello-node service와 deployment 를 제거합니다.

$ kubectl delete serveci hello-node
$ kubectl delete deployment hello-node
그리고 선택적으로 도커 이미지를 삭제, Minikube VM 정지, 그리고 삭제까지 해주시면 됩니다.

$ docker rmi hello-node:v1 hello-node:v2 -f
$ minikube stop
$ eval $(minikube docker-env -u)
$ minikube delete



|명령어|설명|
|minikube addons|미니큐브의 쿠버네티스 애드온 변경|
|minikube cache|로컬 캐시에서 이미지 추가/삭제|
|minikube completion|Outputs minikube shell completion for the given shell (bash or zsh)|
|minikube config|미니큐브 설정 변경|
|minikube dashboard|Opens/displays the kubernetes dashboard URL for your local cluster|
|minikube delete|로컬 쿠버네티스 클러스터 삭제|
|minikube docker-env|도커 환경변수 설정하기. $(docker-machine env)와 유사함|
|minikube get-k8s-versions|로컬큐브 부트스트래퍼를 사용할 때 미니큐브에 사용가능한 쿠버네티스 버전 목록 조회|
|minikube ip|실행중인 클러스터의 IP 주소 조회|
|minikube logs|실해중인 로컬큐브 인스턴스의 로그 조회. (사용자 코드가 아니라) 미니큐브 디버깅에 사용|
|minikube mount|미니큐브에 특정 디렉토리 마운트|
|minikube profile|Profile sets the current minikube profile|
|minikube service|Gets the kubernetes URL(s) for the specified service in your local cluster|
|minikube ssh|Log into or run a command on a machine with SSH; similar to 'docker-machine ssh'|
|minikube ssh-key|Retrieve the ssh identity key path of the specified cluster|
|minikube start|Starts a local kubernetes cluster|
|minikube status|Gets the status of a local kubernetes cluster|
|minikube stop|Stops a running local kubernetes cluster|
|minikube update-check|현재 및 최신버전 출력 |
|minikube update-context|Verify the IP address of the running cluster in kubeconfig.|
|minikube version| 현재 버전 출력 |