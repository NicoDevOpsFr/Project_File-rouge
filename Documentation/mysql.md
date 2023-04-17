# Service de base de données MySQL

La base de données MySQL est un outil open source pour stocker les données d'un site web par exemple. L'instance MySQL sera lancée via un fichier docker-compose.yml, définit comme suit:

```yml
version: '3'

services:
  db:
    image: mysql:latest
    container_name: database
    environment:
      - MYSQL_ROOT_PASSWORD=pierre1234

    command: mysqld --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    volumes:
      - /home/formation/database_users/databases.sql:/docker-entrypoint-initdb.d/databases.sql
      - /home/formation/volume:/var/lib/mysql
    ports:
      - 3306:3306
      - 9100:9100

```

Ce fichier docker-compose définit un service appelé "db" qui exécute la dernière version de MySQL avec la commande : ```mysql:latest```. Le service une fois lancé sera nommé "database".

**La variable d'environnement** :

- ```MYSQL_ROOT_PASSWORD``` définit le mot de passe root pour MySQL.
- ```mysqld --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci``` est utilisée pour spécifier le jeu de caractères et la collation du serveur MySQL.

Les volumes suivants sont définis pour stocker les données du conteneur :

- ```/home/formation/database_users/databases.sql:/docker-entrypoint-initdb.d/databases.sql``` : Ce volume contient un fichier SQL pour initialiser la base de données.
- ```/home/formation/volume:/var/lib/mysql``` : Ce volume persiste les données de la base de données MySQL.
  
Les ports 3306 et 9100 sont exposés pour accéder au service MySQL et pour permettre la collecte de données via l'outil **Prometheus**.
