#!/bin/bash
# Nginx Load Balancer Provisioning Script for Debian

sudo apt update -y

sudo apt install -y nginx

echo "Creating Nginx load balancer configuration..."
cat > /etc/nginx/sites-available/balanceador <<EOL
upstream backend {
    server 192.168.10.3;
}

server {
    listen 80;

    location / {
        proxy_pass http://192.168.10.3:80;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

ln -sf /etc/nginx/sites-available/balanceador /etc/nginx/sites-enabled/balanceador

nginx -t

ln -sf /etc/nginx/sites-available/balanceador /etc/nginx/sites-enabled/balanceador
sudo rm -f /etc/nginx/sites-enabled/default

systemctl restart nginx

