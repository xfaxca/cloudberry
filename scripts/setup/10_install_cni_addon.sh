#!/bin/bash
# CNI add-on (Flannel)
# A CNI add-on handles configuration and cleanup of the pod networks. podCIDR should be set during cluster creation to make things
# easier. With this value set, you can just download the Flannel YAML and use `kubectl apply` to install it into the cluster.

# Installing this add-on creates ClusterRoles, ServiceAccounts, DaemonSets, etc. required for managing the pod network.

# Download Flannel YAML and pipe to STDIN
# V0.12.0
# curl -sSL https://raw.githubusercontent.com/coreos/flannel/v0.12.0/Documentation/kube-flannel.yml | kubectl apply -f -
# From master branch
curl -sSL https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml | kubectl apply -f -
# Side note: For curl, -s is silent, S is `show error` and L is for following redirects.


