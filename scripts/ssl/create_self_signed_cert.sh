#!/bin/bash
# Arg 1 = path at which to store certificates. Arg 2 = certificate filename. 
CERT_NAME=$1
CERT_PATH=$2

if [[ -z "${CERT_PATH}" ]]; then
    printf "No cert path passed. Setting to default at `$HOME/certs`\n"
    CERT_PATH=$HOME/certs
fi

if [[ -z "${CERT_NAME}" ]]; then
    printf "No cert name passed. Defaultint to `tls.crt`\n"
    CERT_NAME=tls
fi

echo "Cert name: ${CERT_NAME}"
echo "Cert path: ${CERT_PATH}"

# Create certificate path if it doesn't exist
if [[ ! -d "${CERT_PATH}" ]]; then
    echo "Certificate path at ${CERT_PATH} does not exist. Creating..."
    mkdir -p ${CERT_PATH}
fi

# Generate KEY & CSR
openssl genrsa -des3 -passout pass:over4chars -out ${CERT_PATH}/${CERT_NAME}.pass.key 2048
openssl rsa -passin pass:over4chars -in ${CERT_PATH}/${CERT_NAME}.pass.key -out ${CERT_PATH}/${CERT_NAME}.key
rm ${CERT_PATH}/${CERT_NAME}.pass.key
openssl req -new -key ${CERT_PATH}/${CERT_NAME}.key -out ${CERT_PATH}/${CERT_NAME}.csr
# Note: This will ask for some basic info to be filled out like location/name/etc. Leave challenge password blank (no need for self signed)

# Generate self-signed SSL certificate. 
openssl x509 -req -sha256 -days 365 -in ${CERT_PATH}/${CERT_NAME}.csr -signkey ${CERT_PATH}/${CERT_NAME}.key -out ${CERT_PATH}/${CERT_NAME}.crt
