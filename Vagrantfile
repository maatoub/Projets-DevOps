# Variables de configuration
WEB_IP = "192.168.56.10"
DB_IP = "192.168.56.20"
DB_PORT = 3307

Vagrant.configure("2") do |config|
  
  # Configuration globale
  config.vm.box_check_update = false
  
  # Machine 1: Web Server (Ubuntu)
  config.vm.define "web-server" do |web|
    web.vm.box = "bento/ubuntu-22.04"
    web.vm.hostname = "web-server"
    
    # Configuration réseau
    web.vm.network "public_network"
    web.vm.network "private_network", ip: WEB_IP
    
    # Configuration des dossiers partagés
    web.vm.synced_folder ".", "/vagrant", disabled: true
    web.vm.synced_folder "./website/", "/var/www/html/", create: true
    web.vm.synced_folder "D:/DevOps/Cours/", "/home/vagrant/cours", create: true
    
    # Configuration VirtualBox
    web.vm.provider "virtualbox" do |vb|
      vb.name = "web-server-ubuntu"
      vb.memory = "1024"
      vb.cpus = 2
      vb.gui = false
    end
    
    # Provisioning
    web.vm.provision "shell", path: "scripts/provision-web-ubuntu.sh"
  end
  
  # Machine 2: Database Server (CentOS)
  config.vm.define "db-server" do |db|
    db.vm.box = "bento/centos-stream-9"
    db.vm.hostname = "db-server"
    
    # Configuration réseau
    db.vm.network "private_network", ip: DB_IP
    db.vm.network "forwarded_port", guest: 3306, host: DB_PORT
    
    # DÉSACTIVER TOUS LES DOSSIERS PARTAGÉS
    db.vm.synced_folder ".", "/vagrant", disabled: true
    
    # Configuration VirtualBox
    db.vm.provider "virtualbox" do |vb|
      vb.name = "db-server-centos"
      vb.memory = "2048"
      vb.cpus = 2
      vb.gui = false
    end
    
    # Provisioning
    db.vm.provision "shell", path: "scripts/provision-db-centos.sh"
  end
  
end