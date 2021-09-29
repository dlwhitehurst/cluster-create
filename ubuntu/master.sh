#!/bin/bash

master=$(sudo cat /etc/hosts | grep kubemaster | awk '{print $2}')
echo $master

# only if
if [ "$master" = "kubemaster" ]; then 
	echo "Install CNI solution."
	kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
	echo "Initializing the master node."
        sudo kubeadm init --pod-network-cidr 10.244.0.0/16 --apiserver-advertise-address=192.168.56.2
else 
	echo "This should not be run on this node."
fi

