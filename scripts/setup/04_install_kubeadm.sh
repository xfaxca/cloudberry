#!/bin/sh
user=$1

if [[ -z "${user}" ]]; then
    user=pi
fi

# Disable Swap
sudo dphys-swapfile swapoff && \
sudo dphys-swapfile uninstall && \
sudo update-rc.d dphys-swapfile remove

# Add repo list and install kubeadm
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
# TODO/NOTE - In the future, if kubernetes repo for Ubuntu 20.04 becomes available, switch to that (not avail as of 10/08/2020)
sudo apt-get update -q && \
sudo apt-get install -qy kubeadm kubectl kubelet

# Freeze kubeadm, kubelet and kubectl to prevent unintentional upgrades that might break things. 
sudo apt-mark hold kubelet kubeadm kubectl

