#!/bin/bash

set -e
set -o xtrace

cd "$(dirname "$0")"
source variables.sh

# Assure that we're running as root.
if [ ! $(id -u) = 0 ]; then
   echo "This script should be run as root" >&2
   exit 1
fi

apt-get install -y apache2
a2enmod cgi
rm -f /etc/apache2/sites-enabled/000-default.conf
cp configs/ports.conf /etc/apache2/ports.conf
systemctl restart apache2

apt-get install -y nginx
systemctl restart nginx

apt-get install -y software-properties-common
add-apt-repository -y ppa:certbot/certbot
apt-get update
apt-get install -y python-certbot-nginx
