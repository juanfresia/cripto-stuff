#! /bin/bash

set -eu

## Generates certificates for both ends of the tunnel, signed by the same CA.
## The CA's cert is self-signed and is also generated here.
## All certs are stored under $KEY_DIR
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
##
## Certificates are stored in ${KEY_DIR}
## It is recommended to keep the directory within /vagrant
## to make it easy to share, as they will be needed in both R1 and R2.

export KEY_DIR="/vagrant/certs"
export CONFIGS="/vagrant/scripts"

source ${CONFIGS}/config.sh

rm -rf "${KEY_DIR}"
mkdir -p "${KEY_DIR}"
cd ${KEY_DIR}

KEY_CONFIG="${CONFIGS}/openssl.cnf"

## Generate CA
echo
echo "Generating CA certs. You can leave everything by default, EXCEPT the common name"
echo "Complete with \"${CA_CN}\""
echo

openssl req -days 3650 -nodes -new -x509 -keyout ca.key -out ca.crt -config "$KEY_CONFIG"
chmod 0600 ca.key

## Generate certificates for R1 and R2
echo
echo "Generating certs and keys for routers. You can leave everything by default, "
echo "EXCEPT the common names, which must match with the hostnames of the routers"
echo "Complete with \"${R1_HOSTNAME}\" and \"${R2_HOSTNAME}\""
echo

## TODO: replace with function build-req-pass
openssl req -days 3650 -new -keyout "${R1_HOSTNAME}.key" -out ${R1_HOSTNAME}.csr -config "$KEY_CONFIG"
openssl req -days 3650 -new -keyout "${R2_HOSTNAME}.key" -out ${R2_HOSTNAME}.csr -config "$KEY_CONFIG"

## Sing the certificates for R1 and R2 using the CA

## TODO: replace with function sing-req
openssl ca -days 3650 -out ${R1_HOSTNAME}.crt -in ${R1_HOSTNAME}.csr -config "$KEY_CONFIG"
openssl ca -days 3650 -out ${R2_HOSTNAME}.crt -in ${R2_HOSTNAME}.csr -config "$KEY_CONFIG"
mv ${R1_HOSTNAME}.crt ${R1_HOSTNAME}.pem
mv ${R2_HOSTNAME}.crt ${R2_HOSTNAME}.pem

## Convert .pem and .key into a PKCS#12 file (.pfx)
## This will become handy when uploading certs to NSS database

## TODO: replace with a function
## TODO2: rename ca.crt to cacert.pem?
openssl pkcs12 -export -out ${R1_HOSTNAME}.pfx -inkey ${R1_HOSTNAME}.key -in ${R1_HOSTNAME}.pem -certfile ca.crt -name ${R1_HOSTNAME}
openssl pkcs12 -export -out ${R2_HOSTNAME}.pfx -inkey ${R2_HOSTNAME}.key -in ${R2_HOSTNAME}.pem -certfile ca.crt -name ${R2_HOSTNAME}

cat <<EOF

All certificates should be generated and placed in ${KEY_DIR}
You only actually care about:

    ${R1_HOSTNAME}.key  ${R1_HOSTNAME}.pem  Key and certificate for ${R1_HOSTNAME}
    ${R1_HOSTNAME}.pfx                      The two above bundled together in PKCS#12 format

    ${R2_HOSTNAME}.key  ${R2_HOSTNAME}.pem  Key and certificate for ${R2_HOSTNAME}
    ${R2_HOSTNAME}.pfx                      The two above bundled together in PKCS#12 format

    ca.crt  (or cacert.pem)                 Certificate for the CA

Anything else in ${KEY_DIR} you can safely get rid of (exept for ca.key, don't loose that).

EOF
