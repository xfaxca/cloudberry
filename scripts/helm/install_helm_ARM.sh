#!/bin/bash
HELM_VERSION=3.3.4
ARCH=arm64

# Download helm tar archive
printf "Downloading helm...\n"
wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCH}.tar.gz

# Unpack/Decompress
printf "Unpacking...\n"
tar xvf helm-v${HELM_VERSION}-linux-${ARCH}.tar.gz

# Relocate binary
printf "Copying helm binary to /usr/local/bin/"
sudo mv linux-${ARCH}/helm /usr/local/bin/

# Clean up
printf "Cleaning up...\n"
rm helm-v${HELM_VERSION}-linux-${ARCH}.tar.gz
rm -rf linux-${ARCH}

echo "Installed Helm version:"
helm version
printf "Helm successfully installed!\n"
exit 0
