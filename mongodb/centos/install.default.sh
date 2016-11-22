#!/bin/bash
# description: A basic Mongodb installation
# operating_systems: Ubuntu 16.04
# tags: MongoDB,Ubuntu
# packages: MongoDB
# created: 11/22/2016
# last_updated: 11/22/2016

############################################################
## Getting releasever for MongoDb package download config ##
############################################################
distro=$(sed -n 's/^distroverpkg=//p' /etc/yum.conf)
releasever=$(rpm -q --qf "%{version}" -f /etc/$distro)

################################
## Adding MongoDB Repo to Yum ##
################################echo "[mongodb-org-3.2]" >> /etc/yum.repos.d/mongodb-org-3.2.repo
echo "[mongodb-org-3.2]" >> /etc/yum.repos.d/mongodb-org-3.2.repo
echo "name=MongoDB Repository" >> /etc/yum.repos.d/mongodb-org-3.2.repo
echo "baseurl=http://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/" >> /etc/yum.repos.d/mongodb-org-3.2.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/mongodb-org-3.2.repo
echo "enabled=1" >> /etc/yum.repos.d/mongodb-org-3.2.repo
echo "gpgkey=http://www.mongodb.org/static/pgp/server-3.2.asc" >> /etc/yum.repos.d/mongodb-org-3.2.repo

########################################
# Installing MongoDB Community Edition #
########################################
echo "# Installing MongoDb"
yum install -y mongodb-org

echo "# Starting mongod service"
service mongod start
