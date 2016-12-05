#!/bin/bash
# description: A basic secure MySQL installation with user and database.
# operating_systems: Ubuntu
# tags: MySQL,Ubuntu
# packages: mysql-server,Expect
# created: 12/02/2016
# last_updated: 12/02/2016
# variables: database, database_user, database_password
# $database: The name of the database to create
# $database_user: The username for the database
# $database_password: The password for the database

####################
## USER VARIABLES ##
####################
database='test'
database_user='test'
database_password='test'
mysql_password='test'

###################################
## INSTALL MYSQL FROM MySQL REPO ##
###################################
echo "installing mysql"
sudo apt-get install -y mysql-server
sudo systemctl mysql start

####################
## DATABASE SETUP ##
####################
# Create a basic database with a user and password. Only basic permissions
# are granted that would be useful for most applications. See the documentation
# http://dev.mysql.com/doc/refman/5.7/en/grant.html for all of the available grants
# use of mysql -Bse described here: http://stackoverflow.com/questions/7159727/delete-mysql-table-data-bash-script
echo "configuring database, user and permissions"
mysql -Bse "create database if not exists ${database};"
mysql -Bse "create user ${database_user}@'%' identified by '${database_password}';"
mysql -Bse "grant SELECT, INSERT, DELETE, UPDATE, CREATE TEMPORARY TABLES, EXECUTE on ${database}.* to ${database_user}@'%' identified by '${database_password}';"

###############################
## MySQL SECURE INSTALLATION ##
###############################
#Automatic mysql_secure_installation
#https://gist.github.com/enoch85/9cf2389df2b14569f063
echo "installing expect library"
sudo apt-get install -y expect
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"\r\"
expect \"Set root password?\"
send \"y\r\" 
expect \"New password:\"
send \"$mysql_password\r\"
expect \"Re-enter password:\"
send \"$mysql_password\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")
echo "running mysql secure installation"
echo "$SECURE_MYSQL"
