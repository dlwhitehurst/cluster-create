# cluster-create

This repo facilitates the creation of a Kubernetes cluster. It does this using
Vagrant and VirtualBox on a sufficient Ubuntu Linux server. Vagrant is the 
command line utility for managing the virtual machines or Kubernetes nodes.
VirtualBox is the virtual machine hypervisor by Oracle. 

The initial creation and basic provisioning is configured in a file called
`Vagrantfile`. This tells Vagrant what to create and also makes a call out
to a shell script to add Docker and the Kubernetes binaries.

## Prerequisites

Before any of this will work, the Linux server needs sufficient RAM, probably
at least 16GB. The server also needs an installation of VirtualBox and Vagrant.
This has been tested on Ubuntu 20.04 and a server with 193GB of RAM. Future 
testing will be done on a Macbook Pro 16GB of RAM. 

To install VirtualBox on Ubuntu 20.04 use the following command:
```bash
sudo apt-get install -y virtualbox
```
To install Vagrant, it's very much the same and with the command:
```bash
sudo apt-get install -y vagrant
```

## Cluster Creation

Once the server prerequisites are satisfied, the magic of Vagrant can be 
realized. Clone the repo ...
```bash
git clone https://github.com/dlwhitehurst/cluster-create.git
```
cd into the proper location ...
```bash
cd cluster-create
```
, and run:
```bash
vagrant up
```
This will create 3 machines, `kubemaster`, `kubenode01`, and `kubenode02`. It will
create the machines with Ubuntu 21.04, install docker, and then Kubernetes
at version 1.22.0. When Vagrant is complete, let's get a status on the machines.
```bash
vagrant status
```
The machines should be running. Now, let's use `kubeadm` to initialize the cluster.
```bash
# ssh into kubemaster
vagrant ssh kubemaster
cd cluster-create/ubuntu
./master.sh
```
When this is finished, do not clear the terminal but run the following.
```bash
./config.sh
```
This moves the newly created configuration into the `$USER` directory under `$USER/.kube`
so that you will be the Kubernetes administrator when you login or ssh into `kubemaster`.
Copy the cluster join command at the bottom of the `kubeadm` initialization. We will use 
this for each node to join the cluster. Exit from `kubemaster` and ssh into a node. For
each node, start the copied command with `sudo `. Then paste the command and run. Each 
node should join the cluster.

We're not finished just yet. Exit and ssh into `kubemaster`. Apply the container networking
choice Flannel. Even though the nodes have joined the cluster, our CNI solution must be in 
place before the cluster is fully ready.
```bash
cd cluster-create/ubuntu
./flannel.sh
```
Give the cluster a moment to execute the new resources and for the network to connect between the nodes.
Now, use `kubectl` to get the nodes.
```bash
kubectl get nodes
```
The cluster should now be ready.

An example ...
```bash
vagrant@kubemaster:~$ kubectl get nodes
NAME         STATUS   ROLES                  AGE   VERSION
kubemaster   Ready    control-plane,master   39m   v1.22.0
kubenode01   Ready    <none>                 38m   v1.22.0
kubenode02   Ready    <none>                 38m   v1.22.0
```
