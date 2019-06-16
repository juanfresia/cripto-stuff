#! /bin/bash

set -e

## Generates a certificate for a given subject.
## All certs are stored under $KEY_DIR, with names $1.key, $1.csr and $1.pem
##
## Certificate is signed by authority at $KEY_DIR/ca.crt
##
## This script uses the following env variables:
##
##   - KEY_SIZE
##   - KEY_COUNTRY
##   - KEY_PROVINCE
##   - KEY_CITY
##   - KEY_ORG
##   - KEY_EMAIL
##   - CA_CN        (CA common name)
##   - R1_HOSTNAME  (crypto-2 by default)
##   - R2_HOSTNAME  (crypto-3 by default)
##
## Configs for openssl are taken from ${CONFIGS}/openssl.cnf

export KEY_DIR="/vagrant/certs"
export CONFIGS="/vagrant/scripts"

source ${CONFIGS}/config.sh

function usage {
    echo
    echo "    usage: $0 <subject>"
    echo
    echo "Generates <subject>.key and <subject>.pem singed by a CA under ${KEY_DIR}"
    echo
    exit 1
}

mkdir -p "${KEY_DIR}"
cd ${KEY_DIR}

KEY_CONFIG="${CONFIGS}/openssl.cnf"

if [[ -z "$1" ]]; then
    usage
fi
SUBJECT=$1

## TODO: replace with function build-req-pass
openssl req -days 3650 -new -keyout "${SUBJECT}.key" -out ${SUBJECT}.csr -config "$KEY_CONFIG"

## TODO: replace with function sing-req
openssl ca -days 3650 -out ${SUBJECT}.crt -in ${SUBJECT}.csr -config "$KEY_CONFIG"
mv ${SUBJECT}.crt ${SUBJECT}.pem

## TODO: replace with a function
## TODO2: rename ca.crt to cacert.pem?
openssl pkcs12 -export -out ${SUBJECT}.pfx -inkey ${SUBJECT}.key -in ${SUBJECT}.pem -certfile ca.crt -name ${SUBJECT}

