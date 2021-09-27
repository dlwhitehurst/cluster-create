#!/bin/bash

# This script is to be run on all nodes
#ubuntu/allow-bridge-nf-traffic.sh
#ubuntu/install-docker-2.sh

#ubuntu/update-dns.sh

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
sudo apt install -y docker.io

