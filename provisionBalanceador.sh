#!/bin/bash
# Script de provisionamiento para el balanceador Nginx
# Instala Nginx y configura los servicios básicos

sudo apt update
sudo apt install -y nginx

# Backend webservers (se declara como lista y así es más escalable)
WEB_BACKENDS=("192.168.10.3" "192.168.10.4")

# Configuración del upstream
UPSTREAM_CONF="/etc/nginx/conf.d/upstream.conf"
sudo tee $UPSTREAM_CONF > /dev/null <<EOF
upstream backend {
EOF

for server in "${WEB_BACKENDS[@]}"; do
  echo "    server $server;" | sudo tee -a $UPSTREAM_CONF
done

sudo tee -a $UPSTREAM_CONF > /dev/null <<EOF
}
EOF

# Configuración del sitio principal
NGINX_SITE="/etc/nginx/sites-available/loadbalancer"
sudo tee $NGINX_SITE > /dev/null <<'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/loadbalancer /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo systemctl restart nginx
sudo systemctl enable nginx
