#!/bin/bash
# Script de provisionamiento para el servidor de base de datos
# Instala MariaDB y configura los servicios básicos

sudo apt update
sudo apt install mariadb-server -y
sudo apt install net-tools -y

root_pass="roottoor"

user_db="dbuser"
pass_db="dbpass"
db="web0app"


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

mysql -u root -p"$root_pass" -e "CREATE DATABASE $db;"
mysql -u root -p"$root_pass" -e "SHOW DATABASES;"
mysql -u root -p"$root_pass" -e "CREATE USER '$user_db'@'%' IDENTIFIED BY '$pass_db';"
mysql -u root -p"$root_pass" -e "GRANT ALL PRIVILEGES ON $db.* TO '$user_db'@'%';"
mysql -u root -p"$root_pass" -e "FLUSH PRIVILEGES;"

mysql -u root -p"$root_pass" -e "USE $db; CREATE TABLE users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  age INT UNSIGNED NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
"



echo "Base de datos y usuario configurados correctamente."
echo "Contraseña root: $root_pass"
echo "Contraseña dbuser: $pass_db"

# Configurar MariaDB para aceptar conexiones remotas en su IP (192.168.30.7)
sudo sed -i "s/^bind-address\s*=.*/bind-address = 192.168.30.7/" /etc/mysql/mariadb.conf.d/50-server.cnf
echo "MariaDB configurado para aceptar conexiones remotas en 192.168.30.7"
sudo systemctl restart mariadb
