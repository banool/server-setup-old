set -e
set -o xtrace

# Assure that we're running as root.
if [ ! $(id -u) = 0 ]; then
   echo "This script should be run as root" >&2
   exit 1
fi

sudo apt-get install -y apache2
sudo cp configs/ports.conf /etc/apache2/ports.conf

sudo apt-get install -y nginx
