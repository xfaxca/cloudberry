#!/bin/bash
# Generate cluster token (bootstrap token). This is used for authenticating nodes joining the cluster.
TOKEN=$(sudo kubeadm token generate)
CIDR=10.244.0.0/16
KUBE_VERSION=1.19.2
echo "$TOKEN - Use this to initialize the control plane or add a node to the cluster (!!!!SAVE THIS SOMEWHERE!!!!)"
echo "Using CIDR: ${CIDR}"
echo "Using Kubernetes version ${KUBE_VERSION}"


# Initialize the control plane
sudo kubeadm init --token=${TOKEN} --kubernetes-version=${KUBE_VERSION} --pod-network-cidr=${CIDR}
