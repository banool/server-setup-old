#!/bin/bash
# DEPENDS python.sh webserver.sh

set -o xtrace

source variables.sh

sudo apt-get install -y mysql-server

sudo mysql_secure_installation
