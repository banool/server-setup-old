# DEPENDS python36.sh webserver.sh

set -e

TARGET="/var/www/safecycle"

sudo rm -rf "$TARGET"
sudo mkdir -p "$TARGET"
sudo chown daniel:www-data "$TARGET"
cd "$TARGET"
git clone https://github.com/banool/safecycle.git .
git checkout localML

sudo apt-get install -y libblas-dev liblapack-dev libatlas-base-dev gfortran

python3.6 -m venv myvenv
source myvenv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
