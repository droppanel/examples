#!/bin/bash

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

echo "# Setting Host"
host=`hostname -I | awk '{print $1}'`
IP="http://$host"
PORT=8080

echo "# Installing PM2"
sudo npm install pm2@latest -g

echo "# Running node app"
pm2 start server.js

echo "Host $IP:$PORT"
