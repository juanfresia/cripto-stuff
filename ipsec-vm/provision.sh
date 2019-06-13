#! /bin/bash

set -exuo
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y build-essential zip

apt-get install -y lubuntu-desktop
apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

cp -r /vagrant/files/crypto /crypto

apt-get install -y git
apt-get install -y wireshark
apt-get install -y libreswan

# This enables the use of scp with password authentication
sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
service sshd restart

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# Disable magic options ipsec doesnt like
sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0

# Update known hosts
cat <<EOF | sudo tee /etc/hosts
10.5.1.2    crypto-1
10.5.1.1    crypto-2
10.5.2.1    crypto-3
10.5.2.2    crypto-4
192.168.5.41 crypto-2
192.168.5.42 crypto-3
EOF

## Add routes for hosts through GW
NODE_NAME=$(hostname)
if [[ ${NODE_NAME} == "crypto-1" ]]; then
    ip route add 10.5.2.0/24 via 10.5.1.1
fi
if [[ ${NODE_NAME} == "crypto-4" ]]; then
    ip route add 10.5.1.0/24 via 10.5.2.1
fi

# Install custom vim
git clone https://github.com/juanfresia/.vim /home/vagrant/.vim
ln -s /home/vagrant/.vim/.vimrc /home/vagrant/.vimrc
