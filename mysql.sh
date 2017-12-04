#!/bin/bash
# DEPENDS python.sh webserver.sh

set -o xtrace

source variables.sh

sudo apt-get install -y mysql-server

# Instead of mysql_secure_installation, we do it manually.
# Make sure that NOBODY can access the server without a password
ALTER USER 'root'@'localhost' IDENTIFIED BY "'$MYSQLROOTPASSWORD'" 
# Kill the anonymous users
sudo mysql -e "DROP USER ''@'localhost'"
# Because our hostname varies we'll use some Bash magic here.
sudo mysql -e "DROP USER ''@'$(hostname)'"
# Kill off the demo database
sudo mysql -e "DROP DATABASE test"
# Make our changes take effect
sudo mysql -e "FLUSH PRIVILEGES"
# Any subsequent tries to run queries this way will get access denied because lack of usr/pwd param
