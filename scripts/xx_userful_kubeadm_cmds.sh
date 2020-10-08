#!/bin/bash
# Just a file for some useful commands for kubeadm

# 1. Find pod CIDR addresses for each node in the cluster
echo "Pod CIDR"
kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'
# Alt (can also replace grep with whatever you want to find)
kubectl cluster-info dump | grep -i cidr


