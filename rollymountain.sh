#!/bin/bash
# DEPENDS webserver.sh

set -e
set -o xtrace

sudo apt-get install -y unzip

# Assuming we're starting in the directory where the script lives.
START="$PWD"
source variables.sh

TARGET="/var/www/rollymountain"
CONF_NAME="rollymountain"

sudo rm -rf "$TARGET"
sudo mkdir -p "$TARGET"
sudo chown daniel:www-data "$TARGET"
cd "$TARGET"
wget "https://www.dropbox.com/s/jllltjd3l53z7rq/finalWebGLRollyMountain.zip?dl=0" -O "finalWebGLRollyMountain.zip"
unzip finalWebGLRollyMountain.zip
rm finalWebGLRollyMountain.zip

cd "$START"

sudo cp "configs/$CONF_NAME" /etc/nginx/sites-available/
sudo rm -f "/etc/nginx/sites-enabled/$CONF_NAME"
sudo ln -s "/etc/nginx/sites-available/$CONF_NAME" /etc/nginx/sites-enabled/

sudo systemctl restart nginx

sudo certbot --nginx -n -m danielporteous1@gmail.com --agree-tos --redirect -d "rollymountain.$DOMAIN"
