#!/bin/bash
sudo chown -R ubuntu /var/www/html/kubo-core
sudo chmod -R 0777 /var/www/html/kubo-core

cd ~
#curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
#sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

  if ! [ -d /var/www/html/kubo-core/logs ]; then
        sudo mkdir /var/www/html/kubo-core/logs
        sudo chmod 755 /var/www/html/kubo-core/logs
        echo "Created kubo-core logs"
  fi


cd /var/www/html/kubo-core


sudo \cp -rf apacheconfigs/vhost.conf /etc/apache2/sites-enabled/000-default.conf
sudo \cp -rf apacheconfigs/apache2.conf /etc/apache2/apache2.conf
sudo \cp -rf apacheconfigs/ports.conf /etc/apache2/ports.conf


curl -sS https://getcomposer.org/installer | php
sudo php composer.phar install

sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 0777 /var/www/html

sudo systemctl restart apache2

#Update composer with latest Development
sudo composer update
