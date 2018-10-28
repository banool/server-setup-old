#!/bin/bash
# DEPENDS webserver.sh

set -e
set -o xtrace

# Assuming we're starting in the directory where the script lives.
START="$PWD"
source variables.sh

TARGET="/var/www/dport"
CONF_NAME="dport"

sudo rm -rf "$TARGET"
sudo mkdir -p "$TARGET"
sudo chown daniel:www-data "$TARGET"
cd "$TARGET"
git clone git@gitlab.com:banool/dport-site.git .

cd scripts
./get_latest_resume.sh

cd "$START"

sudo cp "configs/$CONF_NAME" /etc/nginx/sites-available/
sudo rm -f "/etc/nginx/sites-enabled/$CONF_NAME"
sudo ln -s "/etc/nginx/sites-available/$CONF_NAME" /etc/nginx/sites-enabled/

sudo systemctl restart nginx

sudo certbot --nginx -n -m danielporteous1@gmail.com --agree-tos --redirect -d "$DOMAIN" -d "www.$DOMAIN"
