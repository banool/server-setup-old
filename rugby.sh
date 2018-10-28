#!/bin/bash
# DEPENDS webserver.sh

set -e
set -o xtrace

# Assuming we're starting in the directory where the script lives.
START="$PWD"
source variables.sh

TARGET="/var/www/rugby"
CONF_NAME="rugby"

sudo rm -rf "$TARGET"
sudo mkdir -p "$TARGET"
sudo chown daniel:www-data "$TARGET"
cd "$TARGET"
git clone git@gitlab.com:banool/rugby-voting.git .

cd "$START"

sudo cp "configs/$CONF_NAME" /etc/nginx/sites-available/
sudo rm -f "/etc/nginx/sites-enabled/$CONF_NAME"
sudo ln -s "/etc/nginx/sites-available/$CONF_NAME" /etc/nginx/sites-enabled/

sudo systemctl restart nginx

sudo certbot --nginx -n -m danielporteous1@gmail.com --agree-tos --redirect \
    -d "yourrugbymatch.com.au" -d "www.yourrugbymatch.com.au" \
    -d "yourrugbymatch.com" -d "www.yourrugbymatch.com" \
    -d "rugby.dport.me"
