
  Vagrant.configure("2") do |config|
    config.vm.box = "debian/bookworm64"
    config.vm.box_version = "12.20250126.1"

    # Máquinas de prueba


    # # Mi arquitectura:
    # # Capa 1 - Balanceador de carga Nginx
    # # Red 10.x: conecta Balanceador con Servidores Web (interfaz del balanceador) -- Red1
    # # Capa 2 - Servidores web Nginx y servidor NFS-PHP-FPM
    # # Red 20.x: conecta Servidores Web con NFS-PHP-FPM -- Red2
    # # Red 30.x: conecta NFS-PHP-FPM con Proxy BBDD -- Red3
    # # Capa 3 - Balanceador BBDD
    # # Red 40.x: conecta Proxy BBDD con Servidores de Datos -- Red4
    # # Capa 4 - Clúster de BBDD


    # Máquina NFS PHP-FPM
    config.vm.define "serverNFSCesarGarcia" do |nfs|
      nfs.vm.hostname = "serverNFSCesarGarcia"
      nfs.vm.network "private_network", ip: "192.168.20.5", virtualbox__intnet: "Red2"
      nfs.vm.network "private_network", ip: "192.168.30.5", virtualbox__intnet: "Red3"
      nfs.vm.provision "shell", path: "provisionNFS_PHP.sh"
    end
    # Máquina WebServer 1
    config.vm.define "serverweb1CesarGarcia" do |web1|
      web1.vm.hostname = "serverweb1CesarGarcia"
      web1.vm.network "forwarded_port", guest: 80, host: 8001 # "Capa1 expuesta a red pública"
      web1.vm.network "private_network", ip: "192.168.10.3", virtualbox__intnet: "Red1"
      web1.vm.network "private_network", ip: "192.168.20.3", virtualbox__intnet: "Red2"
      web1.vm.provision "shell", path: "provisionWeb.sh"
    end

    # Máquina Balanceador Nginx
    config.vm.define "balanceadorCesarGarcia" do |blc|
      blc.vm.hostname = "balanceadorCesarGarcia"
      blc.vm.network "forwarded_port", guest: 80, host: 8000 # "Capa1 expuesta a red pública"
      blc.vm.network "private_network", ip: "192.168.10.2", virtualbox__intnet: "Red1"
      blc.vm.provision "shell", path: "provisionBalanceador.sh"
    end

    config.vm.define "serverDatos1CesarGarcia" do |db1|
      db1.vm.hostname = "serverDatos1CesarGarcia"
      db1.vm.network "private_network", ip: "192.168.30.7", virtualbox__intnet: "Red3" # Red3 por ahora, debería ser 40.7
      db1.vm.provision "shell", path: "provisionDB.sh"  
    end

    # Máquina WebServer 2
    # config.vm.define "serverweb2CesarGarcia" do |web2|
    #   web2.vm.hostname = "serverweb2CesarGarcia"
    #   web2.vm.network "private_network", ip: "192.168.10.4", virtualbox__intnet: "Red1"
    #   web2.vm.network "private_network", ip: "192.168.20.4", virtualbox__intnet: "Red2"
    #   web2.vm.provision "shell", path: "provisionWeb.sh"
    # end


    # config.vm.define "proxyBBDDCesarGarcia" do |dbproxy|
    #   dbproxy.vm.hostname = "proxyBBDDCesarGarcia"
    #   dbproxy.vm.network "private_network", ip: "192.168.30.6", virtualbox__intnet: "Red3"
    #   dbproxy.vm.network "private_network", ip: "192.168.40.6", virtualbox__intnet: "Red4"
    #   dbproxy.vm.provision "shell", path: "provisionProxyDB.sh"  
    # end


    # config.vm.define "serverDatos2CesarGarcia" do |db2|
    #   db2.vm.hostname = "serverDatos2CesarGarcia"
    #   db2.vm.network "private_network", ip: "192.168.40.8", virtualbox__intnet: "Red4"
    #   db2.vm.provision "shell", path: "provisionDB.sh"  
    # end

end
