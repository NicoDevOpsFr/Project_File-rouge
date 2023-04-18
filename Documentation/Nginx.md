# Installation d'un serveur nginx pour Wordpress

---

## Introduction

Un proxy est utile pour ne pas exposer l'adresse ip publique de la machine et permettre d'avoir un sous domaine.
Ici, on utilisera un reverse proxy comme nginx qui fera le lien directement entre le serveur web et l'utilisateur.

Dans cette documentation, on détaillera l'installation de `NGINX` via un playbook `Ansible` et la création d'un fichier de configuration.

## Installation de `NGINX` grâce à Ansible

Le fichier `Ansible` sera construit comme suit pour l'installation de NGINX avec les configurations nécessaires.

```
- name: ==== Mise en place du proxy NGINX ====
  hosts: # Groupe définie dans le fichier inventaire.
  become: true
  tasks:
    - name: ___Installation du service NGINX___
      apt:
        name: nginx
        state: present
        update_cache: true

    - name: ___Arrêt du service NGINX___
      service:
        name: nginx
        state: stopped
        enabled: true

    - name: ___Copie des fichiers de configuration___
      copy:
        src: /home/formation/prometheus/conf.d/<nom_application>.conf # Chemin du fichier se trouvant dans la machine local
        dest: /etc/nginx/sites-available/<nom_application>.conf # Chemin du fichier se trouvant dans la machine distante souhaité
        owner: <nom_utilisateur_machine_distante>
        group: <nom_groupe_machine_distante>
        mode: 0644 # Droit du fichier -> 0 pour indique que c'unest un fichier
                                       # 6 Lecture et ecriture pour le propriétaire
                                       # 4 Lecture pour le groupe
                                       # 4 Lecture pour tout le monde

    - name: ___Activation des fichiers de configuration___
      file:
        src: /etc/nginx/sites-available/<nom_application>.conf
        dest: /etc/nginx/sites-enabled/<nom_application>.conf
        state: link

    - name: ___Désactivation de la configuration NGINX par défaut (default.conf)___
      file:
        path: /etc/nginx/sites-enabled/default
        state: absent

    - name: ___Redemarrage du service NGINX___
      service:
        name: nginx
        state: started
```
Vous trouverez les informations du hosts dans le fichier [host.ini]()

## Fichier de configuration de NGINX

Pour permettre à `NGINX` de finctionner, il lui faut renseigner un fichier de configuration. Il est possible d'avoir deux possibilités.
Il est possible de créer au tant de fichiers de configuration que d'application web passant par Nginx.

### Fichier de configuration écoutant sur le port 80

Le fichier de configuration sera comme suit pour <nom_application>.conf :

```
server {
    listen 80;
    server_name <exemple.fr> <www.exemple.fr> <foo.exemple.fr> <www.foo.exemple.fr>;
    location / {
        proxy_read_timeout    90;
        proxy_connect_timeout 90;
        proxy_redirect        off;
        proxy_pass http://<adresse_ip_serveur_web>:<port>;
        proxy_set_header      X-Real-IP $remote_addr;
        proxy_set_header      X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header      Host $host;
    }
}
```
Ce fichier est composé des arguments suivant : 
- `server_name` : Emplacement des domaines et sous domaines
- `proxy_read_timeout` et `proxy_connect_timeout` : Définition du temps maximum que le serveur attendra pour une réponse du serveur cible (en seconde)
- `proxy_redirect` : Définit si Nginx doit modifier les URL de redirection renvoyées par le serveur cible (ici `off`).
- `proxy_pass` : Définit l'URL du serveur cible, qui sera utilisé pour traiter la requête.
- `proxy_set_header` : En-têtes personnalisés pour la requête envoyée au serveur cible. Dans ce fichier, elles ajoutent l'adresse IP réelle du client, l'adresse IP du serveur proxy et le nom de domaine du serveur. Ces en-têtes seront utilisés pour les analyses de logs et la sécurité.

### Fichier de configuration écoutant sur le port 443 pour avoir le `HTTPS`

#### Certificat SSL

Pour l'obtention du `HTTPS` sera utilisé certbot dans le but d'obtenir les certificats ssl. 
Pour l'utilisation de ce robot, il faut passer par son installation. Pour plus d'information, merci de suive la [documentation officielle](https://certbot.eff.org/).

Il sera utilisé la commande suivante :
```
sudo certbot --nginx -d <exemple.fr> -d <www.exemple.fr> -d <foo.exemple.fr> -d <www.foo.exemple.fr>
```

Le fichier de configuration écoutant sur le port 80 sera automatiquement modifié.

#### Fichier de configuration

Après l'utilisation de ce robot, on obtiendra automatiquement le fichier suivant :
```
server {
    server_name <exemple.fr> <www.exemple.fr> <foo.exemple.fr> <www.foo.exemple.fr>;

    location / {
        proxy_read_timeout    90;
        proxy_connect_timeout 90;
        proxy_redirect        off;
        proxy_pass http://<adresse_ip_serveur_web>:3000;
        proxy_set_header      X-Real-IP $remote_addr;
        proxy_set_header      X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header      Host $host;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/<exemple.fr>/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/<exemple.fr>/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}

server {
    if ($host = <exemple.fr>) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    if ($host = <www.exemple.fr>) {
        return 301 https://$host$request_uri;
    } # managed by Certbot
    
        if ($host = <foo.exemple.fr>) {
        return 301 https://$host$request_uri;
    } # managed by Certbot
    
    if ($host = <www.foo.exemple.fr>) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    server_name <exemple.fr> <www.exemple.fr> <foo.exemple.fr> <www.foo.exemple.fr>;
    return 404; # managed by Certbot
}
```

Les fichiers de configurations devront être fait pour chaque application web (`wordpress`, `ghost`, `grafana`, `prometheus`, `gitea`, ...)
