#!/bin/env bash

####################################################
# MOVE VFWD_SVC_GIT'S SSH KEY TO HOME .SSH
####################################################
sudo mv /tmp/.ssh/mitkar ~/.ssh/mitkar
sudo chmod 600 ~/.ssh/mitkar

####################################################
# COPY SSH CONFIG FILE TO HOME SSH
####################################################
cp /tmp/.ssh/config ~/.ssh/config

####################################################
# ADD GITHUB.COM TO KNOWN HOSTS TO AVOID PROMPT
####################################################
ssh-keyscan -t rsa -H github.com >> ~/.ssh/known_hosts
