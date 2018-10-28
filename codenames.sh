#!/bin/bash
# DEPENDS webserver.sh python.sh

set -e
set -o xtrace

# Assuming we're starting in the directory where the script lives.
START="$PWD"
source variables.sh

GOLOCATION="/home/daniel/.go"
CONF_NAME="codenames"

cd /home/daniel
mkdir -p $GOLOCATION

# Install go
rm -rf go1.10.3.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
curl -O https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
tar xvf go1.10.3.linux-amd64.tar.gz
sudo chown -R root:root ./go
sudo mv go /usr/local
echo "export GOPATH=$GOLOCATION" >> /home/daniel/.bash_profile
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> /home/daniel/.bash_profile

source /home/daniel/.bash_profile

# This is just from the README at https://github.com/banool/codenames-pictures
cd $GOLOCATION
rm -rf *  # NOTE This will kill all go apps.
go get github.com/banool/codenames-pictures/...
go install github.com/banool/codenames-pictures/...
cd bin
ln -s ../src/github.com/banool/codenames-pictures/assets

# TODO  Get images into assets/images somehow. TODO
# The following is temporary!
cd assets/images
cp "ADD IMAGES HERE THIS IS A SAMPLE THEY MUST BE SQUARE.png" short.png
python3 -c 'import os
for i in range(25):
    os.system("cp short.png {}.png".format(i))'

cd "$START"

sudo cp "configs/$CONF_NAME.service" /etc/systemd/system/

sudo systemctl enable $CONF_NAME
sudo systemctl start $CONF_NAME

sudo cp "configs/$CONF_NAME" /etc/nginx/sites-available/
sudo rm -f "/etc/nginx/sites-enabled/$CONF_NAME"
sudo ln -s "/etc/nginx/sites-available/$CONF_NAME" /etc/nginx/sites-enabled/

sudo systemctl restart nginx

sudo certbot --nginx -n -m danielporteous1@gmail.com --agree-tos --redirect -d "codenames.$DOMAIN"

sudo systemctl restart codenames.service
