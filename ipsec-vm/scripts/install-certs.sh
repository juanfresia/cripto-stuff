#! /bin/bash

set -eu

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
    IFACE=${R1_PUB_INTERFAZ}
elif [[ $(hostname) == "${R2_HOSTNAME}" ]]; then
    ## R2 case
    ## Add peer certificate as "untrusted" (-t ",,")
    certutil -A -n ${R1_HOSTNAME} -t ",," -d ${NSS_DB} -i "${KEY_DIR}/${R1_HOSTNAME}.pem"

    ## Add CA certificate as __mother of all certificates__
    ## TODO: change this if ca.crt gets renamed
    certutil -A -n ${CA_CN} -t "TC,C,C" -d ${NSS_DB} -a -i "${KEY_DIR}/ca.crt"

    ## Install self certificate with key (PKCS#12 format)
    pk12util -i ${KEY_DIR}/${R2_HOSTNAME}.pfx -d ${NSS_DB} -n ${R2_HOSTNAME}
    IFACE=${R2_PUB_INTERFAZ}
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
    left=192.168.5.41
    leftsubnet=10.5.1.0/24
    right=192.168.5.42
    rightsubnet=10.5.2.0/24
    auto=add
    authby=rsasig
    leftrsasigkey=%cert
    rightrsasigkey=%cert
    leftcert=crypto-2
    rightcert=crypto-3
    leftid="C=AR, ST=BA, O=6669-Seguridad Redes, CN=crypto-2"
    rightid="C=AR, ST=BA, O=6669-Seguridad Redes, CN=crypto-3"
EOF

ipsec stop
ipsec start

cat <<EOF

Congratulations, certificates were loaded into NSS database and IPsec should be running.
You can check if IPsec is up with `systemctl status ipsec`.

Here, have some useful commands to check the contents of the NSS database"

    certutil -L -d ${NSS_DB}    (lists known certificates)

EOF
