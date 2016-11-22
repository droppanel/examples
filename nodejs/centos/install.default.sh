#!/bin/bash
# description: A basic NodeJs installation
# operating_systems: CentOS
# tags: NodeJs,CentOS
# packages: NodeJs,Git
# created: 11/21/2016
# last_updated: 11/21/2016
# variables: repository, host, IP, PORT
# $repository: The Github repository
# $host: The hostname
# $IP: The host preceded with 'http'
# $PORT: The port the node application will run

####################
## USER VARIABLES ##
####################
repository='http://github.com/droppanel/nodejs.git'
host=`hostname -I | awk '{print $1}'`
IP="http://$host"
PORT=8080


#######################
## Installing NodeJS ##
#######################
echo "# Adding ERPL for NodeJs"
curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -

echo "# Installing nodejs"
yum -y install nodejs


###################################
## Installing And Setting Up Git ##
###################################
echo "# Installing Git"
yum -y install git

echo "# Clonning repository"
git clone $repository app

echo "# Enter repo folder"
cd app


#############################
## Installing NPM Packages ##
#############################
echo "# Install npm packages"
npm install

# Installing a Process Manager to keep node alive in the background
echo "# Installing PM2"
npm install pm2@latest -g


##############################################
## Redirecting trafic from $PORT to port 80 ##
##############################################
echo "# Setting port $PORT to port 80"
iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port $PORT
iptables-save > /etc/sysconfig/iptables


####################
## Running Server ##
####################
echo "# Running node app"
pm2 start server.js
