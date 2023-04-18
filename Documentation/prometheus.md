# Service de collecte de métriques Prometheus d'un site wordpress et git

## Le fichier Docker-compose

Prometheus est un système de surveillance et d'alerte open source. Il permet aux administrateurs système de surveiller leurs infrastructures en collectant des métriques à partir de cibles configurées à des intervalles donnés.

Ce service est déployé via un fichier de configurations Docker-compose.yml en fournissant les informations nécessaires pour déployer un conteneur Prometheus à l'aide de Docker.

Le fichier Docker-compose.yml est définit comme suit:

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

Ce fichier docker-compose définit un service appelé "prometheus" qui exécute la dernière version de prometheus avec la commande : ```prom/prometheus:latest```. Le service une fois lancé sera nommé "prometheus".

Une fois le conteneur est lancé, on exécute la commande ```--config.file=/etc/prometheus/prometheus.yml``` afin d'indiquer le fichier de configuration qui sera utilisé par le service prometheus. Ce fichier doit être créé en amont (voir section fichier de configuration).

Le port exposé par le conteneur est le port 9090.

Dans la section volume, on monte le fichier de configuration ```prometheus.yml``` pour qu'il soit monté sur l'hôte dans le dossier ```/etc/prometheus/```.

## Fichier de configuration prometheus.yml

Pour fonctionné, le service prometheus a besoin d'un fichier de configuration pour la collecte de métriques pour les services WordPress et Git. Ce fichier de configuration doit être inclut dans le volume du conteneur et monté sur l'hôte.

Il est définit comme suit:

```yml
global:
  scrape_interval:     15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'wordpress'
    metrics_path: '/metrics'
    scheme: 'http'
    static_configs:
      - targets: ['217.182.205.43:9100']
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

  - job_name: 'git'
    metrics_path: '/metrics'
    scheme: 'http'
    static_configs:
      - targets: ['141.94.6.208:9100']
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

Dans la section globale, on déclare des variables globales qui s'appliquent à toutes les configurations de récupération de métriques. Ici, la fréquence à laquelle les cibles doivent être récupérées (**scrape_interval**) et la fréquence à laquelle les règles d'évaluation doivent être exécutées (**evaluation_interval**) sont définies

```scrape_configs:``` Cette section définit les configurations de collecte des métriques pour les différents services.

```job_name:``` Le nom du travail de collecte. Ici, on fera deux jeux de collectes de métriques, un pour un site wordpress et un autre pour un service git.

```metrics_path:``` L'URL du chemin d'accès aux métriques exposées par le service. Dans ce fichier, les deux services exposent leurs métriques sur le chemin ```/metrics```.

```scheme:``` Le protocole utilisé pour la collecte des métriques. Ici, le protocole est HTTP.

```static_configs:``` Les cibles de collecte de métriques. Dans ce fichier, chaque job a une cible unique, définie par l'adresse IP et le port du service.

```relabel_configs:``` Les configurations de transformation des étiquettes. Dans ce fichier, il y a plusieurs transformations d'étiquettes effectuées :

```source_labels et target_label:``` Ces configurations remplacent les étiquettes existantes par de nouvelles étiquettes définies.

```regex et replacement:``` Ces configurations remplacent une partie de la valeur d'une étiquette par une nouvelle valeur en utilisant une expression régulière.

Une fois configurer, le service prometheus pour alors récolter les métriques du service wordpress et du service git, qui les exposent sur un port. Ce service peut être couplé à un service de restitutions des métriques pour un affichage sur tableau de bord comme Grafana.

```
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
