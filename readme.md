# 🚀 Projet DevOps - Virtualisation & Automatisation

------

## 📋 **CONTEXTE & PROBLÉMATIQUE**

Ce projet résout les **problèmes de compatibilité environnementale** dans une équipe DevOps de 8 développeurs (Windows/macOS/Linux) en créant un **environnement reproductible** avec :

- **2 Machines Virtuelles** : Web Server (Ubuntu) + Database Server (CentOS)
- **Infrastructure as Code** : Vagrant multi-machines
- **Réseau hybride** : Public + Privé sécurisé
- **Distribution** : Boxes publiées sur [Vagrant Cloud](https://app.vagrantup.com/)

**Problèmes résolus :**
- ❌ Configurations différentes
- ❌ Bugs impossibles à reproduire
- ❌ Setup = 2h pour nouveaux devs
- ❌ Déploiements qui échouent

**Résultat** : `vagrant up` = environnement complet en 5 minutes ! ⏱️

---

### **Prérequis**
```bash
VirtualBox 7.0+    https://www.virtualbox.org/
Vagrant 2.4+       https://www.vagrantup.com/
Git
```

## 🏗️ **ARCHITECTURE COMPLÈTE**

```
┌─────────────────┐    Réseau Public     ┌─────────────────┐
│   UTILISATEUR   │─────────────────────▶│   WEB SERVER    │
│                 │   (192.168.1.0/24)   │   (Ubuntu)      │
└─────────────────┘                      └─────────┬───────┘
                                                   │
                                         Réseau Privé
                                         (192.168.56.0/24)
                                                   │
                  Machine Physique                │
                  Port 3307                       │
                        ▲                         │
                        └─────────────────────────┼───────┐
                                         ┌─────────▼───────┐
                                         │  DATABASE       │
                                         │  (CentOS)       │
                                         └─────────────────┘
```
   --- 
| **Machine** | **OS** | **IP** | **Services** | **Accès** |
|-------------|--------|--------|--------------|-----------|
| **Web** | Ubuntu 22.04 | 192.168.56.10 | Nginx + Site GitHub | `http://IP_PUBLIQUE` |
| **DB** | CentOS 9 | 192.168.56.20 | MySQL 8.0 | `localhost:3307` |

---

## 📁 **STRUCTURE DU PROJET**

```
projet-infra/   
├── Vagrantfile
├── scripts/
│   ├── provision-web-ubuntu.sh
│   └── provision-db-centos.sh
├── website/
│   └── (contenu du repository GitHub cloné)
├── database/
│   ├── create-table.sql
│   └── insert-demo-data.sql
└── README.md
```

## 🚀 DÉMARRER LE PROJET
```

# 1. Démarrer TOUT
vagrant up

# 2. Vérifier status
vagrant status

# 3. Accéder a site web 
vagrant ssh web-server -c "ip addr show enp0s8 | grep inet"
==> Exemple > inet 192.168.1.105/24

# 4. Ouvrir navigateur
http://192.168.1.105

# 5. Test connexion DB (Depuis machine hote pas VM !)
mysql -h localhost -P 3307 -u root -p && SELECT * FROM users;

# 6. Communication réseaux (Depuis VM DB → ping VM Web)
vagrant ssh db-server -c "ping -c 3 192.168.56.10"

```