#!/bin/bash
# Script de provisionamiento para el servidor de base de datos
# Instala MariaDB y configura los servicios básicos

sudo apt update
sudo apt install mariadb-server mariadb-backup galera-4 -y
sudo apt install net-tools -y

root_pass="roottoor"

user_db="dbuser"
pass_db="dbpass"
db="web0app"

sudo tee /etc/mysql/mariadb.conf.d/90-galera.cnf > /dev/null <<'EOF'
[mysqld]
wsrep_on=ON
wsrep_provider=/usr/lib/galera/libgalera_smm.so
wsrep_cluster_name=galera_cluster
wsrep_cluster_address=gcomm://192.168.40.7,192.168.40.8

wsrep_node_name=db2
wsrep_node_address=192.168.40.8

binlog_format=ROW
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2

bind-address=192.168.40.8
EOF

echo "Base de datos y usuario configurados correctamente."
echo "Contraseña root: $root_pass"
echo "Contraseña dbuser: $pass_db"

# Reiniciar MariaDB para aplicar los cambios
sudo systemctl restart mariadb