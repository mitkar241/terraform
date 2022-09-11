#!/bin/env bash

####################################################
# UPDATE APT REPO
####################################################
sudo apt update

####################################################
# SET HOSTNAME
####################################################
stripe="$1"
sudo hostnamectl set-hostname tagrant.${stripe}.mitkar.io
#hostname --fqdn

####################################################
# HARDCODE DEB.NODESOURCE.COM DNS WITH IPV4 ADDRESS
####################################################
# hardcoded deb.nodesource.com with ipv4 address
# reason: security group does not allow ipv6 cidr yet
old_line="127.0.0.1 localhost"
new_line="127.0.0.1 localhost\n104.114.76.145 deb.nodesource.com"
sudo sed -i "s/$old_line/$new_line/" /etc/hosts

####################################################
# ALLOW SIMPLE SUDO USAGE
####################################################
# issues:
# - on process restart: "root : problem with defaults entries ; TTY=unknown ; PWD=/ ; USER=root ;"
# - on using sudo     : "You have new mail in /var/mail/root"
old_line="sudoers:        files sss"
new_line="sudoers:        files"
sudo sed -i "s/$old_line/$new_line/" /etc/nsswitch.conf

####################################################
# ENSURE BASIC PACKAGES ARE INSTALLED
####################################################
sudo apt install -y \
apt-transport-https \
build-essential \
ca-certificates \
curl \
g++ \
gcc \
git \
gnupg \
lsb-release \
make \
net-tools \
wget
