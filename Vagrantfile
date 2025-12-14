
  Vagrant.configure("2") do |config|
    config.vm.box = "debian/bookworm64"
    config.vm.box_version = "12.20250126.1"


    # Red Pública -- La propia apertura de puertos
    # Red Privada 2 (Capa 1) -- 192.168.10.0/24
    # Red Privada 3 (Capa 2) -- 192.168.20.0/24
    # Red Privada 4 (Capa 3) -- 192.168.30.0/24
    # Red Privada 5 (Capa 4) -- 192.168.40.0/24


    # Capa 1 - Balanceador de carga Nginx
    config.vm.define "balanceadorCesarGarcia" do |blc|
      blc.vm.hostname = "balanceadorCesarGarcia"
      blc.vm.network "forwarded_port", guest: 443, host: 8443 # "Red pública - Red1"
      blc.vm.network "private_network", ip: "192.168.10.2", virtualbox__intnet: "Red2"
      blc.vm.provision "shell", path: "provisionLB.sh"
    end


    # Capa 2 - Servidores web Nginx y servidor NFS-PHP-FPM

    config.vm.define "serverweb1CesarGarcia" do |web1|
      web1.vm.hostname = "serverweb1CesarGarcia"
      web1.vm.network "private_network", ip: "192.168.10.3", virtualbox__intnet: "Red2"
      web1.vm.network "private_network", ip: "192.168.20.3", virtualbox__intnet: "Red3"
      web1.vm.provision "shell", path: "provisionWeb.sh"
    end

    config.vm.define "serverweb2CesarGarcia" do |web2|
      web2.vm.hostname = "serverweb2CesarGarcia"
      web2.vm.network "private_network", ip: "192.168.10.4", virtualbox__intnet: "Red2"
      web2.vm.network "private_network", ip: "192.168.20.4", virtualbox__intnet: "Red3"
      web2.vm.provision "shell", path: "provisionWeb.sh"
    end

    config.vm.define "serverNFSCesarGarcia" do |nfs|
      nfs.vm.hostname = "serverNFSCesarGarcia"
      nfs.vm.network "private_network", ip: "192.168.20.5", virtualbox__intnet: "Red3"
      nfs.vm.network "private_network", ip: "192.168.30.5", virtualbox__intnet: "Red4"
      nfs.vm.provision "shell", path: "provisionNFS.sh"
    end

    # Capa 3 - Balanceador BBDD

    config.vm.define "proxyBBDDCesarGarcia" do |dbproxy|
      dbproxy.vm.hostname = "proxyBBDDCesarGarcia"
      dbproxy.vm.network "private_network", ip: "192.168.30.6", virtualbox__intnet: "Red4"
      dbproxy.vm.network "private_network", ip: "192.168.40.6", virtualbox__intnet: "Red5"
      dbproxy.vm.provision "shell", path: "provisionDB.sh"  
    end


    # Capa 4 - Clúster de BBDD

    config.vm.define "serverDatos1CesarGarcia" do |db1|
      db1.vm.hostname = "serverDatos1CesarGarcia"
      db1.vm.network "private_network", ip: "192.168.40.7", virtualbox__intnet: "Red5"
      db1.vm.provision "shell", path: "provisionDB.sh"  
    end

    config.vm.define "serverDatos2CesarGarcia" do |db2|
      db2.vm.hostname = "serverDatos2CesarGarcia"
      db2.vm.network "private_network", ip: "192.168.40.8", virtualbox__intnet: "Red5"
      db2.vm.provision "shell", path: "provisionDB.sh"  
    end

end
