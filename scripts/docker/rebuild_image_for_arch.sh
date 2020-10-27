#!/bin/bash

# Script for rebuilding a docker image for a specified platform.
# Example: httpbin for arm64
# ./rebuild_image_for_arch.sh -b citizenstig/httpbin:latest -m xfaxca -t cloudberry -o Dockerfile.httpbin -p linux/arm64

while true; do
  case $1 in
    -b|--base-image) BASE_IMAGE=${2}; shift 2;;
    -p|--platform) PLAT=${2}; shift 2;;
    -t|--org-tag) OTAG=${2}; shift 2;;
    -m|--maintainer) MAINT=${2}; shift 2;;
    -o|--output-file) OFILE=${2}; shift 2;;
    --) shift; break;;
    *) break;;
  esac
done

if [[ -z "${BASE_IMAGE}" ]]; then
    echo "Base image must be specified (-b/--base-image)"
    exit 1;
fi

if [[ -z "${PLAT}" ]]; then

    echo "Platform not set. Defaulting to linux/arm64"
    PLAT=linux/arm64
fi

if [[ -z "${OTAG}" ]]; then
    echo "Org. Tag is not set. Building under cloudberry/"
    OTAG=cloudberry
fi

if [[ -z "${MAINT}" ]]; then
    echo "Maintainer not provided. Setting to cloudberry"
    MAINT=cloudberry
fi

if [[ -z "${OFILE}" ]]; then
    echo "Creating default output file Dockerfile"
    OFILE=Dockerfile
fi

if [[ -f "./${OFILE}" ]]; then
    echo "Output file already exists. Removing"
    rm ./${OFILE}
fi

cat << EOT >> ./${OFILE}
FROM ${BASE_IMAGE}
LABEL maintainer="${MAINT}"
EOT


echo "Dockerifle created..."
cat ./${OFILE}

echo "Building for ${PLAT}"

printf "Issuing command: docker build --platform ${PLAT} -t ${OTAG}/${BASE_IMAGE} -f ./${OFILE}"
docker build --platform ${PLAT} -t ${OTAG}/${BASE_IMAGE} -f ./${OFILE} .
