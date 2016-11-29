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

#echo "# Clone repository"
#git clone $repository /var/www/html
sudo echo "<?php" >> /var/www/html/index.php
sudo echo "phpinfo()" >> /var/www/html/index.php
sudo echo "?>" >> /var/www/html/index.php

#######################
## Restarting Apache ##
#######################
echo "# Restarting Service post-php setup"
sudo systemctl restart apache2
