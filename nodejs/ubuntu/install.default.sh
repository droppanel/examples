#!/bin/bash
# description: A basic NodeJs installation
# operating_systems: Ubuntu
# tags: NodeJs,Ubuntu
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
echo "# Getting Node source"
cd ~
curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh

echo "# Adding PPAP"
sudo bash nodesource_setup.sh

echo "# Installing nodejs/npm"
sudo apt-get install nodejs

echo "# Linking nodejs to node command"
sudo ln -s `which nodejs` /usr/bin/node


###################################
## Installing And Setting Up Git ##
###################################
echo "# Installing git"
sudo apt-get install git

echo "# Clone repository"
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
sudo npm install pm2@latest -g


##############################################
## Redirecting trafic from $PORT to port 80 ##
##############################################
# Commenting exit on rc.local so we can set the iptables prerouting
echo "# Commenting exit on rc.local"
sudo sed -i '14 s/^/#/ ' /etc/rc.local  

# Setting ip tables to redirect from port $PORT to port 80
echo "# Setting port $PORT to port 80"
sudo iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port $PORT

# Updating /etc/rc.local to add the iptables change
echo "iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port $PORT" >> /etc/rc.local


####################
## Running Server ##
####################
echo "# Running node app"
pm2 start server.js