#!/bin/bash
# Create namespace
kubectl create namespace kube-verify

# Create deployment in kube-verify namespace
kubectl create -f ./verify_kube.yaml
# Should see something like: deployment.apps/kube-verify created
