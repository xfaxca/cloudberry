#!/bin/bash
masterNode=$1

# Remove the NoSchedule traine from the specified node
kubectl taint node ${1} node-role.kubernetes.io/master:NoSchedule-
