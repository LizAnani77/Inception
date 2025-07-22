#!/bin/sh

# ================================
# CONFIGURATION DES COULEURS POUR LES LOGS
# ================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[FTP INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[FTP ATTENTION]${NC} $1"; }
log_error() { echo -e "${RED}[FTP ERREUR]${NC} $1"; }

# ================================
# INITIALISATION DU SERVEUR FTP
# ================================

log_info "Configuration du serveur FTP..."

# ================================
# CRÉATION DE L'UTILISATEUR FTP
# ================================

if ! id "$FTP_USER" &>/dev/null; then
    log_info "Création de l'utilisateur FTP : $FTP_USER"
    
    adduser --disabled-password --gecos "" "$FTP_USER"
    
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
else
    log_info "L'utilisateur $FTP_USER existe déjà"
fi

# ================================
# CONFIGURATION DU RÉPERTOIRE HOME FTP
# ================================

mkdir -p /home/$FTP_USER

chown $FTP_USER:$FTP_USER /home/$FTP_USER

# ================================
# CONFIGURATION DES AUTORISATIONS VSFTPD
# ================================

echo "$FTP_USER" > /etc/vsftpd.userlist

# ================================
# CONFIGURATION DES PERMISSIONS
# ================================

chmod 755 /home/$FTP_USER

# ================================
# LIAISON DU FICHIER USERLIST POUR VSFTPD
# ================================

ln -sf /etc/vsftpd.userlist /etc/vsftpd.user_list

# ================================
# DÉMARRAGE DU SERVEUR VSFTPD
# ================================

log_info "Démarrage de vsftpd..."

exec vsftpd /etc/vsftpd/vsftpd.conf