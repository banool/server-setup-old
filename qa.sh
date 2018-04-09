#!/bin/bash
# DEPENDS webserver.sh python.sh

set -e
set -o xtrace

# Assuming we're starting in the directory where the script lives.
START="$PWD"
source variables.sh

TARGET="/var/www/qa-django"
CONF_NAME="qa-django"
DB_NAME="qadjango"
DB_USER="qauser"

sudo apt-get install -y libpq-dev postgresql postgresql-contrib

sudo rm -rf "$TARGET"
sudo mkdir -p "$TARGET"
sudo chown daniel:www-data "$TARGET"
cd "$TARGET"
git clone git@github.com:banool/qa-django-basic.git .

python3.6 -m venv myvenv

# We need to take a two pronged approach with these environment variables.
# We put them in the activate file first, and then also in the --env
# command line argument of gunicorn.
echo "export DJANGO_SETTINGS_MODULE='q_and_a.settings.settings_prod'" >> myvenv/bin/activate
echo "export DB_NAME='$DB_NAME'" >> myvenv/bin/activate
echo "export DB_USER='$DB_USER'" >> myvenv/bin/activate
echo "export DB_PASS='$PSQLPASSWORD'" >> myvenv/bin/activate

read -s -p "Go generate and enter a Django secret key: " djangosecretkey
echo "export SECRET_KEY='$djangosecretkey'" >> myvenv/bin/activate

LOG_DIR="/var/log/qa-django"

sudo rm -rf "$LOG_DIR"
sudo mkdir -p "$LOG_DIR"
sudo chown daniel:www-data "$LOG_DIR"

source myvenv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

sudo -u postgres psql -c "DROP DATABASE IF EXISTS $DB_NAME;"
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME;"
sudo -u postgres psql -c "DROP ROLE IF EXISTS $DB_USER;"
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$PSQLPASSWORD';"
sudo -u postgres psql -c "ALTER ROLE $DB_USER SET client_encoding TO 'utf8';"
sudo -u postgres psql -c "ALTER ROLE $DB_USER SET default_transaction_isolation TO 'read committed';"
sudo -u postgres psql -c "ALTER ROLE $DB_USER SET timezone TO 'UTC';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"

python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser  # Interactive
python manage.py collectstatic

deactivate

cd "$START"

sudo cp "configs/$CONF_NAME.service" /etc/systemd/system/
echo "ExecStart=$TARGET/myvenv/bin/gunicorn --access-logfile - --workers 3 \
 --bind unix:$TARGET/q_and_a.sock q_and_a.wsgi:application \
--env DJANGO_SETTINGS_MODULE='q_and_a.settings.settings_prod' \
--env DB_NAME='$DB_NAME' \
--env DB_USER='$DB_USER' \
--env DB_PASS='$PSQLPASSWORD' \
--env SECRET_KEY='$djangosecretkey'" | sudo tee --append "/etc/systemd/system/$CONF_NAME.service" > /dev/null 

sudo systemctl enable $CONF_NAME
sudo systemctl start $CONF_NAME

sudo cp "configs/$CONF_NAME" /etc/nginx/sites-available/
sudo rm -f "/etc/nginx/sites-enabled/$CONF_NAME"
sudo ln -s "/etc/nginx/sites-available/$CONF_NAME" /etc/nginx/sites-enabled/

sudo systemctl restart nginx

sudo certbot --nginx -n -m danielporteous1@gmail.com --agree-tos --redirect -d "qa.$DOMAIN"

sudo systemctl restart qa-django.service
