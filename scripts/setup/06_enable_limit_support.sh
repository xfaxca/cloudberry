#!/bin/bash

# For raspberry pi, need to these to /boot/firmware/cmdline.txt. Suggested by warnings from `docker info`.
# Enabling these settings should remove those error warnings.
# cgroup_enable=cpuset
# cgroup_enable=memory
# cgroup_memory=1
# swapaccount=1

sudo sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1/' /boot/firmware/cmdline.txt
