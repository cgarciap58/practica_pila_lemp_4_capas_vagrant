# Pila LEMP en 4 capas
Despliegue de una aplicación web de gestión de usuarios personalizada, en una infraestructura LEMP de alta disponibilidad de 4 capas, que son:
- Balanceo de carga de servidores Nginx
- Servidores Web
- Servidor de procesamiento PHP (PHP-FPM) y servidor gestor almacenamiento compartido (NFS)
- HAProxy para gestionar acceso a la base de datos
- Clúster MariaDB en modo galera

# Índice

- [1. Aprovisionamiento del Servidor NFS](#nfs-server)
- [2. Aprovisionamiento del Servidor de Web](#database-server)
- [3. Aprovisionamiento de los servidores de BBDD](#web-servers)
- [4. Aprovisionamiento de HAProxy](#haproxy)
- [5. Modificaciones en PHP](#php-modifications)
- [6. Disclaimer](#disclaimer)




# Vídeo demonstración

![Prueba de funcionamiento](./CapturaPantallaWP.png)

# Índice 

- [1. Aprovisionamiento del Servidor NFS](#aprov-nfs)
- [2. Aprovisionamiento de los servidores web](#aprov-web)
- [3. Aprovisionamiento del balanceador Web](#aprov-balanceador-web)
- [4. Aprovisionamiento de la BBDD](#aprov-BBDD)
- [5. Aprovisionamiento del balanceador de BBDD](#aprov-HAProxy)
- [6. Configuración en PHP](#php-configuration)
- [7. Disclaimer](#disclaimer)

<a name="aprov-nfs"></a>

## 1. Aprovisionamiento del Servidor NFS ([AWS_NFS_CesarGarcia.sh](aprov_NFS_PHP_FPM.sh))

Este script configura un servidor NFS (Network File System) para compartir archivos de WordPress entre múltiples servidores web.

### Componentes Clave

- **Instalación de NFS**: Instala el paquete del servidor NFS
- **Configuración de Directorios**: Crea `/srv/nfs/wordpress` con los permisos adecuados
- **Exportación NFS**: Hace el directorio disponible para los servidores web
- **Gestión del Servicio**: Habilita y reinicia el servicio NFS

### Explicación Detallada

```bash

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

```

Actualiza el repositorio 
