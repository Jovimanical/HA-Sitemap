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

#Updating Write permission
sudo chown -R ubuntu /var/opt

if [ ! -d /var/opt/ssl ]; then
  sudo mkdir /var/opt/ssl

  echo "SSL Directory Created"
fi

sudo \cp -rf apacheconfigs/sytemap-rest-api.houseafrica.io.crt /var/opt/ssl/
sudo \cp -rf apacheconfigs/sytemap-rest-api.houseafrica.io.key /var/opt/ssl/

sudo chown -R root.root /var/opt

sudo \cp -rf apacheconfigs/vhost.conf /etc/apache2/sites-enabled/000-default.conf
sudo \cp -rf apacheconfigs/apache2.conf /etc/apache2/apache2.conf
sudo \cp -rf apacheconfigs/ports.conf /etc/apache2/ports.conf
sudo \cp -rf apacheconfigs/default-ssl.conf /etc/apache2/sites-available/
sudo \cp -rf apacheconfigs/ssl-params.conf /etc/apache2/conf-available/

sudo ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf

sudo a2enmod ssl
sudo a2enmod headers
sudo a2enconf ssl-params
sudo a2ensite 000-default
sudo a2ensite default-ssl

# Test if Composer is installed
composer -v >/dev/null 2>&1
COMPOSER_IS_INSTALLED=$?

# True, if composer is not installed
if [[ $COMPOSER_IS_INSTALLED -ne 0 ]]; then
  echo ">>> Installing Composer"
  # Install Composer
  curl -sS https://getcomposer.org/installer | php
  sudo mv composer.phar /usr/local/bin/composer
else
  echo ">>> Updating Composer"
  composer self-update
fi


# Install Global Composer Packages if any are given
sudo composer install

sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 0777 /var/www/html

sudo systemctl restart apache2

#Update composer with latest Development
sudo composer update
