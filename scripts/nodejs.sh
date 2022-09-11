#!/bin/env bash

####################################################
# SET KEYRING PATH FOR NODESOURCE PACKAGE SIGNING KEY
####################################################
KEYRING=/usr/share/keyrings/nodesource.gpg

####################################################
# ADD NODESOURCE PACKAGE SIGNING KEY
####################################################
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | sudo tee "$KEYRING" >/dev/null

####################################################
# DISPLAY NODESOURCE PACKAGE SIGNING KEY
####################################################
sudo gpg --no-default-keyring --keyring "$KEYRING" --list-keys
# key ID should be: "9FD3B784BC1C6FC31A8A0A1C1655A0AB68576280"

####################################################
# MAKE NODESOURCE GPG KEY READABLE
####################################################
sudo chmod a+r /usr/share/keyrings/nodesource.gpg

####################################################
# CURL NODEJS SETUP SCRIPT AND EXECUTE
####################################################
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo bash -

####################################################
# INSTALL NODE.JS 16.X AND NPM
####################################################
sudo apt install -y nodejs
