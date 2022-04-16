#!/bin/bash
if ! [ -x "$(command -v apache2)" ]; then

  # Update Package Index
  sudo apt-get update && sudo apt-get upgrade -y
  sudo apt-get install lsb-release ca-certificates apt-transport-https apt-utils software-properties-common -y
  sudo add-apt-repository ppa:ondrej/php -y
  sudo add-apt-repository ppa:ondrej/apache2 -y
  sudo apt-get update -y
  echo "System updated"

  # Install Apache2
  sudo apt install -y apache2
  echo "Apache2 server installed"
  # Allow to run Apache on boot up
  sudo systemctl enable apache2
  echo "Apache2 server enabled"
  # Adjust Firewall
  sudo ufw allow in "Apache Full"

  sudo apt -y install wget unzip openssl git curl g++ make unixodbc-dev zip  && rm -rf /var/lib/apt/lists/*
  # Install PHP
  sudo apt install -y php7.4 php7.4-zip php7.4-dev php-pear libapache2-mod-php7.4 php7.4-gmp php7.4-mysql php7.4-gd php7.4-xml php7.4-soap php7.4-mbstring php7.4-mysql php7.4-redis php7.4-curl php7.4-cli php7.4-zip php7.4-yaml php7.4-common php7.4-bcmath php7.4-json

  sudo pecl install sqlsrv && sudo pecl install pdo_sqlsrv
  sudo printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/7.4/mods-available/sqlsrv.ini
  sudo printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/7.4/mods-available/pdo_sqlsrv.ini


  sudo phpenmod -v 7.4 sqlsrv pdo_sqlsrv curl simplexml
  echo "Server installed PHP"
  sudo a2dismod mpm_event
  sudo a2enmod mpm_prefork
  sudo a2enmod rewrite
  sudo a2enmod php7.4


  echo "PHP Activated and restarting Apache2"
  # Restart Apache Web Server
  sudo systemctl restart apache2

  echo "Download and Configure MSSQL Server"
  sudo wget http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/multiarch-support_2.27-3ubuntu1.5_amd64.deb
  sudo apt-get install ./multiarch-support_2.27-3ubuntu1.5_amd64.deb

  export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
  sudo apt-get install tdsodbc -y
  sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
  sudo curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
  sudo curl https://packages.microsoft.com/config/ubuntu/19.10/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list

  echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

  sudo apt-get update -yq --allow-unauthenticated --allow-insecure-repositories && sudo ACCEPT_EULA=Y apt-get install -yq libodbc1 unixodbc mssql-tools unixodbc-dev  --allow-unauthenticated

  echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
  echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
  source ~/.bashrc
  source ~/.bash_profile

  # I want to make sure that the directory is clean and has nothing left over from
  # previous deployments. The servers auto scale so the directory may or may not
  # exist.
  echo "Directories and permission"
  echo "System Checking Directories Exits"
  if [ -d /var/www/html ]; then
      sudo rm -rf /var/www/html/*
      echo "System Directory Cleared"
  fi

  # Allow Read/Write for Owner and App to write
  sudo usermod -aG www-data ubuntu
  sudo addgroup www-data
  sudo chown -R www-data:www-data /var/www/html && chmod -R g+rw /var/www/html
  sudo chmod -R 0777 /var/www/html

  echo "System script Exiting"
  exit 0
else
  # I want to make sure that the directory is clean and has nothing left over from
  # previous deployments. The servers auto scale so the directory may or may not
  # exist.
  echo "System Checking Directories Exits"
  if [ -d /var/www/html/kubo-core ]; then
    sudo rm -rf /var/www/html/kubo-core/*
    echo "System Directory Cleared"
  fi
fi # install apache if not already installed
