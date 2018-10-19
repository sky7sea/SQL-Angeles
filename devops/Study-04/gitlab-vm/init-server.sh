#!/bin/bash

# yum check-update

# yum update

curl -fsSL get.docker.com -o get-docker.sh

sh get-docker.sh

usermod -aG docker vagrant

systemctl enable docker

systemctl start docker

curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

# iptable off 
systemctl disable firewalld

# selinux off
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

# cd /data/docker/gitlab && docker-compose up -d



