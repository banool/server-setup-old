#!/bin/bash
# DEPENDS webserver.sh nuclide.sh

set -e
set -o xtrace

# Assuming we're starting in the directory where the script lives.
START="$PWD"
source variables.sh

TARGET="/var/www/gomogo"
CONF_NAME="gomogo"

sudo rm -rf "$TARGET"
sudo mkdir -p "$TARGET"
sudo chown daniel:www-data "$TARGET"
cd "$TARGET"

git clone git@github.com:banool/gomogo.git gomogo

# Server.
cp -r gomogo server
cd server
git checkout feature/data

cd data
python -m virtualenv myvenv
source myvenv/bin/activate
pip install geojson
deactivate

cd "$START"

sudo cp "configs/gomogo.service" /etc/systemd/system/
sudo systemctl enable gomogo
sudo systemctl start gomogo

cd "$TARGET"

# Client.
cp -r gomogo client
cd client
git checkout feature/pages

npm install
# sudo npm install -g pm2
pm2 start index.js
eval "$(pm2 startup systemd | tail -n 1)"

cd ..

rm -rf gomogo
cd "$START"

# Webserver stuff now that the server and client are set up.
sudo cp "configs/$CONF_NAME" /etc/nginx/sites-available/
sudo rm -f "/etc/nginx/sites-enabled/$CONF_NAME"
sudo ln -s "/etc/nginx/sites-available/$CONF_NAME" /etc/nginx/sites-enabled/

sudo systemctl restart nginx

sudo certbot --nginx -n -m danielporteous1@gmail.com --agree-tos --redirect -d "gomogo.$DOMAIN"
