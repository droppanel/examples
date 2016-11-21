#!/bin/bash

## Variables
host=`hostname -I | awk '{print $1}'`
IP="http://$host"
PORT=8080

echo "# Getting Node source"
cd ~
curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh

echo "# Adding PPAP"
sudo bash nodesource_setup.sh

echo "# Installing nodejs/npm"
sudo apt-get install nodejs

echo "# Linking nodejs to node command"
sudo ln -s `which nodejs` /usr/bin/node

echo "# Installing git"
sudo apt-get install git

echo "# Clone repository"
git clone http://github.com/droppanel/nodejs.git app

echo "# Enter repo folder"
cd app

echo "# Install npm packages"
npm install

# Installing a Process Manager to keep node alive in the background
echo "# Installing PM2"
sudo npm install pm2@latest -g

# Commenting exit on rc.local so we can set the iptables prerouting
echo "# Commenting exit on rc.local"
sudo sed -i '14 s/^/#/ ' /etc/rc.local  

# Setting ip tables to redirect from port $PORT to port 80
echo "# Setting port $PORT to port 80"
sudo iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port $PORT

# Updating /etc/rc.local to add the iptables change
echo "iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port $PORT" >> /etc/rc.local

echo "# Running node app"
pm2 start server.js