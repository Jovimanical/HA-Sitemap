#!/bin/bash
sudo chown -R ubuntu /var/www/html/kubo-core
sudo chmod -R 0777 /var/www/html/kubo-core

cd ~
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

cd /var/www/html/kubo-core

sudo \cp -rf apacheconfigs/vhost.conf /etc/apache2/sites-enabled/000-default.conf
sudo \cp -rf apacheconfigs/apache2.conf /etc/apache2/apache2.conf
sudo \cp -rf apacheconfigs/ports.conf /etc/apache2/ports.conf


curl -sS https://getcomposer.org/installer | php
php composer.phar install

sudo wget http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/multiarch-support_2.27-3ubuntu1.4_amd64.deb
sudo apt-get install ./multiarch-support_2.27-3ubuntu1.4_amd64.deb
sudo curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
sudo apt-get update -yq --allow-unauthenticated --allow-insecure-repositories && ACCEPT_EULA=Y apt-get install -yq libodbc1 unixodbc msodbcsql17 mssql-tools unixodbc-dev  --allow-unauthenticated


sudo systemctl reload apache2

sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 0777 /var/www/html/
# Add cronJobs to Service
#These are piped through the sort command to remove duplicate lines.
#but we can achieve a less destructive de-duplication with awk:
#cd ~
#(crontab -l; echo "* * * * * /usr/bin/php /var/www/html/cronJobs/index.php")|awk '!x[$0]++'|crontab -
#(crontab -l; echo "* * * * * root /usr/bin/wget -O - http://localhost/cronJobs/index.php")|awk '!x[$0]++'|crontab -
