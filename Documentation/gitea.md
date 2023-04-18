# Mise en place de Gitea conteneurisé
---

## Introduction

Gitea est un site fork de github ou gitlab permettant d'échanger du code ou des applications complexes.

Pour cette documentation, nous verrons comment l'installer via docker-compose.

## Installation de Gitea avec docker-compose

Le fichier docker-compose.yml pour l'installation de Gitea se définit comme suit:

```yml
version: '3'

services:  
  git:
    image: gitea/gitea:latest
    container_name: git
    environment:
      - USER=<nom_utilisateur_serveur>
      - USER_UID=<UID_utilisateur>
      - USER_GID=<GID_utilisateur>
      - USE_PROXY_PROTOCOL=true
      - DOMAIN=<nom_de_domaine>
      - SSH=<nom_de_domaine>
      - GITEA__database__DB_TYPE=mysql
      - GITEA__database__HOST=<adresse_ip_database>:<port>
      - GITEA__database__USER=<nom_utilisateur_database>
      - GITEA__database__PASSWD=<mot_de_passe_utilisateur_database>
      - GITEA__database__NAME=<nom_database>
      - ROOT_URL=http://<nom_de_domaine>/
      - HTTP_PORT=80
      - SSH_PORT=22
      - SSH_LISTEN_PORT=22
      - HTTP_PORT=3000
      - PROXY_ENABLED=true
      - PROXY_URL=http://<adresse_ip_proxy>:<port>
    restart: always
    volumes:
      - /chemin/d/accès/vers/le/dossier/dans/home/directory/git/git/:/data
      - /chemin/d/accès/vers/le/dossier/dans/home/directory/git/.ssh/:/data/git/.ssh
      - /etc/timezone/:/etc/timezone:ro
      - /etc/localtime/:/etc/localtime:ro
    ports:
      - 8080:80
      - 8443:443
      - 3000:3000
      - "2222:22"
```

Ce fichier docker-compose définit un service appelé "web" qui exécute l'image de `Gitea` en version `latest`.

### Définition des configurations et des options

**Image :** L'image de Gitea utilisée est la dernière version disponible émis dans [Docker Hub](https://hub.docker.com/r/gitea/gitea).

**Volumes :** Les volumes permet de garder de façon persistantes `Gitea`.

**Variables d'environnement :**

- `GITEA__database__DB_TYPE` : 
- `GITEA__database__HOST=<adresse_ip_database>:<port>` : Définition de l'hote de la base données du site Gitea.
- `GITEA__database__USER=<nom_utilisateur_database>` : Définition de l'utilisateur sur la base de données du site Gitea.
- `GITEA__database__PASSWD=<mot_de_passe_utilisateur_database>` : Définition du mot de passe sur la base de données du site Gitea.
- `GITEA__database__NAME=<nom_database>` : Nom de la base de données du site Gitea.

Ces variables d'environnement permettent au conteneur Gitea de se connecter au conteneur MySQL de la base de données qui s'exécute sur le même réseau.
D'autres variables d'environnement sont possibles. Pour cela, il faut se référer à la [documentation](https://docs.gitea.io/en-us/install-with-docker/).

**Ports :** Le conteneur Gitea est configuré pour exposer les ports 3000 ce qui permet au trafic externe d'atteindre le site Gitea.