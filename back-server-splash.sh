#!/bin/bash
# DEPENDS webserver.sh

set -e
set -o xtrace

sudo apt-get install -y unzip

# Assuming we're starting in the directory where the script lives.
START="$PWD"
source variables.sh

TARGET="/var/www/back-server-splash"
CONF_NAME="back-server-splash"

sudo rm -rf "$TARGET"
sudo mkdir -p "$TARGET"
sudo chown daniel:www-data "$TARGET"
cd "$TARGET"
wget "https://www.dropbox.com/s/7m5c9hf9uv9c9ax/back-server-splash.zip?dl=0" -O "bss.zip"
unzip bss.zip
rm bss.zip
rm -rf __MACOSX
mv back-server-splash/* ./
rm -rf back-server-splash

cd "$START"

sudo cp "configs/$CONF_NAME" /etc/nginx/sites-available/
sudo rm -f "/etc/nginx/sites-enabled/$CONF_NAME"
sudo ln -s "/etc/nginx/sites-available/$CONF_NAME" /etc/nginx/sites-enabled/

sudo systemctl restart nginx

sudo certbot --nginx -n -m danielporteous1@gmail.com --agree-tos --redirect -d "back-server-splash.$DOMAIN"
