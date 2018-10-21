# study-04

## macos

 * virtual box re-install

 * virtual box plugin install 꼭 해야함. 

<http://download.virtualbox.org/virtualbox/5.2.18/Oracle_VM_VirtualBox_Extension_Pack-5.2.18.vbox-extpack>

 * vagrant re-install


```bash
cd /Users/ragon/Desktop/SQL-Angeles/devops/Study-04/gitlab-vm
vagrant up
vagrant ssh # vm으로 접속

## gitlab 실행
cd /data/docker/gitlab && docker-compose up -d 
docker exec gitlab_web_1 update-permissions
docker restart gitlab_web_1
docker logs -f gitlab_web_1
```



## windows

* hyper-v 를 설치한다.
* cmd를 어드민 권한으로 실행한다. 
* Study-04/gitlab-vm 폴더로 이동한다. 

```bash
vagrant up --provider hyperv

==> default: Importing a Hyper-V instance
    default: Creating and registering the VM...
    default: Successfully imported VM
    default: Please choose a switch to attach to your Hyper-V instance.
    default: If none of these are appropriate, please open the Hyper-V manager
    default: to create a new virtual switch.
    default: 1) nat
    default: 2) Default Switch
    default: 3) DockerNAT

# 2번을 선택한다. 
2

# windows userid/ pass를 입력한다. 공유 폴더에 접속하기 위해서
```

## gitlab을 실행하자. 

```
vagrant ssh
cd /data/docker/gitlab && docker-compose up -d
docker exec gitlab_web_1 update-permissions
docker restart gitlab_web_1
docker logs -f gitlab_web_1
```

## 확인 
* site가 vm에서 실행중인지 확인

curl http://localhost:8080 으로 확인

* vm에 접속하여 ip 확인 

```
ifconfig

  eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
  inet 172.17.30.163  netmask 255.255.255.240  broadcast 172.17.30.175
  inet6 fe80::215:5dff:fe20:104  prefixlen 64  scopeid 0x20<link>
  ether 00:15:5d:20:01:04  txqueuelen 1000  (Ethernet)
  RX packets 415694  bytes 623277846 (594.4 MiB)
  RX errors 0  dropped 0  overruns 0  frame 0
  TX packets 54637  bytes 4926794 (4.6 MiB)
  TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

ip를 확인하면 http://172.17.30.163:8080 으로 하면 됨 


http://localhost:8080

## 동영상 
<https://www.youtube.com/watch?v=wozrPlJZFGs> 추가



