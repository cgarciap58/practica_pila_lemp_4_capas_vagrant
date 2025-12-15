#!/bin/bash
# Script de provisionamiento para el servidor de base de datos
# Instala MariaDB y configura los servicios básicos

sudo apt update
sudo apt install mariadb-server -y
sudo apt install net-tools -y

user_wp="wpuser"
root_pass="roottoor"
pass_wp="wppw"

# Script equivalente a mysql_secure_installation
sudo mariadb <<EOF
-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';

-- Remove remote root accounts
DROP USER IF EXISTS 'root'@'%';

-- Optional: set root password for local login
ALTER USER 'root'@'localhost' IDENTIFIED BY '$root_pass';

-- Remove test database
DROP DATABASE IF EXISTS test;

-- Reload privilege tables
FLUSH PRIVILEGES;
EOF

mysql -u root -p"$root_pass" -e "CREATE DATABASE wordpress;"
mysql -u root -p"$root_pass" -e "SHOW DATABASES;"
mysql -u root -p"$root_pass" -e "CREATE USER '$user_wp'@'192.168.30.%' IDENTIFIED BY '$pass_wp';"
mysql -u root -p"$root_pass" -e "GRANT ALL PRIVILEGES ON wordpress.* TO '$user_wp'@'192.168.30.%';"
mysql -u root -p"$root_pass" -e "FLUSH PRIVILEGES;"

echo "Base de datos y usuario configurados correctamente."
echo "Contraseña root: $root_pass"
echo "Contraseña wpuser: $pass_wp"

# Configurar MariaDB para aceptar conexiones remotas en su IP (192.168.30.7)
sudo sed -i "s/^bind-address\s*=.*/bind-address = 192.168.30.7/" /etc/mysql/mariadb.conf.d/50-server.cnf
echo "MariaDB configurado para aceptar conexiones remotas en 192.168.30.7"
sudo systemctl restart mariadb
