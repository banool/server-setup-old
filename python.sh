#!/bin/bash

sudo apt-get install -y python-pip python-virtualenv
pip install --upgrade pip

sudo add-apt-repository -y ppa:jonathonf/python-3.6
sudo apt update
sudo apt install -y python3.6

sudo apt-get install -y python3.6-venv python3.6-dev
curl https://bootstrap.pypa.io/get-pip.py | sudo python3.6
