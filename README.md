# Pila LEMP en 4 capas
Despliegue de una aplicación web de gestión de usuarios personalizada, en una infraestructura LEMP de alta disponibilidad de 4 capas, que son:
- Balanceo de carga de servidores Nginx
- Servidores Web
- Servidor de procesamiento PHP (PHP-FPM) y servidor gestor almacenamiento compartido (NFS)
- HAProxy para gestionar acceso a la base de datos
- Clúster MariaDB en modo galera

# Índice 

- [1. Vídeo de demonstración](#video)
- [2. Introducción](#intro)
- [3. Explicación del aprovisionamiento del Servidor NFS](#aprov-nfs)
- [4. Explicación del aprovisionamiento de los servidores web](#aprov-web)
- [5. Explicación del aprovisionamiento del balanceador Web](#aprov-balanceador-web)
- [6. Explicación del aprovisionamiento de la BBDD](#aprov-BBDD)
- [7. Explicación del aprovisionamiento del balanceador de BBDD](#aprov-HAProxy)
- [8. Explicación de la configuración en PHP](#php-configuration)
- [9. Disclaimer](#disclaimer)


# Vídeo demonstración

<a name="video"></a>

![Prueba de funcionamiento](./Capturas_de_pantalla/video_demonstracion.mp4)

El vídeo también está disponible aquí:

https://drive.google.com/file/d/1ueWV8WSCezljir5RC7PGWgcWkHspnBYd/view?usp=drive_link

Cubre las siguientes cuestiones:


    Mostrar estado de las m�quinas: vagrant status.
    Ping cada m�quina a todas las dem�s.
    Sistemas de archivos montados en los servidores web: df -h en cada servidor web.
    Acceso a servidor MariaDB desde las m�quinas serverweb1 y serverweb2.
    Acceso a Wordpress desde la m�quina anfitriona (Windows) y el puerto mapeado.
    Mostrar el fichero /var/log/nginx/access.log en el balanceador de carga.
    Mostrar el fichero /var/log/nginx/access.log en los servidores web.
    Para el servidor web serverweb1 y volver a acceder a wordpress desde la m�quina anfitriona.
    Mostrar el fichero /var/log/nginx/access.log en los servidores web.
    Mostrar el contenido de la tabla Usuarios en ambos servidores mariaDB.


# Introducción

<a name="intro"></a>

![Esquema](./Capturas_de_pantalla/esquema_arquitectura.png)

En este proyecto se implementa una pila LEMP (Linux, Nginx, MySQL, PHP) en una arquitectura de 4 capas para garantizar alta disponibilidad y escalabilidad.
La arquitectura se despliega sobre Vagrant utilizando VirtualBox. La parte más complicada de esta práctica reside en la configuración de la comunicación entre los diferentes componentes y la sincronización de datos.

Por un lado, tenemos un clúster de BBDD configurado con HAProxy para balanceo de carga y alta disponibilidad, lo cual supone un desafío frente a una implementación más simple de una BBDD central, pero nos permite una mayor escalabidad, mejor rendimiento y tolerancia a fallos.

Otro desafío de la práctica es la gestión de PHP de manera totalmente separada de la gestión del servicio web. En este laboratorio, los servidores web son ambos capaces de comunicarse con un servidor de doble función (NFS por un lado, y PHP-FPM por otro) que ejecuta los procesos PHP, haciendo las consultas pertinentes de base de datos al servidor HAProxy (que decide a cuál de las dos BBDDD se la manda) y que por otro lado devuelve PHP procesado a los servidores para que estos sólo se encarguen de servir html estático.

<a name="aprov-nfs"></a>

## 1. Aprovisionamiento del Servidor NFS ([AWS_NFS_CesarGarcia.sh](aprov_NFS_PHP_FPM.sh))

Este script configura un servidor NFS (Network File System) para compartir archivos de WordPress entre múltiples servidores web.


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
