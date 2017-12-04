#!/bin/bash
# DEPENDS webserver.sh

set -e
set -o xtrace

# Assuming we're starting in the directory where the script lives.
START="$PWD"
source variables.sh

TARGET="/var/www/mastermind"

sudo rm -rf "$TARGET"
sudo mkdir -p "$TARGET"
sudo chown daniel:www-data "$TARGET"
cd "$TARGET"
git clone git@github.com:banool/comp30023-assn2.git .
make server

cd "$START"

sudo cp "configs/mastermind.service" /etc/systemd/system/
sudo systemctl enable mastermind
sudo systemctl start mastermind
