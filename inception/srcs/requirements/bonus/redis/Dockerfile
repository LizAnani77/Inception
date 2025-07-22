FROM alpine:3.21

# ================================
# INSTALLATION DE REDIS
# ================================

RUN apk update && apk add redis

# ================================
# COPIE DE LA CONFIGURATION
# ================================

COPY redis.conf /etc/redis/redis.conf

# ================================
# EXPOSITION DU PORT
# ================================

EXPOSE 6379

# ================================
# COMMANDE DE DÉMARRAGE
# ================================

CMD ["redis-server", "/etc/redis/redis.conf"]