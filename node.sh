#!/bin/bash

# This script is to be run on all nodes
ubuntu/allow-bridge-nf-traffic.sh
ubuntu/install-docker-2.sh
ubuntu/update-dns.sh


# Prep for kubernetes install
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

# Google signing key 
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# Kubernetes Apt repo
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update and install
sudo apt-get update
sudo apt-get install -y kubeadm kubelet kubectl
sudo apt-mark hold kubeadm kubelet kubectl

# done???
sudo shutdown -r now
