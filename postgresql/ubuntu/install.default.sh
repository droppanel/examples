#!/bin/bash
# name: Postgres installlation
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
user=''
pass=''

########################
## Installing Postgre ##
########################
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib
sudo service postgresql start

##################
## Setting Role ##
##################
sudo -u postgres -c "psql -c \"CREATE USER $user with SUPERUSER | CREATEDB | CREATEROLE | CREATEUSER | UNENCRYPTED PASSWORD '$pass'\""
