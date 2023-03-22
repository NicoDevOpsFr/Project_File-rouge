# <U>**Installation de Docker et Docker-Compose sur Debian11 (BullsEye)**</U>


<br/> <br>

## <U>**I. Installation de Docker**</U>

### <U>I.1. Mise à jour de Debian</U>

```bash
sudo apt-get update
```

### <U>I.2. Vérification si curl est installé</U>

```bash
curl -V
```

Si curl ne marche pas, il faut l'installer avec la commande suivante :

```bash
sudo apt-get install curl
```

### <U>I.3. Installation de Docker</U>

```bash
curl -fsSL https://get.docker.com/ | sh
```

### <U>I.4. Ajout de l'utilisateur au groupe Docker</U>

```bash
sudo usermod -aG docker <username>
```

### <U>I.5. Mise en route et vérification de fonctionnement de Docker</U>

```bash
docker run hello-world
```

```bash
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
...
Hello from Docker.
This message shows that your installation appears to be working correctly.
...
```

>Si le message plus haut n'est pas obtenu, il faut peut-être redémarrer Docker :
>
>```bash
>sudo systemctl restart docker
>```

<br/> <br>

---

## <U>**II. Installation de Docker-compose**</U>

### <U>II.1 Installation de Docker-Compose</U>

```bash
sudo curl -L https://github.com/docker/compose/releases/download/1.25.3/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
```

### <U>II.2 Ajout du droit d'exéction au fichier docker-compose</U>

```bash
sudo chmod +x /usr/local/bin/docker-compose
```

### <U>II.3 Vérification de la bonne installation et de la version de docker-compose</U>

```bash
docker-compose --version
```

On doit obtenir :

```bash
Output
docker-compose version 1.25.3, build d4d1b42b
```

<br/> <br>

---

## <U>**Bibliographie**</U>

[Installtion de Docker - 21/03/2022](https://upcloud.com/resources/tutorials/wordpress-with-docker)

[Installtion de docker-compose - 21/03/2022](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-debian-10-fr)