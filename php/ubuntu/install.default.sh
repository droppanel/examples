#!/bin/bash
# name: LAMP installlation
# summary:
  # Installs an Apache Server
  # With PHP
# operative_systems: Ubuntu
# tags: php,ubuntu,apache
# packages:
# created: 11/24/2016
# last_updated: 11/24/2016

####################
## User Variables ##
####################
repository=''

#######################
## Setting up Apache ##
#######################
echo "# Installing Apache"
sudo apt-get install apache2
systemctl enable apache2.service
systemctl start apache2.service

####################
## Setting up PHP ##
####################
echo "# Installing PHP"
sudo apt-get update 
sudo apt-get install php7.0-mysql php7.0-curl php7.0-json php7.0-cgi  php7.0 libapache2-mod-php7

###################################
## Installing And Setting Up Git ##
###################################
echo "# Installing git"
sudo apt-get install git-core

#echo "# Clone repository"
#git clone $repository /var/www/app
sudo mkdir /var/www/app
sudo echo "<?php" >> /var/www/app/index.php
sudo echo "phpinfo()" >> /var/www/app/index.php
sudo echo "?>" >> /var/www/app/index.php

#######################
## Restarting Apache ##
#######################
sudo systemctl restart apache2.service
