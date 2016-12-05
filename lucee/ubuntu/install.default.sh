#!/bin/bash
# Description: Lucee Server with Apache, Git and Haveged
# operating_systems: Ubuntu
# Tags: Lucee,Apache,Apache2,git,haveged,ubuntu
# created: 12/05/2016
# last_updated: 12/05/2016
# packages: Lucee,Apache,Git,Haveged
# variables: server_name, git_repo, lucee_pass, use_git_credentials, git_host, git_user, git_password
# $server_name: The name of the server used by Apache configuration
# $git_repo: The git repo address to pull down the Lucee application files.
# $lucee_pass: The Lucee Administrator Password
# $use_git_credentials: Whether the git repo requires credentials. The following variables git_host, git_user and git_password only need to be supplied if use_git_credentials is true
# $git_host: The domain name of the githost (bitbucket.com or github.com, usually)
# $git_user: The username of the git repository
# $git_password: The password for the git repository

####################
## USER VARIABLES ##
####################
# The name of the server used by Apache configuration
server_name='luceetest'

# The git repo address to pull down the Lucee application files.
git_repo='https://github.com/droppanel/lucee.git'

# The Lucee Administrator Password
lucee_pass='CHANGE_ME'

# Whether the git repo requires credentials.
# The following variables git_host, git_user and git_password only need
# to be supplied if use_git_credentials is true
use_git_credentials=false
# The domain name of the githost (bitbucket.com or github.com, usually)
git_host=''
# The username of the git repository
git_user=''
# The password for the git repository
git_password=''

##########################
## HAVEGED INSTALLATION ##
##########################
sudo apt-get update
sudo apt-get install -y haveged
sudo systemctl haveged start

#########################
## APACHE INSTALLATION ##
#########################
sudo apt-get install -y apache2
chkconfig httpd on
sudo systemctl apache2 start

########################
## LUCEE INSTALLATION ##
########################
cd /tmp
wget http://cdn.lucee.org/downloader.cfm/id/143/file/lucee-4.5.2.018-pl0-linux-x64-installer.run
chmod 755 lucee-4.5.2.018-pl0-linux-x64-installer.run
./lucee-4.5.2.018-pl0-linux-x64-installer.run --mode unattended --railopass $lucee_pass

##########################
## APACHE CONFIGURATION ## 
##########################
#Bakcup the apache config just in case
#cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak

# The installation method chosen is to run Apache with a single virtualhost 
# Directory configuration for virtual hosts
# touch /etc/httpd/conf/vhosts.conf
# echo "" > /etc/httpd/conf/vhosts.conf
# echo "<Directory \"/var/www/*\">" >> /etc/httpd/conf/vhosts.conf
# echo "   Options -Indexes +MultiViews +IncludesNOEXEC +FollowSymLinks +ExecCGI" >> /etc/httpd/conf/vhosts.conf
# echo "   AllowOverride All" >> /etc/httpd/conf/vhosts.conf
# echo "   XBitHack Off" >> /etc/httpd/conf/vhosts.conf
# echo "   DirectoryIndex index.html index.php index.cfm" >> /etc/httpd/conf/vhosts.conf
# echo "   Require all granted" >> /etc/httpd/conf/vhosts.conf
# echo "</Directory>" >> /etc/httpd/conf/vhosts.conf
# echo "" >> /etc/httpd/conf/vhosts.conf
# echo "<VirtualHost *:80>" >> /etc/httpd/conf/vhosts.conf
# echo "        ServerAdmin root@$server_name" >> /etc/httpd/conf/vhosts.conf
# echo "        ServerName $server_name" >> /etc/httpd/conf/vhosts.conf
# echo "        DocumentRoot /var/www/$server_name" >> /etc/httpd/conf/vhosts.conf
# echo "        CustomLog /var/log/httpd/$server_name.com.log combined" >> /etc/httpd/conf/vhosts.conf
# echo "        ErrorLog /var/log/httpd/$server_name.com_error_log" >> /etc/httpd/conf/vhosts.conf
# echo "</VirtualHost>" >> /etc/httpd/conf/vhosts.conf

# Add the virtualhost file to the httpd.conf
# echo 'Include /etc/httpd/conf/vhosts.conf' >> /etc/httpd/conf/httpd.conf

######################
## GIT INSTALLATION ##
#######################
# We tried multiple methods of getting git authentication for submodules: 
# 1) Supplying the user/password in the URL and using git-credentials, but this failed on cloud-init
# 2) Tried overwriting the the .gitmodules url with a user/pass, but this is cumbersome
#
# We settled on using the .netrc hack which supplies credentials for a domain. It requires that the
# user used has permissions to all submodules as well
# See: https://confluence.atlassian.com/bitbucketserver/permanently-authenticating-with-git-repositories-776639846.html
sudo apt-get install -y git

# Only set the global git user/password if it is necessary
if [ "$use_git_credentials" = true ] ; then
	touch /root/.netrc
	echo 'machine $git_host' >> /root/.netrc
	echo 'login $git_user' >> /root/.netrc
	echo 'password $git_password' >> /root/.netrc
fi

##############################
## APPLICATION SOURCE FILES ##
##############################
mkdir -p /var/www/html
cd /var/www/html
git init .
git remote add origin $git_repo
git pull origin master

#Reboot Apache
apachectl graceful

########################
## FINALIZE PROCESSES ##
######################## 
# Before exiting the install script, we want to warm the processes
# so that when lucee loads it has less risk of failing

# Sleep 15 seconds to allow Lucee to a moment to boot
sleep 15

ls /var/www/html
