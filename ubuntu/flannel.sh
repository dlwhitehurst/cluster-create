#!/bin/bash

master=$(sudo cat /etc/hosts | grep kubemaster | awk '{print $2}')
echo $master

# only if
if [ "$master" = "kubemaster" ]; then 
	echo "Installing Flannel container networking on Kubernetes master node."
        kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
else 
	echo "This should not be run on this node."
fi

