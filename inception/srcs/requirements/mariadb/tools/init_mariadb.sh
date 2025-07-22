#!/bin/bash

# ================================
# CONFIGURATION DES COULEURS POUR LES LOGS
# ================================

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[MariaDB INFO]${NC} $1"; }
log_error() { echo -e "${RED}[MariaDB ERREUR]${NC} $1"; }

# ================================
# LECTURE DES SECRETS DOCKER
# ================================

if [ -f /run/secrets/db_root_password ]; then
    DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
else
    log_error "Secret db_root_password introuvable"
    exit 1
fi

if [ -f /run/secrets/db_user_password ]; then
    DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)
else
    log_error "Secret db_user_password introuvable"
    exit 1
fi

# ================================
# GESTION DE L'INITIALISATION (IDEMPOTENCE)
# ================================

if [ -f /var/lib/mysql/.configured ]; then
    log_info "Base déjà configurée, démarrage direct..."
else
    log_info "Première configuration..."
    
# ================================
# NETTOYAGE ET INSTALLATION PROPRE
# ================================
    
rm -rf /var/lib/mysql/*
    
   mysql_install_db --user=mysql --datadir=/var/lib/mysql --basedir=/usr
    
# ================================
# CRÉATION DU SCRIPT D'INITIALISATION SQL
# ================================
    
cat > /tmp/mysql-init.sql << EOF
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# ================================
# EXÉCUTION DE LA CONFIGURATION INITIALE
# ================================
    
log_info "Configuration initiale..."

mysqld --user=mysql --bootstrap --verbose=0 < /tmp/mysql-init.sql
    
rm -f /tmp/mysql-init.sql

touch /var/lib/mysql/.configured
log_info "Configuration terminée"
fi

# ================================
# DÉMARRAGE DE MARIADB
# ================================

log_info "Démarrage de MariaDB..."

exec mysqld --user=mysql --console --bind-address=0.0.0.0