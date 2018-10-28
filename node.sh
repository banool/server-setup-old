#!/bin/bash

set -e
set -o xtrace

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install --reinstall -y nodejs
sudo rm -rf /usr/bin/node
sudo ln -s /usr/bin/nodejs /usr/bin/node
