#!/bin/bash

# This script is to be run on all nodes

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

