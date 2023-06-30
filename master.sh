#!/bin/bash

# This is a sample script
echo "Hello, this is my CentOS 7 script!"
echo "Today's date is: $(date)"
systemctl stop firewalld
systemctl disable firewalld
echo"---------------------------------1.firewall done---------------------------------"
swapoff -a
sed -i '/swap/d' /etc/fstab
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
echo"---------------------------------2.swap and selinux disabled---------------------------------"

cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

echo"---------------------------------3.iptables done---------------------------------"

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce-19.03.12
systemctl enable --now docker
echo"---------------------------------4.docker done---------------------------------"

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

sudo setenforce 0

sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

sudo systemctl enable --now kubelet

echo"---------------------------------5.kubeadm done---------------------------------"

filename="/etc/docker/daemon.json"
content='
{
        "exec-opts":["native.cgroupdriver=systemd"]
}'
echo "$content" > "$filename"

systemctl daemon-reload
systemctl restart docker

echo "---------------------------------6.additional step done---------------------------------"

yes | rm /etc/containerd/config.toml

systemctl restart containerd

echo "---------------------------------7.deleted config.toml---------------------------------"

kubeadm init --pod-network-cidr=192.168.0.0/16

echo"---------------------------------8.initialized---------------------------------"

export KUBECONFIG=/etc/kubernetes/admin.conf

echo "
9.ready and use the below command to join the worker node to the cluster


"
kubeadm token create --print-join-command
