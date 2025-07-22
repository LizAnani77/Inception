#!/bin/bash

# ================================
# CONFIGURATION DES COULEURS POUR LES LOGS
# ================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[WordPress INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WordPress ATTENTION]${NC} $1"; }
log_error() { echo -e "${RED}[WordPress ERREUR]${NC} $1"; }

# ================================
# LECTURE DES SECRETS DOCKER
# ================================

if [ -f /run/secrets/db_user_password ]; then
    MYSQL_PASSWORD=$(cat /run/secrets/db_user_password)
else
    log_error "Secret db_user_password introuvable"
    exit 1
fi

# ================================
# ATTENTE DE LA DISPONIBILITÉ DE MARIADB
# ================================

log_info "Attente de la disponibilité de MariaDB..."

while ! mysqladmin ping -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
    log_info "Connexion à MariaDB en cours..."
    sleep 2
done

log_info "MariaDB est prêt, configuration de WordPress..."

# ================================
# TÉLÉCHARGEMENT ET CONFIGURATION DE WORDPRESS
# ================================

if [ ! -f wp-config.php ]; then
    log_info "Téléchargement de WordPress..."
    wp core download --allow-root
    
    log_info "Création du fichier wp-config.php..."
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$MYSQL_HOST" \
        --allow-root
fi

# ================================
# INSTALLATION DE WORDPRESS
# ================================

if ! wp core is-installed --allow-root 2>/dev/null; then
    log_info "Installation de WordPress..."
    wp core install \
        --url="https://$DOMAIN_NAME" \
        --title="Inception WordPress" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    log_info "Création d'un utilisateur WordPress supplémentaire..."
    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=editor \
        --allow-root

    log_info "Installation de WordPress terminée !"
fi

# ================================
# 🔧 CORRECTION DES MOTS DE PASSE (AJOUT SIMPLE)
# ================================

log_info "Vérification et correction des mots de passe utilisateurs..."

# Correction du mot de passe admin
log_info "Mise à jour du mot de passe administrateur..."
if ! wp user update "$WP_ADMIN_USER" --user_pass="$WP_ADMIN_PASSWORD" --allow-root 2>/dev/null; then
    log_warn "Échec WP-CLI pour admin, utilisation de SQL direct..."
    mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" <<EOF
UPDATE wp_users SET user_pass = MD5('$WP_ADMIN_PASSWORD') WHERE user_login = '$WP_ADMIN_USER';
EOF
    log_info "Mot de passe admin mis à jour via SQL"
else
    log_info "Mot de passe admin mis à jour via WP-CLI"
fi

# Correction du mot de passe utilisateur
log_info "Mise à jour du mot de passe utilisateur standard..."
if ! wp user update "$WP_USER" --user_pass="$WP_USER_PASSWORD" --allow-root 2>/dev/null; then
    log_warn "Échec WP-CLI pour utilisateur, utilisation de SQL direct..."
    mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" <<EOF
UPDATE wp_users SET user_pass = MD5('$WP_USER_PASSWORD') WHERE user_login = '$WP_USER';
EOF
    log_info "Mot de passe utilisateur mis à jour via SQL"
else
    log_info "Mot de passe utilisateur mis à jour via WP-CLI"
fi

# ================================
# CONFIGURATION REDIS
# ================================

until redis-cli -h "$REDIS_HOST" ping > /dev/null 2>&1; do
  log_info "Attente de Redis..."
  sleep 2
done


log_info "Configuration du cache Redis..."

# Vérification de la connectivité Redis
if redis-cli -h "$REDIS_HOST" ping > /dev/null 2>&1; then
    log_info "Redis est accessible, configuration du cache WordPress..."

    # Forcer l'activation du plugin Redis Object Cache
    log_info "Activation forcée du plugin Redis Object Cache..."
    wp plugin activate redis-cache --allow-root || log_info "Plugin redis-cache déjà activé"

    # Installation du plugin Redis Object Cache si pas déjà installé
    if ! wp plugin is-installed redis-cache --allow-root 2>/dev/null; then
        log_info "Installation du plugin Redis Object Cache..."
        wp plugin install redis-cache --activate --allow-root
    fi

    # Configuration Redis dans wp-config.php
    if ! grep -q "REDIS_HOST" wp-config.php; then
        log_info "Ajout de la configuration Redis dans wp-config.php..."
        sed -i "/\/\* That's all, stop editing! \*\//i\\
\\
\/\* Redis Configuration \*\/\\
define('WP_REDIS_HOST', '$REDIS_HOST');\\
define('WP_REDIS_PORT', 6379);\\
define('WP_REDIS_TIMEOUT', 1);\\
define('WP_REDIS_READ_TIMEOUT', 1);\\
define('WP_REDIS_DATABASE', 0);\\
" wp-config.php
    fi

    # Activation du cache Redis
    if wp redis status --allow-root 2>/dev/null | grep -q "Connected"; then
        log_info "Cache Redis déjà activé"
    else
        log_info "Activation du cache Redis..."
        wp redis enable --allow-root 2>/dev/null || log_warn "Impossible d'activer Redis automatiquement"
    fi
else
    log_warn "Redis n'est pas accessible, passage en mode sans cache"
fi

# ================================
# CONFIGURATION DES PERMISSIONS
# ================================

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# ================================
# DÉMARRAGE DE PHP-FPM
# ================================

log_info "Démarrage de PHP-FPM..."
log_info "🚀 WordPress est configuré et prêt !"
log_info "📝 Admin: $WP_ADMIN_USER / $WP_ADMIN_PASSWORD"
log_info "👤 User: $WP_USER / $WP_USER_PASSWORD"

exec php-fpm8.2 -F