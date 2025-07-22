#!/bin/sh

# ================================
# GENERATION SSL
# ================================

SSL_DIR=/etc/nginx/ssl

mkdir -p "$SSL_DIR"

openssl req -x509 -nodes -days 365 \
  -subj "/C=FR/ST=France/L=Paris/O=42/CN=lanani-f.42.fr" \
  -newkey rsa:2048 \
  -keyout "$SSL_DIR/server.key" \
  -out "$SSL_DIR/server.crt"