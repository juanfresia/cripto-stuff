#! /bin/bash

set -eu

export KEY_DIR="/vagrant/rsa"
export CONFIGS="/vagrant/scripts"
export IPSEC_SECRETES="/etc/ipsec.secrets"

source ${CONFIGS}/config.sh

NSS_DB_DIR="/var/lib/ipsec/nss"
NSS_DB="sql:${NSS_DB_DIR}"

## Clean up NSS database (if any)
rm ${NSS_DB_DIR}/*.db
ipsec initnss

## Clean up ipsec.secrets
rm -rf ${IPSEC_SECRETES}

## Clean up keys directory
mkdir -p "${KEY_DIR}"

if [[ $(hostname) == "${R1_HOSTNAME}" ]]; then
    ipsec newhostkey --output ${IPSEC_SECRETES} --hostname ${R1_HOSTNAME}
    ## Get key id
    CKAID=$(ipsec showhostkey --list | tail | rev | cut -d' ' -f1 | rev)
    ipsec showhostkey --left --ckaid ${CKAID} > ${KEY_DIR}/left.key
elif [[ $(hostname) == "${R2_HOSTNAME}" ]]; then
    ipsec newhostkey --output ${IPSEC_SECRETES} --hostname ${R2_HOSTNAME}
    CKAID=$(ipsec showhostkey --list | tail | rev | cut -d' ' -f1 | rev)
    ipsec showhostkey --right --ckaid ${CKAID} > ${KEY_DIR}/right.key
else
    exit 0
fi
