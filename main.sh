#!/bin/bash

read -p "Have you changed the values in variables.sh? " -r
if [[ ! $REPLY =~ ^[Yy]$ ]];
then
    echo "Okay, go do that."
    exit
fi

set -e
set -o xtrace

source variables.sh

START="$PWD"

# Interactive and necessary early stuff.
# ./github.sh  # Most likely you already did this to get server-setup.
./mosh.sh  # You could relogin with mosh after this.

# Non-interactive stuff.
./dotfiles.sh
cd $START
./tmux.sh
cd $START
./python.sh
sudo ./webserver.sh
cd $START
./mysql.sh
cd $START
./node.sh
cd $START
# ./nuclide.sh

# Various websites and applications, also non-interactive.
./foodbrew.sh
# ./rugby.sh
./dport.sh
./mastermind.sh
./rollymountain.sh
./safecycle.sh
./bunkopepi.sh
./internode.sh
./back-server-splash.sh
./gomogo.sh
./diary.sh

# List the sites that have been enabled:
cd "$START"
echo "Enabled sites:"
sudo ./util/get_sites.sh
