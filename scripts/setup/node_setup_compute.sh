#!/bin/bash
# Setup script for a compute node. Calls all subscripts required so that just this script can be run instead of each step individually.

while true; do
  case $1 in
    -h|--host) HOST=${2}; shift 2;;
    -i|--static-ip) STATIC_IP=${2}; shift 2;;
    -d|--dns) DNS=${2}; shift 2;;  # Should be something like 192.168.1.1
    --) shift; break;;
    *) break;;
  esac
done

echo "Using host/static ip/dns = ${HOST} / ${STATIC_IP} / ${DNS}"

# Check to make sure the required args have been passed 
if [ -z "${HOST}" ] || [ -z "${STATIC_IP}" ] || [ -z "${DNS}" ]; then
    echo "One of hostname, static ip or dns were not passed. Please provide these..."
    echo "They can be passed with -h, -i and -d, respectively."
    exit 1
fi

echo "Installing some basic system packages via apt..."
sudo sh ./00_basic_package_install.sh

printf "\n==>Package install done! Configuring static IP, Hostname and DNS\n"
sudo sh ./01_hostname_and_ip.sh ${HOST} ${STATIC_IP} ${DNS}

printf "\n==> Host name, ip and dns configured. Installing kubeadm...\n"
sudo sh ./03_install_kubeadm.sh

printf "\n==> Kubeadm installed! This host should now be ready to join the cluster using `kubeadm join` with the appropriate parameters\n"
echo "Goodbye"
exit 0
