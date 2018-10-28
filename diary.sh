#!/bin/bash
# DEPENDS webserver.sh python.sh

set -e
set -o xtrace

# Assuming we're starting in the directory where the script lives.
START="$PWD"
source variables.sh

ORIG_DIARY="/home/daniel/diary"
TARGET="/var/www/diary-django"
CONF_NAME="diary-django"
DB_NAME="diarydjango"
DB_USER="diaryuser"

sudo apt-get install -y libpq-dev postgresql postgresql-contrib

sudo -H pip3.6 install markdown  # Globals are bad but env stuff is hard.

rm -rf "$ORIG_DIARY"
mkdir "$ORIG_DIARY"
cd "$ORIG_DIARY"
git clone git@gitlab.com:banool/diary.git .

sudo rm -rf "$TARGET"
sudo mkdir -p "$TARGET"
sudo chown daniel:www-data "$TARGET"
cd "$TARGET"
git clone git@github.com:banool/diary-django.git .

ln -s "$ORIG_DIARY/scripts/prefilter.py"
ln -s "$ORIG_DIARY/scripts/filter.py"

python3.6 -m venv myvenv

# We need to take a two pronged approach with these environment variables.
# We put them in the activate file first, and then also in the --env
# command line argument of gunicorn.
echo "export DJANGO_SETTINGS_MODULE='diary.settings.settings_prod'" >> myvenv/bin/activate
echo "export DB_NAME='$DB_NAME'" >> myvenv/bin/activate
echo "export DB_USER='$DB_USER'" >> myvenv/bin/activate
echo "export DB_PASS='$PSQLPASSWORD'" >> myvenv/bin/activate

read -s -p "Go generate a Django secret key, or use some random alphabetical characters: " djangosecretkey
echo "export SECRET_KEY='$djangosecretkey'" >> myvenv/bin/activate

LOG_DIR="/var/log/diary-django"

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

python manage.py shell -c "from viewer import util; util.load_all_entries()"

deactivate

cd "$START"

sudo cp "configs/$CONF_NAME.service" /etc/systemd/system/
echo "ExecStart=/var/www/diary-django/myvenv/bin/gunicorn --access-logfile - --workers 3 \
 --bind unix:/var/www/diary-django/diary.sock diary.wsgi:application \
--env DJANGO_SETTINGS_MODULE='diary.settings.settings_prod' \
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

sudo certbot --nginx -n -m danielporteous1@gmail.com --agree-tos --redirect -d "diary.$DOMAIN"

sudo systemctl restart diary-django.service
