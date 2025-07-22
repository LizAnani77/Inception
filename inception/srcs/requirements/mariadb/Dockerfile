FROM debian:bookworm

# ================================
# INSTALLATION DES DÉPENDANCES
# ================================

RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*


# ================================
# CONFIGURATION RÉSEAU
# ================================

RUN sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf

# ================================
# CONFIGURATION DES RÉPERTOIRES ET PERMISSIONS
# ================================

RUN mkdir -p /run/mysqld && \
    chown mysql:mysql /run/mysqld && \
    chmod 755 /run/mysqld


# ================================
# COPIE DES FICHIERS DE CONFIGURATION
# ================================

COPY tools/init_mariadb.sh /usr/local/bin/init_mariadb.sh

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod +x /usr/local/bin/init_mariadb.sh

# ================================
# PRÉPARATION DU RÉPERTOIRE DE DONNÉES
# ================================

RUN mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql

# ================================
# EXPOSITION DU PORT ET SÉCURITÉ
# ================================

EXPOSE 3306

USER mysql

# ================================
# COMMANDE DE DÉMARRAGE
# ================================

CMD ["/usr/local/bin/init_mariadb.sh"]