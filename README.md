# Inception
🐳 Inception - Présentation du Projet
📚 Résumé
Le projet Inception a pour objectif de mettre en place une infrastructure web conteneurisée à l’aide de Docker et Docker Compose, dans une machine virtuelle personnelle.
L’ensemble des services sont isolés dans des conteneurs dédiés, construits manuellement à partir de Dockerfiles personnalisés, sans utiliser d’images toutes faites.
Le projet repose sur la mise en production d’un site WordPress sécurisé, associé à une base de données, le tout protégé par TLSv1.2 ou TLSv1.3 via NGINX.
⚙️ Exécution
Démarrage de l’infrastructure :
make
Arrêt des services :
make down
Nettoyage des volumes :
make fclean
📐 Contraintes techniques
Tous les services doivent tourner dans des conteneurs Docker distincts.
Les images sont basées sur Debian ou Alpine, dernières versions stables (hors latest).
Un Makefile déclenche la construction de l’infrastructure.
Utilisation exclusive de docker-compose (pas de links: ni de network: host).
Communication via réseau docker personnalisé.
Les services doivent redémarrer automatiquement en cas de crash.
Tous les mots de passe doivent être stockés dans un fichier .env ou via Docker secrets.
🧱 Services obligatoires
NGINX : Point d’entrée unique, assure la redirection HTTPS (port 443) vers WordPress. Certificats SSL générés automatiquement.
WordPress : CMS déployé avec php-fpm, sans serveur web intégré.
MariaDB : Base de données utilisée par WordPress. Deux utilisateurs configurés, dont un administrateur (sans le mot "admin").
Deux volumes Docker sont requis :
 - Volume pour les données WordPress
 - Volume pour les données MariaDB
📄 Exemple de structure attendue
srcs/
  ├─ requirements/
  │   ├─ nginx/
  │   ├─ wordpress/
  │   ├─ mariadb/
  │   └─ bonus/
  ├─ .env
  └─ docker-compose.yml
secrets/
  ├─ credentials.txt
  ├─ db_password.txt
  └─ db_root_password.txt
Makefile
🌐 Configuration réseau et domaine
Le nom de domaine local est basé sur le login : login.42.fr
Ce domaine pointe vers l’IP locale de la machine virtuelle
Accès sécurisé via HTTPS uniquement (port 443)
✅ Fonctionnalités requises
Lancement automatique de tous les services via make
Tous les services communiquent sur un réseau Docker privé
Aucun mot de passe en clair dans les Dockerfiles
Respect strict des bonnes pratiques Docker (pas de tail -f, sleep infinity, etc.)
🧪 Tests de validation
curl -k https://login.42.fr : Vérifier l’accès au site WordPress via HTTPS
docker volume ls : Vérifier la présence des volumes de données
docker network inspect : Vérifier la bonne configuration réseau
docker ps : Vérifier que tous les conteneurs sont en cours d'exécution
🌟 Bonus
Redis : Système de cache avancé pour WordPress
FTP : Serveur FTP pointant vers le volume WordPress
Site statique : Hébergé sur un conteneur distinct (pas de PHP autorisé)
Adminer : Interface web légère pour administrer la base de données
Service libre : Exemple : Portainer (interface graphique Docker) ou Whoami
🏗️ Étapes recommandées
Créer l’arborescence du projet (srcs, secrets, Makefile, etc.)
Configurer chaque service avec un Dockerfile dédié
Mettre en place les volumes persistants
Générer les certificats SSL automatiquement
Configurer .env et le docker-compose.yml
Tester le fonctionnement complet via HTTPS
Ajouter les bonus et vérifier leur accessibilité
🧠 Recommandations
Respecter strictement la séparation des services
Utiliser COPY, RUN, CMD dans les Dockerfiles avec cohérence
Ne jamais exposer d’informations sensibles dans Git
Prévoir des logs exploitables en cas de crash
