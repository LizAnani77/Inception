FROM alpine:3.21

# ================================
# INSTALLATION DES DÉPENDANCES
# ================================

RUN apk update && \
    apk add nginx openssl
    # nginx : serveur web/reverse proxy
    # openssl : outil pour générer des certificats SSL/TLS

# ================================
# COPIE DES FICHIERS DE CONFIGURATION
# ================================

COPY conf /etc/nginx

COPY tools/generate_ssl.sh /generate_ssl.sh

# ================================
# EXECUTION DU SCRIPT SSL
# ================================

RUN chmod +x /generate_ssl.sh && /generate_ssl.sh

# ================================
# EXPOSITION DU PORT ET SÉCURITÉ
# ================================

EXPOSE 443

# ================================
# COMMANDE DE DÉMARRAGE
# ================================

CMD ["nginx", "-g", "daemon off;"]