#!/bin/bash
# Script de provisionamiento para el servidor web
# Instala Nginx y configura los servicios básicos

NFS_SERVER="192.168.20.5"
NFS_EXPORT="/var/www/app"

APP_DIR="/var/www/app"


sudo apt update
sudo apt install -y nginx
sudo apt install -y nfs-common 

sudo mkdir -p $APP_DIR

echo "$NFS_SERVER:$NFS_EXPORT $APP_DIR nfs defaults,_netdev 0 0" | sudo tee -a /etc/fstab
sudo mount $NFS_SERVER:$NFS_EXPORT $APP_DIR

NGINX_SITE="/etc/nginx/sites-available/app"
sudo tee $NGINX_SITE > /dev/null << 'EOF'
server {
    listen 80;
    server_name _;

    root /var/www/app;
    index index.php index.html;

    location / {
        index index.php index.html;
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        # Reenvio a PHP-FPM
        include fastcgi_params;
        include snippets/fastcgi-php.conf;
        fastcgi_pass 192.168.20.5:9000;
        fastcgi_param SCRIPT_FILENAME /var/www/app$fastcgi_script_name;
        # fastcgi_index index.php;
    }
}
EOF




sudo ln -sf /etc/nginx/sites-available/app /etc/nginx/sites-enabled/app
sudo rm -f /etc/nginx/sites-enabled/default

sudo systemctl restart nginx.service