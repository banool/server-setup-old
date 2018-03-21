#!/bin/bash
# DEPENDS python.sh webserver.sh

set -e
set -o xtrace

# Assuming we're starting in the directory where the script lives.
START="$PWD"
source variables.sh

TARGET="/var/www/safecycle"

# You can skip installing the actual app and just do the webserver stuff
# by using --no-install when running this.
if [ ! "$1" == "--no-install" ]; then
    sudo rm -rf "$TARGET"
    sudo mkdir -p "$TARGET"
    sudo chown daniel:www-data "$TARGET"
    cd "$TARGET"
    git clone https://github.com/banool/safecycle.git .
    # git checkout localML  # We use master now.

    sudo apt-get install -y libblas-dev liblapack-dev libatlas-base-dev gfortran

    # This set up is a bit of a hack. The script doesn't actually source this
    # virtualenv, it just uses its python.
    python3.6 -m venv myvenv
    source myvenv/bin/activate
    pip install --upgrade pip
    pip install -r requirements.txt

    chmod +x scripts/*.py

    cd "$START"
fi

sudo cp configs/safecycle.service /etc/systemd/system/
sudo systemctl enable safecycle
sudo systemctl start safecycle

sudo cp configs/safecycle /etc/nginx/sites-available/
sudo rm -f /etc/nginx/sites-enabled/safecycle
sudo ln -s /etc/nginx/sites-available/safecycle /etc/nginx/sites-enabled/

sudo systemctl restart nginx
sudo systemctl restart apache2

sudo certbot --nginx -n -m danielporteous1@gmail.com --agree-tos --redirect --domains "safecycle.$DOMAIN"
