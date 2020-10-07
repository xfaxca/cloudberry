#!/bin/bash

# Replaces cgroups driver with systemd so that systemd can act as the cgroups manager and ensure only one cgroup manager is in use.
# This helps with system stability and is recommended by kubernetes. 
sudo cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
