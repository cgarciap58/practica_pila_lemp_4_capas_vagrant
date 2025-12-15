#!/bin/bash
# Script de provisionamiento para el servidor NFS + PHP-FPM
# Instala PHP-FPM y configura los servicios básicos
# Monta WordPress en el servidor NFS
# Este script se ejecuta antes de los servidores web!

sudo apt update

# Configurar PHP-FPM
sudo apt install -y php-fpm 
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
    sudo sed -i "/That's all, stop editing!/i \
if (isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) && \$_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') { \
    \$_SERVER['HTTPS'] = 'on'; \
    \$_SERVER['SERVER_PORT'] = 443; \
} \
" wp-config.php
fi

sudo chown -R www-data:www-data /srv/nfs/wordpress
