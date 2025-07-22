# Inception

## 📚 Résumé

Le projet Inception consiste à créer une infrastructure web sécurisée et modulaire dans une machine virtuelle, en utilisant Docker et Docker Compose.  
Chaque service (WordPress, MariaDB, NGINX...) tourne dans un conteneur dédié, construit manuellement à partir de Dockerfiles personnalisés.  
L’accès au site WordPress est sécurisé via HTTPS (TLSv1.2 ou TLSv1.3) grâce à un reverse proxy NGINX.

---

## ⚙️ Exécution

make                 # Démarrer l'infrastructure  
make down            # Arrêter les services  
make fclean          # Nettoyer volumes et images  

---

## 📐 Contraintes techniques

- Conteneurs distincts pour chaque service
- Basé uniquement sur Alpine ou Debian (pas de 'latest')
- Aucun mot de passe en dur dans les Dockerfiles
- Utilisation d’un fichier .env + secrets recommandée
- Réseau Docker personnalisé
- Pas de 'tail -f', 'sleep infinity', ou boucles infinies
- Le service NGINX est le seul point d’entrée (port 443)
- Utilisation obligatoire de docker-compose

---

## 🧱 Services obligatoires

NGINX      : Reverse proxy HTTPS (TLSv1.2 ou TLSv1.3), point d’entrée unique  
WordPress  : CMS déployé avec PHP-FPM (sans NGINX intégré)  
MariaDB    : Base de données pour WordPress avec deux utilisateurs (admin non nommé "admin")  

Deux volumes sont requis :  
- wordpress-data : fichiers du site WordPress  
- mariadb-data   : données de la base  

---

## 📄 Structure du projet

srcs/  
├── requirements/  
│   ├── nginx/  
│   ├── wordpress/  
│   ├── mariadb/  
│   └── bonus/  
├── .env  
└── docker-compose.yml  

secrets/  
├── credentials.txt  
├── db_password.txt  
└── db_root_password.txt  

Makefile

---

## 🌐 Nom de domaine local

- Le domaine est de la forme login.42.fr (ex: lanani-f.42.fr)
- Ce domaine pointe vers l’IP locale de la VM
- Seul le port 443 (HTTPS) doit être exposé

---

## ✅ Fonctionnalités requises

- Infrastructure lancée automatiquement via make
- Réseau privé Docker entre les services
- Configuration SSL fonctionnelle
- Services redémarrent automatiquement après crash

---

## 🧪 Tests recommandés

curl -k https://login.42.fr         # Vérifier la page HTTPS  
docker volume ls                    # Consulter les volumes  
docker network inspect inception    # Vérifier le réseau Docker  
docker ps                           # Vérifier les services actifs  

---

## 🌟 Bonus

Redis         : Cache WordPress  
FTP           : Serveur FTP pointant sur WordPress  
Site statique : Vitrine HTML/CSS (pas de PHP)  
Adminer       : Interface de gestion base de données  
Service libre : Portainer interface web graphique pour visualiser les conteneurs

---

## 🏗️ Étapes recommandées

1. Définir l’arborescence (srcs/, secrets/, Makefile)
2. Créer les Dockerfiles pour chaque service
3. Configurer les volumes
4. Générer les certificats SSL (dans le Dockerfile ou au démarrage)
5. Compléter .env et docker-compose.yml
6. Tester WordPress en HTTPS
7. Ajouter les bonus

---

## 🧠 Bonnes pratiques

- Pas d’informations sensibles dans Git
- Séparation stricte des services
- Dockerfiles lisibles, bien structurés
- Scripts d’init minimalistes (pas de patchs bidons)
- Gestion correcte du PID 1 (aucun processus zombie)
