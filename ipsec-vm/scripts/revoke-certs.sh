#! /bin/bash

set -e

export KEY_DIR="/vagrant/certs"
export CONFIGS="/vagrant/scripts"

source ${CONFIGS}/config.sh
KEY_CONFIG="${CONFIGS}/openssl.cnf"

function usage {
    echo
    echo "    usage: $0 <cert-name>"
    echo
    echo "You need to have a ca with its certificates in $KEY_DIR to be able to generate"
    echo "a properly signed crl."
    echo
    exit 1
}

if [[ -z "$1" ]]; then
    usage
fi
TO_REVOKE=$1

cd ${KEY_DIR}

## Revoke certificate
cat <<EOF
Revoking certificate for $TO_REVOKE. This only modifies index.txt for the CA, then we need to export
it as a signed crl.
EOF

openssl ca -revoke ${TO_REVOKE}.pem -config ${KEY_CONFIG}

## Generate CRL
cat <<EOF
Generate crl.pem and convert it to crl.der.
EOF

openssl ca -gencrl -out crl.pem -config ${KEY_CONFIG}
openssl crl -in crl.pem -inform PEM -out crl.der -outform DER

