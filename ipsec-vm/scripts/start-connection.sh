#! /bin/bash

set -eu

## Execute this only in ONE router

ipsec auto --up crypto

cat <<EOF
The tunnel should be up. Here, have some useful commands to see whats going on:

     ipsec status
     ipsec whack --trafficstatus
     journalctl -f -u ipsec

EOF
