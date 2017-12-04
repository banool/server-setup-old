#!/bin/bash
# DEPENDS python.sh webserver.sh

set -e
set -o xtrace

# Assuming we're starting in the directory where the script lives.
START="$PWD"
source variables.sh

CONF_NAME="foodbrew"
TARGET="/var/www/foodbrew"
DBNAME="fft"
DBUSER="daniel"
DBPASS="pass1234"

# Set up MySQL. We're still in Python 2 land, so this is how we do it.
sudo apt-get install -y python-mysqldb
# These are the values from scripts/handler.py.
sudo mysql -uroot -e "DROP DATABASE IF EXISTS $DBNAME;"
sudo mysql -uroot -e "CREATE DATABASE $DBNAME;"
sudo mysql -uroot fft < configs/foodbrew.sql
sudo mysql -uroot -e "GRANT USAGE ON *.* TO '$DBUSER'@'localhost';"
sudo mysql -uroot -e "DROP USER '$DBUSER'@'localhost';"
sudo mysql -uroot -e "CREATE USER '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASS';"
sudo mysql -uroot -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'localhost';"
sudo mysql -uroot -e "FLUSH PRIVILEGES;"

sudo rm -rf "$TARGET"
sudo mkdir -p "$TARGET"
sudo chown daniel:www-data "$TARGET"
cd "$TARGET"
git clone git@github.com:banool/foodbrew.git .

chmod +x scripts/*.py

cd "$START"

sudo cp "configs/$CONF_NAME" /etc/nginx/sites-available/
sudo rm -f "/etc/nginx/sites-enabled/$CONF_NAME"
sudo ln -s "/etc/nginx/sites-available/$CONF_NAME" /etc/nginx/sites-enabled/

sudo cp "configs/$CONF_NAME.conf" /etc/apache2/sites-available/
sudo rm -f "/etc/apache2/sites-enabled/$CONF_NAME.conf"
sudo ln -s "/etc/apache2/sites-available/$CONF_NAME.conf" /etc/apache2/sites-enabled/

sudo systemctl restart nginx
sudo systemctl restart apache2

sudo certbot --nginx -n -m danielporteous1@gmail.com --agree-tos --redirect --domains "foodbrew.$DOMAIN"
