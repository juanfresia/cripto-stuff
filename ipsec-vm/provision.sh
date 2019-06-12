#! /bin/bash

set -exuo
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y build-essential zip
#apt-get install -y lubuntu-desktop

#apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

cp -r /vagrant/files/crypto /crypto

apt-get install -y git
apt-get install -y wireshark
apt-get install -y libreswan


# This enables the use of scp with password authentication
sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
service sshd restart

