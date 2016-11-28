#!/bin/bash
# name: A basic Rails installation
# summary:
  # A default Ruby on Rails application
  # Includes NodeJs to be used as Javascript runtime for Rails
  # Includes Git so a given repository can be cloned
  # And port forwarding to send trafic to port 80 regardless of used port in app
# operating_systems: Ubuntu 16.04
# tags: Rails,Ubuntu,Ruby
# packages:
  # [rvm](get.rvm.io)
  # [nodejs](https://rpm.nodesource.com/setup_6.x)
# created: 11/24/2016
# last_updated: 11/24/2016
# $PORT: The port in which the application will run
# $repository: The Github repository that the app will be cloned from

####################
## USER VARIABLES ##
####################
PORT=8080
repository='https://github.com/droppanel/rails.git'

#######################
## Installing NodeJS ##
#######################
# NodeJs or some Javascript Runtime is required
# To be able to use Rails
echo "# Adding ERPL for NodeJs"
curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -

echo "# Installing nodejs"
yum -y install nodejs

########################################
## Installing Ruby, Rails and Bundler ##
########################################
echo "#Installing Ruby"
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm install 2.3.0
rvm use 2.3.0 –default

echo "#Installing Rails and basic known requirements for Rails"
yum install -y build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev autoconf libc6-dev ncurses-dev automake libtool libsqlite3-dev
gem install rails

echo "#Installing Bundler"
gem install bundler

############################
## Cloning Git Repository ##
############################
echo "# Clonning $repository"
git clone $repository app
cd app

##########################
## Installing Ruby Deps ##
##########################
echo "# Installing from Gemfile"
bundle install

##############################################
## Redirecting trafic from $PORT to port 80 ##
##############################################
echo "# Setting port $PORT to port 80"
iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port $PORT
iptables-save > /etc/sysconfig/iptables

#######################
## Running Rails App ##
#######################
echo "# Running rails server"
rails s -d -b 0.0.0.0 -p $PORT