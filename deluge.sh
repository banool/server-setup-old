# The web UI will run on port 25567.

sudo add-apt-repository ppa:deluge-team/ppa -y
sudo apt install deluged deluge-webui -y

sudo adduser --system --group deluge
sudo gpasswd -a $USER deluge

sudo cp configs/deluged.service /etc/systemd/system/
sudo systemctl start deluged
sudo systemctl enable deluged

sudo cp configs/deluge-web.service /etc/systemd/system/
sudo systemctl start deluge-web
sudo systemctl enable deluge-web

sudo ufw allow 25567
