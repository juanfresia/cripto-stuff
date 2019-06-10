#! /bin/bash

set -exuo
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y build-essential
apt-get install -y lubuntu-desktop

apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

cp -r /vagrant/files/crypto /crypto

apt-get install -y git
apt-get install -y wireshark
apt-get install -y libreswan
apt-get install strongswan-starter


