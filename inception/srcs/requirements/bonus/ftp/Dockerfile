FROM alpine:3.21

# ================================
# INSTALLATION DU SERVEUR FTP
# ================================

RUN apk update && \
    apk add --no-cache vsftpd

# ================================
# COPIE DES FICHIERS DE CONFIGURATION
# ================================

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

COPY tools/setup_ftp.sh /usr/local/bin/setup_ftp.sh

# ================================
# PERMISSIONS DU SCRIPT
# ================================

RUN chmod +x /usr/local/bin/setup_ftp.sh

# ================================
# EXPOSITION DES PORTS FTP
# ================================

EXPOSE 21 21000-21010

# ================================
# COMMANDE DE DÉMARRAGE
# ================================

CMD ["/usr/local/bin/setup_ftp.sh"]