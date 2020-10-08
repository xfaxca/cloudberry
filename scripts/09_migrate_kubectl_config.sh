#!/bin/bash
# By default, the kubectl connection info/config is written to /etc/kubernetes/admin.conf. This needs to 
# Be copied to another location (here, ~/.kube/config), so that either root or a normal user on the master node
# (or even on a remote machine) can use it. This allows use of the kubectl command.
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
