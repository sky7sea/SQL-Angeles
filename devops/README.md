# devops

## virtual box install

## vagrant install 

## vagrant로 가상머신에 centos 7 설치
```bash
cd ~/Desktop/GitHub/SQL-Angeles/devops/vm
vagrant init centos/7 --minimal

cat Vagrantfile
```

```
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
end
```

```
vagrant up 
```

