#!/bin/bash

master=$(sudo cat /etc/hosts | grep tmaster | awk '{print $2}')
echo $master

# only if
if [ "$master" = "tmaster" ]; then 
	echo "Installing Flannel container networking on Kubernetes master node."
        kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
else 
	echo "This should not be run on this node."
fi

