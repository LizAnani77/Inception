FROM nginx:alpine

# ================================
# COPIE DE LA CONFIGURATION
# ================================

COPY nginx.conf /etc/nginx/nginx.conf

# ================================
# COPIE DES CERTIFICATS SSL
# ================================

COPY ssl /etc/nginx/ssl

# ================================
# COPIE DU CONTENU STATIQUE
# ================================

COPY html /var/www/static

# ================================
# DÉMARRAGE AUTOMATIQUE
# ================================

# Pas besoin de CMD car l'image nginx:alpine démarre automatiquement Nginx
# La commande par défaut de l'image de base est : ["nginx", "-g", "daemon off;"]
# Cette commande lance Nginx en mode foreground (nécessaire pour Docker)