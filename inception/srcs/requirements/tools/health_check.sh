#!/bin/bash

# ================================
# SCRIPT DE VÉRIFICATION DES SERVICES INCEPTION
# ================================

echo "🔍 Checking Inception services..."

docker compose -f ../../docker-compose.yml ps