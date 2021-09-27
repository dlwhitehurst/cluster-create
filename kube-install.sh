#!/bin/bash

# 
# sudo apt-mark hold kubeadm kubelet kubectl

# update, install, and hold kubernetes each node
sudo apt-get update 
sudo apt-get -y install kubeadm kubelet kubectl
sudo apt-mark hold kubeadm kubelet kubectl

