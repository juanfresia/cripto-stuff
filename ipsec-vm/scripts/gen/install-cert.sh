#! /bin/bash

set -e

export KEY_DIR="/vagrant/certs"
export CONFIGS="/vagrant/scripts"

source ${CONFIGS}/config.sh

cd ${KEY_DIR}

KEY_CONFIG="${CONFIGS}/openssl.cnf"
NSS_DB_DIR="/var/lib/ipsec/nss"
NSS_DB="sql:${NSS_DB_DIR}"

function usage {
    echo
    echo "    usage: $0 <cert-name>"
    echo
    echo "You need to have a pfx file with certificates to load in $KEY_DIR."
    echo
    exit 1
}

if [[ -z "$1" ]]; then
    usage
fi
SUBJECT=$1

## Init NSS database (if none)
ipsec initnss || true

## Install self certificate with key (PKCS#12 format)
pk12util -i ${KEY_DIR}/${SUBJECT}.pfx -d ${NSS_DB} -n ${SUBJECT}

ipsec stop
ipsec start
