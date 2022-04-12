#!/bin/bash
sudo chown -R ubuntu /var/www/html/kubo-core
sudo chmod -R 0777 /var/www/html/kubo-core

cd ~
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo mkdir /var/www/html/kubo-core/logs
sudo chmod 755 /var/www/html/kubo-core/logs

cd /var/www/html/kubo-core


sudo \cp -rf apacheconfigs/vhost.conf /etc/apache2/sites-enabled/000-default.conf
sudo \cp -rf apacheconfigs/apache2.conf /etc/apache2/apache2.conf
sudo \cp -rf apacheconfigs/ports.conf /etc/apache2/ports.conf
#sudo \cp -rf apacheconfigs/openssl.cnf /etc/ssl/openssl.cnf


curl -sS https://getcomposer.org/installer | php
php composer.phar install

#sudo wget http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/multiarch-support_2.27-3ubuntu1.5_amd64.deb
#sudo apt-get install ./multiarch-support_2.27-3ubuntu1.5_amd64.deb

#export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
#sudo apt-get install tdsodbc -y
#sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
#sudo curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
#sudo wget https://packages.microsoft.com/config/ubuntu/19.10/prod.list
#sudo mv prod.list /etc/apt/sources.list.d/mssql-release.list
#sudo apt-get update
#sudo apt-get install mssql-tools unixodbc-dev
#sudo curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
#echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
#sudo apt-get update -yq --allow-unauthenticated --allow-insecure-repositories && sudo ACCEPT_EULA=Y apt-get install -yq libodbc1 unixodbc mssql-tools unixodbc-dev  --allow-unauthenticated

#echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
#echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
#source ~/.bashrc

sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 0777 /var/www/html

sudo systemctl reload apache2
