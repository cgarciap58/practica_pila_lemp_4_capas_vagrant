#!/bin/bash
# Script de provisionamiento para el servidor NFS + PHP-FPM
# Instala PHP-FPM y configura los servicios básicos
# Monta la app en el servidor NFS
# Este script se ejecuta antes de los servidores web en el orden de VagrantFile, así que todo bien.

sudo apt update

# Configurar PHP-FPM
sudo apt install -y php-fpm 
sudo apt install -y php8.2-mysql
sudo apt install -y php8.2-mysql php8.2-curl php8.2-zip
sudo apt install -y mariadb-client

sudo sed -i 's|^listen = .*|listen = 192.168.20.5:9000|' /etc/php/8.2/fpm/pool.d/www.conf
sleep 1
sudo systemctl restart php8.2-fpm

APP_DIR="/var/www/app"

# Configurar NFS
sudo apt install -y nfs-kernel-server
sudo apt install -y git
sudo mkdir -p $APP_DIR
sudo chown -R www-data:www-data $APP_DIR
sudo chmod 755 $APP_DIR
echo "$APP_DIR 192.168.20.0/24(rw,sync,no_subtree_check)" | sudo tee /etc/exports
sudo exportfs -ra
sudo systemctl enable nfs-kernel-server
sudo systemctl restart nfs-kernel-server


user_db="dbuser"
pass_db="dbpass"
ip_db="192.168.30.7"
db_wp="web0app"



if [ ! -f "$APP_DIR/index.php" ]; then
    echo "Aún no existe la app, descargándolo..."

    cd /tmp/
    git clone https://github.com/josejuansanchez/iaw-practica-lamp.git
    sudo cp -r iaw-practica-lamp/src/* $APP_DIR/
    sudo rm -rf iaw-practica-lamp
    cd $APP_DIR

    cat > config.php << 'EOF'
<?php

define('DB_HOST', '192.168.30.6');
define('DB_NAME', 'web0app');
define('DB_USER', 'dbuser');
define('DB_PASSWORD', 'dbpass');

$mysqli = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

if (!$mysqli) {
    die('Database connection failed: ' . mysqli_connect_error());
}
?>
EOF

fi


sudo sed -i 's/display_errors = .*/display_errors = On/' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/display_startup_errors = .*/display_startup_errors = On/' /etc/php/8.2/fpm/php.ini
sudo systemctl restart php8.2-fpm


sudo chown -R www-data:www-data $APP_DIR
sudo chmod -R 755 $APP_DIR
