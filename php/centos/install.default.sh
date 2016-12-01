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

########################
## Readonly Variables ##
########################
host=`hostname -I | awk '{print $1}'`
IP="http://$host"

####################################
## Setting up repository for PHP7 ##
####################################
yum install -y epel-release
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm

#######################
## Setting up Apache ##
#######################
echo "# Installing Apache"
yum install -y httpd
systemctl enable httpd.service
systemctl start httpd.service

####################
## Setting up PHP ##
####################
echo "# Installing PHP"
#yum update 
yum install -y php70w
yum install php70w-xml php70w-soap php70w-xmlrpc
yum install php70w-mbstring php70w-json php70w-gd php70w-mcrypt

#echo "# Clone repository"
#git clone $repository /var/www/html
echo "<?php" >> /var/www/html/index.php
echo "phpinfo()" >> /var/www/html/index.php
echo "?>" >> /var/www/html/index.php

###################
## Opening Ports ##
###################
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload

#######################
## Restarting Apache ##
#######################
echo "# Restarting Service post-php setup"
systemctl restart httpd.service

##################
## Printing URL ##
##################
echo "You can now enter $IP/index.php"
echo "To see PHP Info"
