#!/usr/bin/env bash

apt-get update -y
apt-get upgrade -y
apt-get install nginx -y
apt-get install build-essential -y
apt-get install python-pip -y
pip install --upgrade pip
pip install -U setuptools

# NGINX
local_config="/var/www/digitalmarketplace-functional-tests/nginx/nginx.conf"
installed_config="/etc/nginx/nginx.conf"
config_updated=0
if [ "$(diff "$local_config" "$installed_config" | wc -l)" -gt 0 ]; then
  echo "Installing updated Nginx config"
  cp "$local_config" "$installed_config"
  config_updated=1
fi

if [ ! -d /tmp/nginx ]; then
  echo "Creating temporary directory for nginx to use for uploads"
  mkdir /tmp/nginx
  config_updated=1
fi

if ps -xU nobody > /dev/null 2>&1; then
  if [ "$config_updated" -eq 1 ]; then
    echo "Nginx running, reloading config"
    nginx -s reload
  fi
else
  echo "Starting Nginx"
  nginx
fi

