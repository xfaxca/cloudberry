#!/bin/bash
# Builds a custom image using a dockerfile on all nodes a the kubernetes cluster. 
# Usage example for custom metricbeat dockerfile (based on elastic/metricbeat:7.9.3)
# /build_dockerfile_on_all_nodes.sh -u [username] -p [password] -d /path/to/dockerfile/Dockerfile.metricbeat -b elastic/metricbeat:7.9.3

NODE_NAMES=()
SSH_USER=pi
LOCALHOST=default

while true; do
  case $1 in
    -u|--user) SSH_USER=${2}; shift 2;;
    -p|--password) SSH_PASS=${2}; shift 2;;
    -d|--dockerfile) DOCKERFILE=${2}; shift 2;;
    -p|--platform) PLAT=${2}; shift 2;;
    -t|--org-tag) OTAG=${2}; shift 2;;
    -b|--base-image) BASE_IMAGE=${2}; shift 2;;
    --) shift; break;;
    *) break;;
  esac
done

# Make sure all required parameters are set.
if [[ -z "${SSH_PASS}" ]]; then
    echo "Must provide a valid ssh user/password for remote hosts"
    exit 1;
fi

if [[ -z "${DOCKERFILE}" ]]; then
    echo "Must provide a valid dockerfile"
    exit 1;
fi

if [[ ! -f "${DOCKERFILE}" ]]; then
    echo "Must provide a valid dockerfile"
    exit 1
fi

if [[ -z "${BASE_IMAGE}" ]]; then
    echo "Must provide base image name for proper tagging"
fi

if [[ -z "${PLAT}" ]]; then
    echo "Platform not set. Defaulting to linux/arm64"
    PLAT=linux/arm64
fi

if [[ -z "${OTAG}" ]]; then
    echo "Org. Tag is not set. Building under cloudberry/"
    OTAG=cloudberry
fi

# Get basename of dockerfile for building on remote hosts.
DOCKERFILE_BASENAME=$(basename ${DOCKERFILE})
echo "Basename for dockerfile: ${DOCKERFILE_BASENAME}"


echo "Finding node hostnames..."
while read no; do
    if [ ${no} != "INTERNAL-IP" ]; then
        if [ ${no} == $(hostname -I | awk '{print $1}') ]; then
            echo "Local host ip is: ${no}"
            LOCALHOST=$no
        else
            echo "Remote host found: ${no}"
            # Append to node names for remote hosts
            NODE_NAMES+=(${no})
            #NODE_NAMES[${#NODE_NAMES[@]}]=${no}
        fi
    fi
done <<<$(kubectl get no -o wide | awk '{print $6}')

echo "Building on remote hosts..."
for host in "${NODE_NAMES[@]}"; do
    printf "Building on ${host}\n"
    sshpass -p ${SSH_PASS} ssh -oStrictHostKeyChecking=no ${SSH_USER}@${host} touch ~/testtouch && rm ~/testtouch
    sshpass -p ${SSH_PASS} scp ${DOCKERFILE} ${SSH_USER}@${host}:~/${DOCKERFILE_BASENAME}
    sshpass -p ${SSH_PASS} ssh ${SSH_USER}@${host} docker build --platform ${PLAT} -t ${OTAG}/${BASE_IMAGE} -f ~/${DOCKERFILE_BASENAME} .
    printf "Build command issued. Cleaning up\n"
    sshpass -p ${SSH_PASS} ssh ${SSH_USER}@${host} rm ~/${DOCKERFILE_BASENAME}
done

echo "Building on current localhost"
docker build --platform ${PLAT} -t ${OTAG}/${BASE_IMAGE} -f ${DOCKERFILE} .
