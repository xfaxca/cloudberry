#!/bin/bash
# Installs docker and configures docker groups, daemon and system cgroups.
# Note: you most likely will need to run this with root privileges.

user=$1  # User to add to the docker group
if [ -z "${user}" ]; then
    echo "User not set. Defaulting to pi"
    user=pi
fi

# 1. Install Docker
# Install Docker and add user to docker group
printf "==> Installing docker...\n"
curl -sSL get.docker.com | sh && \
    sudo groupadd docker && \
    sudo usermod ${user} -aG docker

printf "==> Docker installed. Running hello-world to test"
docker run hello-world

printf "==> Replacing docker cgroups driver with systemd...\n"
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

docker info
printf "==> Adding limit support as per docker warnings...\n"
# For raspberry pi, need to these to /boot/firmware/cmdline.txt. Suggested by warnings from `docker info`.
# Enabling these settings should remove those error warnings.
# cgroup_enable=cpuset
# cgroup_enable=memory
# cgroup_memory=1
# swapaccount=1

sudo sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1/' /boot/firmware/cmdline.txt

printf "cgroups settings adjusted. Please reboot...\n"
exit 0
