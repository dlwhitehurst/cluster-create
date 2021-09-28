#!/bin/bash

# This script is to be run on all nodes

sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

# Docker
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

sudo shutdown -r now

# verify cgroups driver = systemd with ...
#   sudo docker info

# run kube.sh next (and master.sh only on master)

