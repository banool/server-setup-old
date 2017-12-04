# Stop on errors.
set -e
# Print each command before running it.
set -o xtrace

# Assure that we're not running as root.
if [ $(id -u) = 0 ]; then
   echo "This script shouldn't be run as root" >&2
   exit 1
fi

sudo apt-get install -y m4 libtool automake build-essential pkg-config openssl libssl-dev
sudo apt-get install -y python-dev python3-dev

# Installing watchman.
if [ ! -d "watchman" ] || [ "$1" == "-f" ]; then
    sudo rm -rf watchman
    git clone https://github.com/facebook/watchman.git
    cd watchman
    git checkout v4.9.0
    ./autogen.sh
    ./configure
    make -j2
    sudo make install
    sudo rm -rf watchman
fi

# Installing node and nuclide.
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
set +e  # Yeah this actually unsets it would you believe.
sudo ln -s /usr/bin/nodejs /usr/bin/node
set -e
sudo npm install -g nuclide
