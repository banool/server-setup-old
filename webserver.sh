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

sudo apt-get install -y apache2
sudo a2enmod cgi
sudo rm -f /etc/apache2/sites-enabled/000-default.conf
sudo cp configs/ports.conf /etc/apache2/ports.conf
sudo systemctl restart apache2

sudo apt-get install -y nginx
sudo systemctl restart nginx

sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:certbot/certbot
sudo apt-get update
sudo apt-get install -y python-certbot-nginx
