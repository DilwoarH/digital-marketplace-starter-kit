#!/usr/bin/env bash

#apt-get update -y
#apt-get upgrade -y
#apt-get install nginx -y
#apt-get install build-essential -y
#apt-get install python-pip -y
#pip install --upgrade pip
#pip install -U setuptools


export APP_DIR=/app
export DEP_NODE_VERSION=6.12.2
export DEP_YARN_VERSION=1.3.2-1
export DEP_SUPERVISOR_VERSION=3.3.3
export DEP_UWSGI_VERSION=2.0.15
export DEP_AWSCLI_VERSION=1.14.31
export DEP_AWSCLI_CWLOGS_VERSION=1.4.4

apt-get update && \
apt-get install -y --no-install-recommends nginx \
                libpcre3-dev libpq-dev libffi-dev libxml2-dev libxslt-dev python-setuptools libssl-dev \
                gcc make git curl xz-utils python2.7 python-pip python-virtualenv apt-transport-https gnupg python-pip && \
curl -SLO "https://nodejs.org/dist/v${DEP_NODE_VERSION}/node-v${DEP_NODE_VERSION}-linux-x64.tar.xz" && \
tar -xJf "node-v${DEP_NODE_VERSION}-linux-x64.tar.xz" -C /usr/local --strip-components=1 && \
rm "node-v${DEP_NODE_VERSION}-linux-x64.tar.xz" && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && \
apt-get install -y --no-install-recommends yarn=${DEP_YARN_VERSION} && \
rm -rf /var/lib/apt/lists/* && \
/usr/bin/python2.7 /usr/bin/pip install supervisor==${DEP_SUPERVISOR_VERSION} && \
/usr/local/bin/pip3 install --no-cache-dir uwsgi==${DEP_UWSGI_VERSION} awscli==${DEP_AWSCLI_VERSION} awscli-cwlogs==${DEP_AWSCLI_CWLOGS_VERSION} && \
aws configure set plugins.cwlogs cwlogs && \
mkdir -p ${APP_DIR} && \
rm -f /etc/nginx/sites-enabled/* && \
mkdir -p /var/log/digitalmarketplace && \
chmod 777 /run


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

