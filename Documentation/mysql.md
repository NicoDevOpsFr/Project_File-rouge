# Service de base de données MySQL

---

## Introduction

La base de données MySQL est un outil open source pour stocker les données d'un site web par exemple. 

## Installation de MySQL

MySQL sera lancée grâce à docker-compose.yml, définit comme suit:

```yml
version: '3'

services:
  db:
    image: mysql:latest
    container_name: database
    environment:
      - MYSQL_ROOT_PASSWORD=<mot_de_passe_root>
    volumes:
      - /chemin/ou/se/trouve/le/fichier/databases.sql:/docker-entrypoint-initdb.d/databases.sql
      - db_data:/var/lib/mysql
    ports:
      - 3306:3306

volumes:
  dbdata:
```

Ce fichier docker-compose définit un service appelé "db" qui exécute la version `latest` de MySQL avec la commande : `mysql:latest`. L'image est récupéré sur le [docker hub](https://hub.docker.com/_/mysql).
Le service une fois lancé sera nommé "database".

**La variable d'environnement** :

- `MYSQL_ROOT_PASSWORD` définit le mot de passe root pour MySQL.

Les volumes suivants sont définis pour stocker les données du conteneur :

- `/chemin/ou/se/trouve/le/fichier/databases.sql:/docker-entrypoint-initdb.d/databases.sql` : Ce volume contient un fichier SQL pour initialiser la base de données.
- `db_data:/var/lib/mysql` : Ce volume permet de faire persister les données de la base de données MySQL.
  
Le port 3306 permet au serveur à distance de communiquer avec la base de donnée.

## Fichier pour créer des bases de données facilement dans le conteneur MySQL

Le fichier `databases.sql` permet de créer facilement des bases de données et des utilisateurs dans le conteneur `MySQL`.

```sql
CREATE DATABASE IF NOT EXISTS `<database_1>`;
CREATE DATABASE IF NOT EXISTS `<database_2>`;


CREATE USER '<utilisateur_1>'@'<localhost_ou_adresse_ip_1>' IDENTIFIED BY '<mot_de_passe_utilisateur_1>';
GRANT ALL PRIVILEGES ON <database_1>.* TO '<utilisateur_1>'@'<localhost_ou_adresse_ip_1>';
FLUSH PRIVILEGES;

CREATE USER '<utilisateur_2>'@'<localhost_ou_adresse_ip_2>' IDENTIFIED BY '<mot_de_passe_utilisateur_2>';
GRANT ALL PRIVILEGES ON <database_2>.* TO '<utilisateur_2>'@'<localhost_ou_adresse_ip_2>';
FLUSH PRIVILEGES;
```

