#!/bin/bash
# Generate cluster token (bootstrap token). This is used for authenticating nodes joining the cluster.
TOKEN=$(sudo kubeadm token generate)
echo "$TOKEN - Use this to initialize the control plane or add a node to the cluster (!!!!SAVE THIS SOMEWHERE!!!!)"
echo "Using CIDR: 10.244.0.0/16"  # TODO: Move this to var

# Initialize the control plane

