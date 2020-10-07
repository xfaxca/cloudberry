#!/bin/bash

# 1. Add docker group
sudo groupadd docker

# 2. Add current user to docker group
sudo gpasswd -a $USER docker

# 3. Test sudo-less run
docker run hello-world
