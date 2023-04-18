# Service de visualisation des métriques Grafana

---

## Introduction

Le service Grafana permet une visualisation de données métriques via des tableaux de bords. Elles sont fournis à partir de base de données où sont récoltées des métriques comme le service Prometheus.

Dans cette documentation, nous verrons l'installation de `grafana` dans notre cluster et comment faire pour qu'il puisse un lien avec `Prometheus`.

## Installation de `grafana` grâce à docker-compose

Ce service est déployé via un fichier de configurations `docker-compose.yml` en fournissant les informations nécessaires pour déployer un conteneur Grafana :

```yml
version: '3.3'

services:

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3001:3000"
    restart: unless-stopped
    environment:
      - GF_SECURITY_ADMIN_USER=<nom_utilisateur>
      - GF_SECURITY_ADMIN_PASSWORD=<mot-de_passe_utilisateur>
    volumes:
      - <chemein_d_acces_sauvegarde_machine_hote>:/etc/grafana/provisioning/datasources
```

Ce fichier docker-compose définit un service appelé "grafana" qui exécute la version `latest`de grafana : `grafana/grfana:latest` directement chargée depuis le [Docker Hub](https://hub.docker.com/r/grafana/grafana/tags). Le service une fois lancé sera nommé "grafana".

Le port 3001 sera le port exposé du conteneur, mappé sur le port 3000 de Grafana.

`Restart` : configure le redémarrage automatique de Grafana en cas de crash ou d'erreur.

Les variables d'environnements sont définis dans `environment` pour exécuter Grafana. Ici, on définit l'utilisateur et le mot de passe administrateur pour se connecter à grafana via l'interface web.

Dans `volumes` : on spécifie les volumes à monter pour Grafana. Ici, il monte un volume contenant les fichiers de configuration de données sources pour Grafana.

## Relier Grafana à Prometheus

Pour relier `grafana` et `prometheus` il faut aller dans réglages et `Data Sources`.
![Réglage pour "Data Sources"](https://github.com/NicoDevOpsFr/Project_File-rouge/blob/main/Documentation/Images/Re%CC%81glage_prometheus.png)

Il faut ensuite se rendre dans `Prometheus` dans `Time series databases`.
![Time series databases](https://github.com/NicoDevOpsFr/Project_File-rouge/blob/main/Documentation/Images/database_prometheus.png)

Dans la partie URL, il faut renseigner l'adresse ip du serveur `Prometheus`.
![URL Prometheus](https://github.com/NicoDevOpsFr/Project_File-rouge/blob/main/Documentation/Images/url_prometheus.png)

Pour finir, il faut sauvegarder et tester.
![Save & Test](https://github.com/NicoDevOpsFr/Project_File-rouge/blob/main/Documentation/Images/save%26test_prometheus.png)
