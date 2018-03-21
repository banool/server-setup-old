# Server Setup
This repo contains a whole bunch of scripts for setting my personal server.
The scripts are tailored for Ubuntu 16.04 and probably won't fully work on
anything else.

## How to use
Any of the scripts can be run individually, with dependencies (as in other
scripts) indicated at the top of the file. All of them can be run in an
appropriate order by using `main.sh`.

### Before using
- Make sure to change the values in `variables.sh` appropriately.
- Make sure that the domain you specify in `variables.sh` points to the server.

### After using
1. Add certificate renewal to the root crontab: `0 0 1 * * certbot renew`.

## Note
These scripts work a bit weirdly with sudo. You shouldn't run the
scripts with sudo as it might make the permissions all weird, but if you don't
run them with root privileges then the commands inside that use sudo won't work.
I know it's bad practice to use sudo inside a script, but it made it much
easier. On my fresh Ubuntu 16.04 instance I was able to run the scripts as my
own user (`daniel`) but have all the internal `sudo` commands run without
prompting me for the password, it was quite strange. The permissions in the
scripts might need a rework in the future.
