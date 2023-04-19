Role Name
=========

Il existe plusieurs rôles possible pour différentes installation. Il est possible de les utiliser indépendament ou ensemble pour une infrastructure complète.

Requirements
------------

Avant de commencer à utiliser `Ansible`, merci de vérifier que vous ayez correctement télécharger Ansible sur Mac ou Linux en suivant ce lien :  
[Documentation Ansible pour l'installation (En)](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

Role Variables
--------------

Toutes les variables sont dans le fichier `main.yml` se trouvant dans le dossier `vars`. Les variables sont explicites pour tout changement et catégoriser pour une meilleur visualisation.

Dependencies
------------

Dans ces rôles est urilisé Docker et plus précisément Docker-compose. Toutes les images sont dans leur versions `latest` pour garentir les dernières mises à jours. Il ne faut pas oublier de temps en temps de mettre à jour ces images.

Example Playbook
----------------

Voici comment utiliser un rôle pour une installation personnalisée :

    - hosts: servers # Nom du groupe de serveur indiqué dans `host.ini`
      roles:
         - { role: utilisateur.nom_du_role}

License
-------

BSD

Author Information
------------------

Ce ansible a été créé dans le cadre de fin de projet de la formation pour devenir Ingénieur DevOps proposé par AJC Ingénieurie, formation donnée par Semifir pour l'entreprise Sopra Steria.

Les auteurs sont :

- AZAIZA Abdelmalik
- BERRODIER Nicolas
- BIDAUD Pierre
- HOH Damien
