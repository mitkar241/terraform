#!/bin/env bash
sudo apt update &&
sudo apt install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common &&
sudo apt install -y \
docker.io &&
sudo usermod -aG docker ubuntu