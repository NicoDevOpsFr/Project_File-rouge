# Service de collecte de métriques : Prometheus

---

## Introduction

Prometheus est un logiciel faisant office de base de donée et de récupération de métrique des serveurs utilisés. il est également système de surveillance et d'alerte open source.
Il permet aux administrateurs système de surveiller leurs infrastructures en collectant des métriques à partir de cibles configurées à des intervalles donnés.

Dans cette documentation, nous parlerons de l'installation de Prometheus et l'installation du conteneur permettant de récuprer et envoyer les données des serveurs vers `Prometheus`.

## Installation de Prometheus à l'aide de docker-compose

Ce service est déployé via un fichier de configurations `docker-compose.yml` en fournissant les informations nécessaires pour déployer un conteneur Prometheus.

Le fichier `docker-compose.yml` est définit comme suit:

```yml
version: '3.3'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    command: --config.file=/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
    volumes:
      - /home/formation/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
```

Ce fichier docker-compose définit un service appelé "prometheus" qui exécute la dernière `image` de prometheus avec : `prom/prometheus:latest`. 

Le service une fois lancé sera nommé "prometheus".

Une fois le conteneur est lancé, on exécute la commande `--config.file=/etc/prometheus/prometheus.yml` afin d'indiquer le fichier de configuration qui sera utilisé par le service prometheus. Ce fichier doit être créé en amont (voir le chapite : **Fichier de configuration prometheus.yml**).

Le port exposé par le conteneur est le port 9090.

Dans la section volume, on monte le fichier de configuration `prometheus.yml` pour qu'il soit monté sur l'hôte dans le dossier `/etc/prometheus/`.

## Fichier de configuration prometheus.yml

Pour fonctionné, le service `Prometheus` a besoin d'un fichier de configuration pour la collecte de métriques serveurs cibles. Ce fichier de configuration doit être inclut dans le volume du conteneur et monté sur l'hôte.

Il est définit comme suit:

```yml
global:
  scrape_interval:     15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: '<nom_serveur_1>'
    metrics_path: '/metrics'
    scheme: 'http'
    static_configs:
      - targets: ['<adresse_ip_cible_serveur_1>:9100']
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
      - source_labels: [__meta_docker_compose_service]
        action: replace
        target_label: job
      - source_labels: [__meta_docker_compose_service]
        regex: "(.+)"
        target_label: service
        replacement: "$1"
      - source_labels: [__meta_docker_compose_container_label_com_docker_compose_project]
        target_label: project

  - job_name: '<nom_serveur_2>'
    metrics_path: '/metrics'
    scheme: 'http'
    static_configs:
      - targets: ['<adresse_ip_cible_serveur_2>:9100']
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
      - source_labels: [__meta_docker_compose_service]
        action: replace
        target_label: job
      - source_labels: [__meta_docker_compose_service]
        regex: "(.+)"
        target_label: service
        replacement: "$1"
      - source_labels: [__meta_docker_compose_container_label_com_docker_compose_project]
        target_label: project
```

### Définitions des configurations et des options

Dans la section globale, on déclare des variables globales qui s'appliquent à toutes les configurations de récupération de métriques. Ici, la fréquence à laquelle les cibles doivent être récupérées (**scrape_interval**) et la fréquence à laquelle les règles d'évaluation doivent être exécutées (**evaluation_interval**) sont définies en secondes.

`scrape_configs` : Cette section définit les configurations de collecte des métriques pour les différents services.

`job_name` : Le nom du travail de collecte. Ici, on fera deux jeux de collectes de métriques.

`metrics_path` : L'URL du chemin d'accès aux métriques exposées par le service. Dans ce fichier, les deux services exposent leurs métriques sur le chemin `/metrics`.

`scheme` : Le protocole utilisé pour la collecte des métriques. Ici, le protocole est HTTP.

`static_configs` : Les cibles de collecte de métriques. Dans ce fichier, chaque job a une cible unique, définie par l'adresse IP et le port ouvert grâce au node_exporter.

`relabel_configs` : Cela correspond à la configurations de transformation des étiquettes. Dans ce fichier, il y a plusieurs transformations d'étiquettes effectuées :
- `source_labels` et `target_label` : Ces configurations remplacent les étiquettes existantes par de nouvelles étiquettes définies.
- `regex` et `replacement` : Ces configurations remplacent une partie de la valeur d'une étiquette par une nouvelle valeur en utilisant une expression régulière.

## Configuration des serveurs pour l'envoie des métriques à `Prometheus`

Pour permettre à `Prometheus` de récupérer les métriques de chaque serveur. Pour cela, il faut intégrer le code ci-desous dans un `docker-compose` ou en créé un dans le serveur où il faut récupérer les métriques.

```yml
version: '3.3'

services:
  web:
  ...
  
  db:
  ...
  
  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    ports:
      - 9100:9100
```

Le node-exporter collecte les métriques du système d'exploitation et les expose pour être collectées par un outil de surveillance tel que Prometheus.

L'image utilisée pour le node-exporter dans la version `latest` de **prom/node-exporter** depuis [Docker Hub](https://hub.docker.com/r/prom/node-exporter).

Dans la partie volume, on permet au node-exporter d'accéder aux informations système. Les répertoires `/proc`, `/sys` et `/` sont montés en lecture seule (**/proc:/host/proc:ro, /sys:/host/sys:ro, /:/rootfs:ro**).

Des commandes sont utilisées pour configurer le chemin d'accès aux informations du système dans le node-exporter.

Les commandes `--path.procfs=/host/proc`, `--path.rootfs=/rootfs`, `--path.sysfs=/host/sys` spécifient les chemins pour accéder aux informations du système d'exploitation. La commande `--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)` exclut les points de montage du système de fichiers qui ne doivent pas être surveillés.

Le node-exporter est configuré pour exposer le **port 9100**. Ce port permet à un outil de surveillance, tel que Prometheus, de collecter les métriques exposées par le node-exporter.

Avec ce service maintenant configuré, les données des conteneurs cibles seront exposées afin d'être collecté par `Prometheus`.
Ce service peut être couplé à un service de restitutions des métriques pour un affichage sur tableau de bord comme Grafana.
