#!/bin/bash
HELM_VERSION=3.3.4

# Download helm tar archive
printf "Downloading helm...\n"
wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz

# Unpack/Decompress
printf "Unpacking...\n"
tar xvf helm-v${HELM_VERSION}-linux-amd64.tar.gz

# Relocate binary
printf "Copying helm binary to /usr/local/bin/"
sudo mv linux-amd64/helm /usr/local/bin/

# Clean up
printf "Cleaning up...\n"
rm helm-v${HELM_VERSION}-linux-amd64.tar.gz
rm -rf linux-amd64

echo "Installed Helm version:"
helm version
printf "Helm successfully installed!\n"
exit 0
