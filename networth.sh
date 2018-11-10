#!/bin/bash
# DEPENDS webserver.sh python.sh chromedriver.sh

set -e
set -o xtrace

# Assuming we're starting in the directory where the script lives.
START="$PWD"
source variables.sh

TARGET="/var/www/net-worth"
CONF_NAME="net-worth"

sudo rm -rf "$TARGET"
sudo mkdir -p "$TARGET"
sudo chown daniel:www-data "$TARGET"
cd "$TARGET"
git clone git@gitlab.com:banool/net_worth.git .

read -s -p "Go find the file mint_secrets.py in your dropbox and put those in $TARGET/net_worth/secrets.py. Done? " blahwhatever
read -s -p "You should change the secret key in there. Done? " jdsdfsasdf

python3.6 -m venv myvenv

source myvenv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser  # Interactive
python manage.py collectstatic

deactivate

cd "$START"

sudo cp "configs/$CONF_NAME.service" /etc/systemd/system/
echo "ExecStart=/var/www/net-worth/myvenv/bin/gunicorn --access-logfile - --workers 3 \
 --bind unix:/var/www/net-worth/net_worth_site.sock net_worth_site.wsgi:application \
--env DJANGO_SETTINGS_MODULE='net_worth_site.settings_prod' | sudo tee --append "/etc/systemd/system/$CONF_NAME.service" > /dev/null 

sudo systemctl enable $CONF_NAME
sudo systemctl start $CONF_NAME

sudo cp "configs/$CONF_NAME" /etc/nginx/sites-available/
sudo rm -f "/etc/nginx/sites-enabled/$CONF_NAME"
sudo ln -s "/etc/nginx/sites-available/$CONF_NAME" /etc/nginx/sites-enabled/

sudo systemctl restart nginx

sudo certbot --nginx -n -m danielporteous1@gmail.com --agree-tos --redirect -d "net-worth.$DOMAIN"

sudo systemctl restart net-worth.service
