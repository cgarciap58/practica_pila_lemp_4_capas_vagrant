#!/bin/bash
# Script de provisionamiento para el servidor NFS + PHP-FPM
# Instala PHP-FPM y configura los servicios básicos
# Monta WordPress en el servidor NFS
# Este script se ejecuta antes de los servidores web!

sudo apt update

# Configurar PHP-FPM
sudo apt install -y php-fpm 
sudo apt install -y php8.2-mysql
sudo apt install -y php8.2-mysql php8.2-curl php8.2-zip

sudo sed -i 's|^listen = .*|listen = 192.168.20.5:9000|' /etc/php/8.2/fpm/pool.d/www.conf
sleep 1
sudo systemctl restart php8.2-fpm


# Configurar NFS
sudo apt install -y nfs-kernel-server
sudo mkdir -p /srv/nfs/wordpress
sudo chown -R www-data:www-data /srv/nfs/wordpress
sudo chmod 755 /srv/nfs/wordpress
echo "/srv/nfs/wordpress 192.168.20.3(rw,sync,no_subtree_check) 192.168.20.4(rw,sync,no_subtree_check)" | sudo tee /etc/exports
sudo exportfs -ra
sudo systemctl enable nfs-kernel-server
sudo systemctl restart nfs-kernel-server


user_wp="wpuser"
pass_wp="wppw"
ip_db="192.168.30.7"
db_wp="wordpress"

WP_DIR="/srv/nfs/wordpress"


if [ ! -f "$WP_DIR/wp-config.php" ]; then
    echo "Aún no existe wordpress, descargándolo..."

    cd /tmp/
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    sudo cp -r wordpress/* $WP_DIR/
    sudo rm -rf wordpress latest.tar.gz
    cd $WP_DIR
    sudo cp wp-config-sample.php wp-config.php

    # Configuramos WordPress con nuestras credenciales
    echo "Configurando WordPress con las credenciales"
    sudo sed -i "s/'database_name_here'/'$db_wp'/g" wp-config.php
    sudo sed -i "s/'username_here'/'$user_wp'/g" wp-config.php
    sudo sed -i "s/'password_here'/'$pass_wp'/g" wp-config.php
    sudo sed -i "s/'localhost'/'$ip_db'/" wp-config.php
    
    # Añadir configuración para evitar redirecciones HTTPS forzadas
    sudo sed -i "/That's all, stop editing!/i \
define('WP_HOME', 'http://' . \$_SERVER['HTTP_HOST']); \
define('WP_SITEURL', 'http://' . \$_SERVER['HTTP_HOST']); \
define('FORCE_SSL_ADMIN', false); \
" wp-config.php
fi

sudo chown -R www-data:www-data /srv/nfs/wordpress
