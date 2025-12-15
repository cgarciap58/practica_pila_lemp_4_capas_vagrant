#!/bin/bash
# Script de provisionamiento para el servidor web
# Instala Nginx y configura los servicios básicos

NFS_SERVER="192.168.20.5"
NFS_EXPORT="/srv/nfs/wordpress"
WEB_ROOT="/var/www/wordpress"

sudo apt update
sudo apt install -y nginx
sudo apt install -y nfs-common 

sudo mkdir -p $WEB_ROOT

sudo mount $NFS_SERVER:$NFS_EXPORT $WEB_ROOT

NGINX_SITE="/etc/nginx/sites-available/wordpress"
sudo tee $NGINX_SITE > /dev/null << 'EOF'
server {
    listen 80;
    server_name _;

    root /var/www/wordpress;
    index index.php index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        # Reenvio a PHP-FPM
        fastcgi_pass 192.168.20.5:9000;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME /srv/nfs/wordpress$fastcgi_script_name;
    }
}
EOF

echo "$NFS_SERVER:$NFS_EXPORT $WEB_ROOT nfs defaults,_netdev 0 0" | sudo tee -a /etc/fstab

sudo ln -sf /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

sudo systemctl restart nginx.service