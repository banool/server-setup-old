#!/bin/bash
# DEPENDS python.sh webserver.sh

set -o xtrace

source variables.sh

echo "MySQL is about to ask you for a root password a few times."
echo "Make sure you use the password you set in variables.sh."
read -p "Understood? [y/n] " -r
if [[ ! $REPLY =~ ^[Yy]$ ]];
then
    echo "Okay, bailing..."
    exit
fi

sudo apt-get install -y mysql-server

sudo mysql_secure_installation
