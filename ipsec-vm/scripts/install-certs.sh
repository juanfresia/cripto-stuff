#! /bin/bash

set -eu

## Takes the generated certificates under ${KEY_DIR} and installs them
## in the NSS database for each node. This script needs to be ran in _both_
## R1 and R2, the hostname of the nodes is used to choose which certificates to
## include in the DB.
##
## After the certificates are installed, ipsec is restarted.
## You should be able to use scripts/add-connection.sh in _both_ nodes
## and scripts/start-connection.sh in _only one_ of them to start the tunnel.

export KEY_DIR="/vagrant/certs"
export CONFIGS="/vagrant/scripts"

source ${CONFIGS}/config.sh

cd ${KEY_DIR}

KEY_CONFIG="${CONFIGS}/openssl.cnf"
NSS_DB_DIR="/var/lib/ipsec/nss"
NSS_DB="sql:${NSS_DB_DIR}"

## Clean up NSS database (if any)
rm ${NSS_DB_DIR}/*.db
ipsec initnss

## Only R1 and R2 should install certificates.

if [[ $(hostname) == "${R1_HOSTNAME}" ]]; then
    ## R1 case
    ## Add peer certificate as "untrusted" (-t ",,")
    certutil -A -n ${R2_HOSTNAME} -t ",," -d ${NSS_DB} -i "${KEY_DIR}/${R2_HOSTNAME}.pem"

    ## Add CA certificate as __mother of all certificates__
    ## TODO: change this if ca.crt gets renamed
    certutil -A -n ${CA_CN} -t "TC,C,C" -d ${NSS_DB} -a -i "${KEY_DIR}/ca.crt"

    ## Install self certificate with key (PKCS#12 format)
    pk12util -i ${KEY_DIR}/${R1_HOSTNAME}.pfx -d ${NSS_DB} -n ${R1_HOSTNAME}
    IFACE=${R1_PUB_IFACE}
elif [[ $(hostname) == "${R2_HOSTNAME}" ]]; then
    ## R2 case
    ## Add peer certificate as "untrusted" (-t ",,")
    certutil -A -n ${R1_HOSTNAME} -t ",," -d ${NSS_DB} -i "${KEY_DIR}/${R1_HOSTNAME}.pem"

    ## Add CA certificate as __mother of all certificates__
    ## TODO: change this if ca.crt gets renamed
    certutil -A -n ${CA_CN} -t "TC,C,C" -d ${NSS_DB} -a -i "${KEY_DIR}/ca.crt"

    ## Install self certificate with key (PKCS#12 format)
    pk12util -i ${KEY_DIR}/${R2_HOSTNAME}.pfx -d ${NSS_DB} -n ${R2_HOSTNAME}
    IFACE=${R2_PUB_IFACE}
else
    exit 0
fi

## Configure ipsec.conf
cat <<EOF | sudo tee /etc/ipsec.conf
version 2.0
config setup
    interfaces="ipsec0=${IFACE}"
    klipsdebug=none
    plutodebug=none
    uniqueids=yes

conn %default
    keyingtries=%forever
    disablearrivalcheck=no

conn crypto
    left=${R1_PUB_IP}
    leftsubnet=${R1_PRIV_NET}
    right=${R2_PUB_IP}
    rightsubnet=${R2_PRIV_NET}
    auto=add
    authby=rsasig
    leftrsasigkey=%cert
    rightrsasigkey=%cert
    leftcert=${R1_HOSTNAME}
    rightcert=${R2_HOSTNAME}
    leftid="${R1_SUBJECT_ID}"
    rightid="${R2_SUBJECT_ID}"
EOF

ipsec stop
ipsec start

cat <<EOF

Congratulations, certificates were loaded into NSS database and IPsec should be running.
You can check if IPsec is up with `systemctl status ipsec`.

Here, have some useful commands to check the contents of the NSS database"

    certutil -L -d ${NSS_DB}    (lists known certificates)

EOF
