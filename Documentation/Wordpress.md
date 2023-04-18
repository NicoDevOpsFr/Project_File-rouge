# Mise en place d'un site wordpress conteneurisé
---

## Introduction

WordPress est un outil de site de blogging gratuit et open source et un système de gestion de contenu basé sur PHP et MySQL. Il est possible de l'installer sur un ordinateur, un serveur distant ou un serveur dédié au site web que l'on peut trouver chez OVH par exemple.

Cette documentation montrera comment installer wordpress grâce à `Docker` et plus précisément avec `Docker-Compose`.

## Installation de wordpress avec docker-compose

Le fichier docker-compose.yml pour l'installation de wordpress se définit comme suit:

```yml
version: '3.3'

services:
  web:
    image: wordpress:latest
    container_name: <nom_container>
    volumes:
      - ./wordpress/volumes/:/var/www/html
    environment:
      - WORDPRESS_DB_HOST=<ip_adresse_database>:<port>
      - WORDPRESS_DB_USER=<nom_utilisateur_database>
      - WORDPRESS_DB_PASSWORD=<mot_de_passe_utilisateur_database>
      - WORDPRESS_DB_NAME=<nom_database>
    labels:
      - "prometheus_job=wordpress"
      - "prometheus.path=/metrics"
    ports:
      - 80:80
      - 443:443
```

Ce fichier docker-compose définit un service appelé "web" qui exécute l'image de WordPress en version `latest`.

### Définition des configurations et des options

**Image :** L'image de WordPress utilisée est la dernière version disponible émis dans [Docker Hub](https://hub.docker.com/_/wordpress).

**Volumes :** Les fichiers d'installation de WordPress sont stockés dans le répertoire `./wordpress/volumes/` sur la machine hôte, et seront stockés dans le répertoire `/var/www/html` du conteneur. Cela permet à toutes les modifications apportées dans le conteneur WordPress d'être persistantes.

**Variables d'environnement :**

- `WORDPRESS_DB_HOST=<ip_adresse_database>:<port>` : Définition de l'hote de la base données du site wordpress.
- `WORDPRESS_DB_USER=<nom_utilisateur_database>` : Définition de l'utilisateur sur la base de données du site wordpress.
- `WORDPRESS_DB_PASSWORD=<mot_de_passe_utilisateur_database>` : Définition du mot de passe sur la base de données du site wordpress.
- `WORDPRESS_DB_NAME=<nom_database>` : Nom de la base de données du site wordpress.

Ces variables d'environnement permettent au conteneur WordPress de se connecter au conteneur MySQL de la base de données qui s'exécute sur le même réseau.
D'autres variables d'environnement sont possibles. Pour cela, il faut se référer à l [adocumentation](https://hub.docker.com/_/wordpress).

**Labels :** Deux labels, ou étiquettes en français sont ajoutées au conteneur, qui peuvent être utilisées par un système de surveillance comme Prometheus pour suivre et extraire des métriques à partir du conteneur. 

L'étiquette `prometheus_job=wordpress` identifie ce conteneur en tant que service WordPress, et l'étiquette `"prometheus.path=/metrics"` spécifie le chemin où le conteneur expose ses métriques.

**Ports :** Le conteneur WordPress est configuré pour exposer les ports 80 et 443, ce qui permet au trafic externe d'atteindre le site WordPress. Le **port 80** est le port HTTP standard, tandis que le **port 443** est le port HTTPS standard.
