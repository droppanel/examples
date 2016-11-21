#!/bin/bash

## Variables
host=`hostname -I | awk '{print $1}'`
IP="http://$host"
PORT=8080

echo "# Adding ERPL for NodeJs"
curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -

echo "# Installing nodejs"
yum -y install nodejs

echo "# Installing Git"
yum -y install git

echo "# Clonning repository"
git clone http://github.com/droppanel/nodejs.git app

echo "# Enter repo folder"
cd app

echo "# Install npm packages"
npm install

# Installing a Process Manager to keep node alive in the background
echo "# Installing PM2"
npm install pm2@latest -g

# Setting ip tables to redirect from port $PORT to port 80
echo "# Setting port $PORT to port 80"
sudo iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port $PORT

# Updating iptables changes
sudo iptables-save > /etc/sysconfig/iptables

echo "# Running node app"
pm2 start server.js
