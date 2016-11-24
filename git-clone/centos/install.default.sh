#!/bin/bash
# name: Git Installation with cloning script
# summary:
  # Script for preparing a machine with Git using
  # data cloned from a Git repository
# operative_systems: CentOS
# tags: git,centos
# packages: git
# created: 11/24/2016
# last_updated: 11/24/2016
# $repository: The Github repository
# $directory: Directory to clone git repository

####################
## USER VARIABLES ##
####################
repository=''
directory='.'


####################
## Installing Git ##
####################
yum install -y git-core


########################
## Cloning Repository ##
########################
git clone $repository $directory

