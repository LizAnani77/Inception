FROM debian:bookworm-slim

# ================================
# INSTALLATION DES DÉPENDANCES
# ================================

RUN apt-get update && \
    apt-get install -y \
        php8.2-fpm \
        php8.2-mysql \
        php8.2-curl \
        php8.2-gd \
        php8.2-mbstring \
        php8.2-xml \
        php8.2-zip \
        php8.2-redis \
        wget \
        unzip \
        mariadb-client \
        curl \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# ================================
# CONFIGURATION DES RÉPERTOIRES PERMISSIONS PORTS PHP
# ================================

RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/' /etc/php/8.2/fpm/pool.d/www.conf && \
    mkdir -p /run/php

WORKDIR /var/www/html

RUN apt update && apt install -y redis-tools

RUN curl -L -o wp-cli.phar https://github.com/wp-cli/wp-cli/releases/download/v2.8.1/wp-cli-2.8.1.phar && \
    chmod +x wp-cli.phar && \
    php wp-cli.phar --info && \
    mv wp-cli.phar /usr/local/bin/wp

# ================================
# COPIE DES FICHIERS DE CONFIGURATION
# ================================

COPY tools/setup_wordpress.sh /usr/local/bin/setup_wordpress.sh

COPY conf/php.ini /usr/local/etc/php/conf.d/custom.ini

COPY conf/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN chmod +x /usr/local/bin/setup_wordpress.sh

EXPOSE 9000

CMD ["/usr/local/bin/setup_wordpress.sh"]