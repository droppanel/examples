#!/bin/bash
# description: A basic secure MySQL 5.6.34, for Linux (x86_64) installation with user and database.
# operating_systems: CentOS
# tags: MySQL,CentOS,CentOS7
# packages: MySQL,Expect
# created: 11/21/2016
# last_updated: 11/21/2016
# variables: database, database_user, database_password
# $database: The name of the database to create
# $database_user: The username for the database
# $database_password: The password for the database

####################
## USER VARIABLES ##
####################
database='CHANGE_ME'
database_user='CHANGE_ME'
database_password='CHANGE_ME'

###################################
## INSTALL MYSQL FROM MySQL REPO ##
###################################
yum clean all
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum update
yum -y install mysql-server
systemctl start mysqld
chkconfig --level 345 mysqld on

####################
## DATABASE SETUP ##
####################
mysql -Bse "create database if not exists ${database};"
mysql -Bse "create user ${database_user}@'%' identified by '${database_password}';"
mysql -Bse "grant SELECT, INSERT, DELETE, UPDATE, CREATE TEMPORARY TABLES, EXECUTE on ${database}.* to ${database_user}@'%' identified by '${database_password}';"

###############################
## MySQL SECURE INSTALLATION ##
###############################
#Automatic mysql_secure_installation
#https://gist.github.com/enoch85/9cf2389df2b14569f063
yum -y install expect
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root:\"
send \"$MYSQL\r\"
expect \"Would you like to setup VALIDATE PASSWORD plugin?\"
send \"n\r\" 
expect \"Change the password for root ?\"
send \"n\r\"
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
echo "$SECURE_MYSQL"
