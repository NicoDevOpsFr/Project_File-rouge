# Installation de WordPress avec Docker et Docker-Compose

<Br> </Br>

## <U>**I. WordPress avec Docker**</U>

### <U>I.1 Installation du container MariaDB</U>

Il faut créer un dossier pour wordpress dans le dossier `home` :

```bash
mkdir ~/wordpress && cd ~/wordpress
```

Il faut créer la base de donnée sans oublier de changer le mot de passe `password` :

```bash
docker run -e MYSQL_ROOT_PASSWORD=<password> -e MYSQL_DATABASE=wordpress --name wordpressdb -v "$PWD/database":/var/lib/mysql -d mariadb:latest
```

>–name wordpressdb – Nom du container.  
>-v “$PWD/database”:/var/lib/mysql – Créé un dossier de données lié avec le stockage du container pour s'assurer de la perssitance des donénes.  
>-d – Indique à Docker d'exécuter le conteneur dans le démon.  
>mariadb:latest – Indique quoi installer et quelle version.

On doit obtenir :

```bash
...
Status: Downloaded newer image for mariadb:latest
23df0ec2e48beb1fb8704ba612e9eb083f4193ecceb11102bc91232955cccc54
```

On fait la commande suivante pour voir les images en cours :

```bash
docker ps
```

```bash
CONTAINER ID IMAGE          COMMAND                CREATED        STATUS        PORTS      NAMES
14649c5b7e9a mariadb:latest "/docker-entrypoint.s" 12 seconds ago Up 12 seconds 3306/tcp   wordpressdb
```

### <U>I.2 Installation de WordPress</U>

On télécharge l'image officiel de WordPress se trouvant dans Docker :

```bash
docker pull wordpress
```

Le container de WordPress prend les variables d'environnement et les paramètres de Docker :

```bash
docker run -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=<password> --name wordpress --link wordpressdb:mysql -p 80:80 -v "$PWD/html":/var/www/html -d wordpress
```

>-e WORDPRESS_DB_PASSWORD= Mettre le même mot de passe que la base de donnée.
>–name wordpress – Donner le nom du container.  
>–link wordpressdb:mysql – Fait le lien entre le container WordPress le container MariaDB pour qu'il puisse intéragir.  
>-p 80:80 – Demande à Docker de passer par une connexion `http` de notre server vers le port interne du container `80`.  
>-v “$PWD/html”:/var/www/html – Permet au fichier WordPress d'être accessible à l'extérieur de container. Le fichier de volume restera même si le container est supprimé.  
>-d – Permet au container de tourner en arrière plan  
>wordpress – Prépare Docker à l'installationTells. Utilisation du paquet téléchargé précédemment avec la commande : `docker pull wordpress -command`.

On peut lanver la configuration de Wordpress :  
> http://<public IP>/wp-admin/install.php

### <U>I.3 En cas d'erreur</U>

Il est possible de supprimer le container avec la commande suivante :

```bash
docker rm wordpress
```

Redémarrer le container database pour être sûr que le service est bien sur le port 80 :

```bash
sudo systemctl restart docker
docjer start wordpressdb
```

---

<Br> </Br>

## <U>**II. Installation de WordPress avec docker-compose**</u>

<Br></Br>

---

## <U>**Bibliographie**</U>

[Installation wordpress via docker - 21/03/2023](https://upcloud.com/resources/tutorials/wordpress-with-docker)