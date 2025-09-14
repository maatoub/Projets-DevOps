#!/bin/bash

echo "=== Début du provisioning Database Server CentOS ==="

# Mise à jour du système
dnf update -y

# Installation de MySQL
dnf install -y mysql-server mysql

# Démarrage et activation de MySQL
systemctl start mysqld
systemctl enable mysqld

# Attendre que MySQL soit prêt
sleep 10

# Sécurisation basique de MySQL
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';"
mysql -u root -proot -e "DELETE FROM mysql.user WHERE User='';"
mysql -u root -proot -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -u root -proot -e "DROP DATABASE IF EXISTS test;"
mysql -u root -proot -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mysql -u root -proot -e "FLUSH PRIVILEGES;"

# Création de la base de données et table
echo "=== Création de la base de données et de la table ==="

mysql -u root -proot << 'EOF'
CREATE DATABASE IF NOT EXISTS demo_db;
USE demo_db;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (nom, email) VALUES
('Youssef Amrani', 'youssef.amrani@email.ma'),
('Fatima Idrissi', 'fatima.idrissi@email.ma'),
('Rachid Bennis', 'rachid.bennis@email.ma'),
('Amine Fadili', 'amine.fadili@email.ma'),
('Khalid Tazi', 'khalid.tazi@email.ma'),
EOF

# Création d'un utilisateur pour l'accès distant
mysql -u root -proot -e "CREATE USER 'vagrant'@'%' IDENTIFIED BY 'vagrant';"
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON demo_db.* TO 'vagrant'@'%';"
mysql -u root -proot -e "FLUSH PRIVILEGES;"

# Configuration MySQL pour accepter les connexions externes
sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf 2>/dev/null || true
echo "bind-address = 0.0.0.0" >> /etc/my.cnf

# Ouverture du firewall
firewall-cmd --permanent --add-port=3306/tcp
firewall-cmd --reload

# Redémarrage de MySQL
systemctl restart mysqld

# Vérification
systemctl status mysqld --no-pager
mysql -u root -proot -e "SELECT COUNT(*) as nb_users FROM demo_db.users;"

echo "=== Database Server configuré avec succès ==="
echo "Base de données accessible via localhost:3307 depuis la machine hôte"