#! /bin/bash

set -eu

export KEY_DIR="/vagrant/rsa"
export CONFIGS="/vagrant/scripts"

source ${CONFIGS}/config.sh

cd ${KEY_DIR}

## Only R1 and R2 should configure RSA.

if [[ $(hostname) == "${R1_HOSTNAME}" ]]; then
    IFACE=${R1_PUB_INTERFAZ}
elif [[ $(hostname) == "${R2_HOSTNAME}" ]]; then
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
    $(cat ${KEY_DIR}/left.key)
    $(cat ${KEY_DIR}/right.key)
EOF

ipsec stop
ipsec start

cat <<EOF

Congratulations, certificates were loaded into NSS database and IPsec should be running.
You can check if IPsec is up with `systemctl status ipsec`.

EOF
