#!/bin/bash

echo "=== Début du provisioning Web Server Ubuntu ==="

# Mise à jour du système
apt-get update -y
apt-get upgrade -y

# Installation de Nginx et Git
apt-get install -y nginx git curl

# Configuration de Nginx
systemctl start nginx
systemctl enable nginx

# Création du dossier website s'il n'existe pas
mkdir -p /var/www/html

# Le site web sera monté automatiquement via le dossier partagé
echo "Le site web sera servi depuis le dossier partagé /var/www/html"

# Permissions correctes
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Configuration Nginx personnalisée
cat > /etc/nginx/sites-available/default << 'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    
    server_name _;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    # Logs
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}
EOF

# Redémarrage de Nginx
systemctl restart nginx

# Configuration du firewall
ufw allow 'Nginx Full'
ufw allow ssh
ufw --force enable

# Vérification du statut
systemctl status nginx --no-pager

echo "=== Web Server configuré avec succès ==="
echo "Site accessible via l'IP publique de la machine"