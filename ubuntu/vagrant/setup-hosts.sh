#!/bin/bash
set -e
IFNAME=$1
ADDRESS="$(ip -4 addr show $IFNAME | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts

# remove ubuntu-bionic entry
sed -e '/^.*ubuntu-bionic.*/d' -i /etc/hosts

# Update /etc/hosts about other hosts
cat >> /etc/hosts <<EOF
192.168.5.11  tavros-master-1
192.168.5.12  tavros-master-2
192.168.5.21  tavros-worker-1
192.168.5.22  tavros-worker-2
192.168.5.30  tavros-lb
EOF

# iptables bridging allow
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

# docker
sudo apt-get update
sudo apt install -y docker.io

# cgroups driver

sudo cat <<EOF | sudo tee /etc/docker/daemon.json
{
"exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker

# Prep for kubernetes install
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

# Google signing key
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# Kubernetes Apt repo
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update and install
sudo apt-get update
sudo apt-get install -y kubeadm=1.22.0-00 kubelet=1.22.0-00 kubectl=1.22.0-00
sudo apt-mark hold kubeadm kubelet kubectl

# clone cluster-create repo
git clone https://github.com/dlwhitehurst/cluster-create.git


