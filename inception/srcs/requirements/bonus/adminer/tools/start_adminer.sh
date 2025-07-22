#!/bin/sh

# Définition des codes couleur ANSI pour améliorer la lisibilité des logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Fonctions utilitaires pour l'affichage des messages avec couleurs
log_info() { echo -e "${GREEN}[Adminer INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[Adminer ATTENTION]${NC} $1"; }
log_error() { echo -e "${RED}[Adminer ERREUR]${NC} $1"; }

# ================================
# DÉMARRAGE DES SERVICES ADMINER
# ================================

log_info "Démarrage des services Adminer..."

# ================================
# DÉMARRAGE DE PHP-FPM
# ================================


log_info "Démarrage de PHP-FPM..."
php-fpm83 -D


# ================================
# ATTENTE DE L'INITIALISATION
# ================================

sleep 2

# ================================
# DÉMARRAGE DE NGINX
# ================================

log_info "Démarrage de Nginx..."

exec nginx -g "daemon off;"