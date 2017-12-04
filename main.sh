#!/bin/bash

set -e
set -o xtrace

source variables.sh

START="$PWD"

# Interactive and necessary early stuff.
./github.sh
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
./nuclide.sh
cd $START

# Various websites and applications, also non-interactive.
./foodbrew.sh
./rugby.sh
./dport.sh
./mastermind.sh
./rollymountain.sh
./safecycle.sh
./bunkopepi.sh
