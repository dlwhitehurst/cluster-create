#!/bin/bash

master=$(sudo cat /etc/hosts | grep kubemaster | awk '{print $2}')
echo $master

# only if
if [ "$master" = "kubemaster" ]; then 
	echo "Setup kubernetes configuration on master."
	mkdir -p $HOME/.kube
        sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config
else 
	echo "This should not be run on this node."
fi

