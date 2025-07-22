FROM alpine:3.21

# ================================
# INSTALLATION DES DÉPENDANCES
# ================================

RUN apk update && apk add php php-session php-mysqli php-pdo php-pdo_mysql php-fpm nginx curl

# ================================
# CRÉATION DE L'UTILISATEUR WWW-DATA
# ================================

RUN if ! getent group www-data > /dev/null 2>&1; then \
        addgroup -g 82 -S www-data; \
    fi && \
    if ! getent passwd www-data > /dev/null 2>&1; then \
        adduser -u 82 -D -S -G www-data www-data; \
    fi

# ================================
# TÉLÉCHARGEMENT ET INSTALLATION D'ADMINER
# ================================

RUN mkdir -p /var/www/html && \
    curl -L -o /var/www/html/index.php https://www.adminer.org/latest.php

# ================================
# CONFIGURATION NGINX POUR ADMINER
# ================================

RUN echo 'server {' > /etc/nginx/http.d/default.conf && \
    echo '    listen 8080;' >> /etc/nginx/http.d/default.conf && \
    echo '    root /var/www/html;' >> /etc/nginx/http.d/default.conf && \
    echo '    index adminer.php index.php;' >> /etc/nginx/http.d/default.conf && \
    echo '    location ~ \.php$ {' >> /etc/nginx/http.d/default.conf && \
    echo '        fastcgi_pass 127.0.0.1:9000;' >> /etc/nginx/http.d/default.conf && \
    echo '        fastcgi_index index.php;' >> /etc/nginx/http.d/default.conf && \
    echo '        include fastcgi_params;' >> /etc/nginx/http.d/default.conf && \
    echo '        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> /etc/nginx/http.d/default.conf && \
    echo '    }' >> /etc/nginx/http.d/default.conf && \
    echo '}' >> /etc/nginx/http.d/default.conf

# ================================
# COPIE DU SCRIPT DE DÉMARRAGE
# ================================

COPY tools/start_adminer.sh /start_adminer.sh

RUN chmod +x /start_adminer.sh

# ================================
# EXPOSITION DU PORT
# ================================

EXPOSE 8080

# ================================
# COMMANDE DE DÉMARRAGE
# ================================

CMD ["/start_adminer.sh"]