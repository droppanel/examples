#!/bin/bash
# name: A basic NodeJs installation
# summary:
  # A NodeJs 6.x web application with PM2 for background execution
  # Includes git installation for the use of a github repository
  # And port forwarding to send trafic to port 80 regardless of used port in app
# operating_systems: CentOS
# tags: NodeJs,CentOS
# packages: nodejs,git
# created: 11/21/2016
# last_updated: 11/21/2016
# references: [Redirecting Port 80 to App port](http://stackoverflow.com/a/16573737)
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
