#!/bin/bash
# description: A basic Mongodb installation
# operating_systems: Ubuntu 16.04
# tags: MongoDB,Ubuntu
# packages: MongoDB
# created: 11/22/2016
# last_updated: 11/22/2016


########################################
# Installing MongoDB Community Edition #
########################################
echo "# Getting public key"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

echo "# Creating list file for mongodb"
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

echo "# Updating packages"
sudo apt-get update

echo "# Installing MongoDb"
sudo apt-get install -y mongodb-org

################################
# Setting Systemd Service File #
################################
if [ -f /lib/systemd/system/mongod.service ]
then
    echo "Deleting Systemd service file"
    sudo rm /lib/systemd/system/mongod.service
fi

echo "# Creating Systemd service file"
echo "[Unit]"                                                                 >> /lib/systemd/system/mongod.service
echo "Description=High-performance, schema-free document-oriented database"   >> /lib/systemd/system/mongod.service
echo "After=network.target"                                                   >> /lib/systemd/system/mongod.service
echo "Documentation=https://docs.mongodb.org/manual"                          >> /lib/systemd/system/mongod.service
echo ""                                                                       >> /lib/systemd/system/mongod.service
echo "[Service]"                                                              >> /lib/systemd/system/mongod.service
echo "User=mongodb"                                                           >> /lib/systemd/system/mongod.service
echo "Group=mongodb"                                                          >> /lib/systemd/system/mongod.service
echo "ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf"            >> /lib/systemd/system/mongod.service
echo ""                                                                       >> /lib/systemd/system/mongod.service
echo "[Install]"                                                              >> /lib/systemd/system/mongod.service
echo "WantedBy=multi-user.target"

echo "# Starting mongod service"
sudo service mongod start
