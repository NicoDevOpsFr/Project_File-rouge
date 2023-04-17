# Installation d'un serveur nginx pour Wordpress

Pour la mise en place d'un serveur web pour le Wordpress, prêt à l'emploi et déployable, il est nécessaire d'utiliser de faire un fichier **docker-compose.yml**. 

Ce fichier sera construit étape par étape afin de fournir l'ensemble des éléments nécessaire à son déploiement.

Dans un premier temps, il faut installer nginx sur la machine distante et procéder à l'arrêt du service pour pouvoir le modifier sans le redémarrer.


```
- name: ==== Mise en place du proxy NGINX ====
  hosts: 
  become: true
```
La ligne ***hosts*** permet de cibler le groupe de machine souhaité, renseigné dans le [fichier inventaire]()

```
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
        src: /home/formation/prometheus/conf.d/grafana.conf
        dest: /etc/nginx/sites-available/grafana.conf
        owner: formation
        group: formation
        mode: 0644

    - name: ___Activation des fichiers de configuration___
      file:
        src: /etc/nginx/sites-available/grafana.conf
        dest: /etc/nginx/sites-enabled/grafana.conf
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