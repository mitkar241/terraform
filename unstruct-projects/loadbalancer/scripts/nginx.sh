#!/bin/env bash

# purpose:
# install nginx to redirect traffic to tagrant main / test server

####################################################
# NGINX INSTALLATION, ENABLE AND START
####################################################
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
#sudo systemctl status nginx

####################################################
# UNLINK THE DEFAULT NGINX CONFIGURATION
####################################################
sudo unlink /etc/nginx/sites-available/default

####################################################
# ADD EMPTY DEFAULT CONFIG FILE
####################################################
# $ sudo nginx -t
# nginx: [emerg] open() "/etc/nginx/sites-enabled/default" failed (2: No such file or directory) in /etc/nginx/nginx.conf:62
# nginx: configuration file /etc/nginx/nginx.conf test failed
sudo touch /etc/nginx/sites-available/default

####################################################
# MOVING TAGRANT.CONF TO SITES-AVAILABLE
####################################################
# $ sudo nginx -t
# nginx: [emerg] could not build the server_names_hash, you should increase server_names_hash_bucket_size: 32
# nginx: configuration file /etc/nginx/nginx.conf test failed\
# comment line '# server_names_hash_bucket_size 64;' in file '/etc/nginx/nginx.conf'
sudo mv /tmp/tagrant.conf /etc/nginx/sites-available/tagrant.conf

####################################################
# CREATE TAGRANT.CONF SYMLINK FOR SITES ENABLED
####################################################
sudo ln -s /etc/nginx/sites-available/tagrant.conf /etc/nginx/sites-enabled/

####################################################
# TEST NGINX BEFORE RELOAD
####################################################
sudo nginx -t
# nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
# nginx: configuration file /etc/nginx/nginx.conf test is successful

####################################################
# RELOAD NGINX PROCESS
####################################################
sudo nginx -s reload
