PORTS="60000:60020"

sudo apt-get install -y software-properties-common

sudo add-apt-repository -y ppa:keithw/mosh
sudo apt-get update
sudo apt-get install -y mosh

sudo ufw allow $PORTS/udp
