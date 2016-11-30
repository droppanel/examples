#!/bin/bash
# name: LAMP installlation
# summary:
  # Installs an Apache Server
  # With PHP
# operative_systems: Ubuntu
# tags: php,ubuntu,apache
# packages: php70w,httpd
# created: 11/24/2016
# last_updated: 11/24/2016

#######################
## Setting up Apache ##
#######################
echo "# Installing Apache"
sudo apt-get install -y apache2
systemctl enable apache2
systemctl start apache2

####################
## Setting up PHP ##
####################
echo "# Installing PHP"
sudo apt-get update 
sudo apt-get install -y php7.0-mysql php7.0-curl php7.0-json php7.0-cgi  php7.0 libapache2-mod-php
sudo a2dismod php5
sudo a2enmod php7.0

echo "# Creating app virtual host"
sudo mkdir /var/www/app
sudo mkdir /var/www/app/public_html
sudo echo "<?php" >> /var/www/app/public_html/index.php
sudo echo "phpinfo()" >> /var/www/app/public_html/index.php
sudo echo "?>" >> /var/www/app/public_html/index.php

echo "# Creating file to recognize host"
sudo echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/app.conf
sudo echo "  ServerAdmin admin@app" >> /etc/apache2/sites-available/app.conf
sudo echo "  ServerAlias app" >> /etc/apache2/sites-available/app.conf
sudo echo "  DocumentRoot /var/www/app/public_html" >> /etc/apache2/sites-available/app.conf
sudo echo "  ErrorLog ${APACHE_LOG_DIR}/error.log" >> /etc/apache2/sites-available/app.conf
sudo echo "  CustomLog ${APACHE_LOG_DIR}/access.log combined" >> /etc/apache2/sites-available/app.conf
sudo echo "</VirtualHost>" >> /etc/apache2/sites-available/app.conf
sudo a2ensite app.conf

#######################
## Restarting Apache ##
#######################
echo "# Restarting Service post-php setup"
sudo systemctl reload apache2
sudo systemctl restart apache2

source /etc/apache2/envvars
/usr/sbin/apache2 -D DUMP_VHOSTS