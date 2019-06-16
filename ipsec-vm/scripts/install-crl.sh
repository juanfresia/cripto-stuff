#! /bin/bash

set -e

export KEY_DIR="/vagrant/certs"
export CONFIGS="/vagrant/scripts"

source ${CONFIGS}/config.sh
KEY_CONFIG="${CONFIGS}/openssl.cnf"
NSS_DB_DIR="/var/lib/ipsec/nss"
NSS_DB="sql:${NSS_DB_DIR}"

cd ${KEY_DIR}

## Revoke certificate
cat <<EOF
Installing CRL located at ${KEY_DIR}/crl.der
EOF

crlutil -I -i ${KEY_DIR}/crl.der -d ${NSS_DB}
