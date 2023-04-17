# Service de visualisation des métriques Grafana

Le service Grafana permet une visualisation de données métriques via des tableaux de bords à partir de base de données où sont récoltées des métriques comme le service Prometheus.

Ce service est déployé via un fichier de configurations Docker-compose.yml en fournissant les informations nécessaires pour déployer un conteneur Grafana à l'aide de Docker.

```yml
version: '3.3'

services:

  grafana:
    image: grafana/grafana
    container_name: grafana
    ports:
      - "3001:3000"
    restart: unless-stopped
    environment:
      - GF_SECURITY_ADMIN_USER=pierre
      - GF_SECURITY_ADMIN_PASSWORD=pierre
    volumes:
      - /home/formation/grafana/volume/:/etc/grafana/provisioning/datasources
```

Ce fichier docker-compose définit un service appelé "grafana" qui exécute la dernière version de prometheus avec la commande : ```grafana/grfana``` directement chargée depuis le Docker Hub. Le service une fois lancé sera nommé "grafana".

Le port 3001 sera le port exposé du conteneur, mappé sur le port 3000 de Grafana.

```Restart:``` configure le redémarrage automatique de Grafana en cas de crash ou d'erreur.

Les variables d'environnements sont définis dans ```environment`` pour exécuter Grafana. Ici, on définit l'utilisateur et le mot de passe administrateur.

Dans ```volumes:``` on spécifie les volumes à monter pour Grafana. Ici, il monte un volume contenant les fichiers de configuration de données sources pour Grafana.