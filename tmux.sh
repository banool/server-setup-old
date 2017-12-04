# DEPENDS dotfiles.sh

set -e
set -o xtrace

sudo apt-get remove -y tmux
sudo apt-get install -y automake build-essential pkg-config libevent-dev libncurses5-dev
rm -fr /tmp/tmux
git clone https://github.com/tmux/tmux.git /tmp/tmux
cd /tmp/tmux
./autogen.sh
./configure
make
sudo make install
cd ~
rm -rf /tmp/tmux
sudo ln -s /usr/local/bin/tmux /usr/bin/tmux
