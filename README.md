**Groupe :** Groupe 2 SAE S2.03

**Année :** BUT 1

**IUT Le Havre - Cours GIT/Docker**

### Compte-rendu S2.03 Introduction GIT

# TP1 Fonctionnement de base de Docker

## Introduction
Dans cette section, nous allons nous familiariser avec le fonctionnement de base de Docker et apprendre comment interagir avec les différentes images et conteneurs via la ligne de commande. La syntaxe de base d’une commande commence toujours par `docker` et est suivie de la commande que nous voulons utiliser :

$ docker <commande> <options | parametres>


## 1. Résumé des commandes de base pour les conteneurs
Vous trouverez ci-dessous un résumé de certaines commandes. Pour plus d’informations, vous pouvez visiter la page : [docker cheatsheet](https://docker.com).

- `$ docker info` : Affiche les informations du système Docker.
- `$ docker version` : Affiche la version de Docker.
- `$ docker run <image>` : Crée un conteneur à partir d'une image. Si l'image n'est pas présente localement, elle est téléchargée automatiquement.
- `$ docker run -d -p 82:80 nginx` : Crée un conteneur en mode détaché et le rend accessible depuis le port 82.
- `$ docker stop|start <id>` : Arrêter ou démarrer un conteneur.
- `$ docker ps -a` : Liste tous les conteneurs (actifs et arrêtés).
- `$ docker ps -q` : Liste les identifiants des conteneurs actifs.
- `$ docker stop $(docker ps -q)` : Arrête tous les conteneurs renvoyés par la sous-commande `docker ps -q`.
- `$ docker rm <id>` : Supprime un conteneur (si il est arrêté).
- `$ docker rm -f <id>` : Force la suppression d’un conteneur même s’il est en cours d’exécution.
- `$ docker exec -it <id> bash` : Ouvre un terminal interactif dans le conteneur.
- `$ docker exec <id> ls` : Exécute la commande `ls` sur le conteneur pour afficher ses fichiers.
- `$ docker cp <id>:<fichier> .` : Copie un fichier du conteneur vers le système de fichiers local.

## 2. Premières notions de Docker
Pour vérifier que Docker est installé sur votre machine (ou sur une machine de l’IUT), utilisez la commande suivante :

$ docker --version


Cela devrait afficher la version actuellement installée du moteur Docker. Par exemple :

Docker version 20.10.7, build f0df350


### Lancer votre premier conteneur

L’objectif de Docker est de développer, déployer et exécuter des applications dans un environnement isolé appelé conteneur. Pour lancer votre premier conteneur avec l’image `hello-world`, exécutez :

$ docker run hello-world


Le message suivant devrait apparaître :

Unable to find image 'hello-world:latest' locally latest: Pulling from library/hello-world 2db29710123e: Pull complete Digest: sha256:10d7d58d5ebd2a652f4d93fdd86da8f265f5318c6a73cc5b6a9798ff6d2b2e67 Status: Downloaded newer image for hello-world:latest

Hello from Docker!


Cette image `hello-world` sert à tester que Docker est bien installé. Elle affiche un message simple de bienvenue tout en montrant les étapes d'exécution internes de Docker.

### 2.1. Image Docker vs conteneur Docker
- **Image Docker** : C'est un fichier immuable qui contient le code source, les bibliothèques, les dépendances et autres fichiers nécessaires à l'exécution d'une application. Les images sont des modèles qui ne peuvent pas être modifiés directement.
- **Conteneur Docker** : Un conteneur est une instance en cours d'exécution d'une image. Il permet d'ajouter des modifications et des fichiers au-dessus de l'image immuable.

### Commandes Docker pour visualiser les conteneurs et images
- `$ docker ps` : Affiche les conteneurs actifs.
- `$ docker ps -a` : Affiche tous les conteneurs, actifs ou arrêtés.
- `$ docker images` : Affiche toutes les images locales.

### Supprimer des conteneurs et des images
Attention ! Si vous travaillez sur les machines de l'IUT, ne supprimez pas les conteneurs ou les images des autres utilisateurs.

- **Arrêter tous les conteneurs** :  

docker stop $(docker ps -qa)

- **Supprimer tous les conteneurs** :  

docker rm $(docker ps -qa)

- **Supprimer toutes les images Docker** :  

docker rmi $(docker images -q)


### 2.2. Images Docker les plus populaires
Vous pouvez trouver les images Docker les plus populaires sur [Docker Hub](https://hub.docker.com/explore/). Certaines images populaires incluent `alpine` et `httpd`.

## 3. Interactions avec les conteneurs Docker
Dans cette section, nous utiliserons les images `alpine` et `httpd`.

### 3.1. Conteneur en mode interactif
Lancez un conteneur avec l’image `alpine` :

$ docker run alpine ls


Cette commande exécute `ls` dans le conteneur Alpine. Cependant, pour une interaction plus poussée, vous pouvez lancer un conteneur en mode interactif avec l’option `-it` :

$ docker run -it alpine


Cela vous donne un terminal interactif dans le conteneur. Pour quitter le conteneur, utilisez la commande `exit`.

### 3.2. Ports, volumes et copie de fichiers
Les conteneurs sont isolés. Pour rendre des services accessibles ou partager des fichiers, vous devez exposer des ports ou monter des volumes.

#### 3.2.1. Exposer des ports
Lancez un conteneur `httpd` sans exposer les ports :

$ docker run httpd


Cela lance un serveur Apache dans le conteneur, mais il n’est pas accessible depuis votre machine.

Pour exposer le port 80 du conteneur à un port de votre machine, utilisez :

$ docker run --name httpd-<votre nom> -d -p <port hôte>:80 httpd


Cela exécute le serveur Apache en mode détaché et mappe le port 80 du conteneur au port spécifié de l’hôte. Ouvrez un navigateur et entrez `localhost:<port>` pour vérifier que le service est actif.

#### 3.2.2. Copier des fichiers dans un conteneur
La commande `docker cp` permet de copier des fichiers entre votre système hôte et le conteneur.

Exemple pour copier un fichier `index.html` du système hôte vers un conteneur :

docker cp <fichier> <id du conteneur>:/usr/local/apache2/htdocs/index.html


Cela copie le fichier vers le répertoire approprié du conteneur Apache.

#### 3.2.3. Volumes
Les volumes permettent de partager des répertoires entre l’hôte et le conteneur. Pour créer un volume, exécutez :

$ docker run --name httpd-<votre nom> -d -p <port hôte>:80 -v $(pwd):/usr/local/apache2/htdocs httpd


Cela permet de monter le répertoire local `$(pwd)` vers le répertoire `htdocs` du conteneur, permettant ainsi un partage dynamique des fichiers.

## Exercice de découverte
1. Lancez un conteneur `httpd` nommé `httpd-<votre nom>` avec l’option `--name`.
2. Mappez le port 80 du conteneur vers un port de votre machine et exécutez-le en mode détaché.
3. Modifiez le fichier `index.html` local, puis vérifiez dans votre navigateur que les changements sont visibles.

N’oubliez pas de stopper le conteneur une fois l’exercice terminé avec la commande :

docker stop httpd-<votre nom>


# TP2 Dockerfile pour la création d’images

## Introduction
Jusqu’à présent, nous avons appris à utiliser les images disponibles sur hub.docker.com pour lancer des conteneurs dans notre environnement. Cependant, une question se pose : y a-t-il une image pour chaque type de service que l’on peut imaginer ? La réponse est claire : non.

À partir d’une image existante, le fichier `Dockerfile` nous permet, entre autres, d’installer de nouveaux packages, de configurer la visibilité des ports et de définir le programme en cours d’exécution par défaut. En d’autres termes, Dockerfile nous permet de générer n’importe quel type d’image avec les caractéristiques que nous voulons.

## 1. Introduction à Dockerfile

Les paramètres et les instructions d’un Dockerfile sont nombreux, nous n’allons donc pas tous les voir. Au lieu de cela, nous allons travailler avec des exercices avec un ordre croissant de complexité qui nous permettront de découvrir progressivement comment créer notre propre Dockerfile. Si nous avons besoin de connaître de nouvelles fonctionnalités ou la syntaxe d’une instruction spécifique, vous pouvez consulter ce manuel de référence de Dockerfile.

### 1.1. Notre premier Dockerfile

Pour construire une image, un fichier Dockerfile est créé avec les instructions qui précisent ce qui va aller dans l’environnement, à l’intérieur du conteneur (réseaux, volumes, ports vers l’extérieur, fichiers qui sont inclus). Un fichier Dockerfile indique comment et avec quoi construire l’image.

Voyons un exemple simple de fichier Dockerfile :

# dockerfile #
# Utiliser l'image httpd officielle comme image parent
FROM httpd

# Copier le répertoire html du répertoire courant vers le répertoire de l'image /usr/.../htdocs
COPY ./html/ /usr/local/apache2/htdocs/

# Exécuter la commande echo sur le conteneur 
# (il peut s'agir de n'importe quelle autre commande)
RUN echo 'Hello world! Voici notre premier dockerfile'

# Rendre le port 80 accessible au monde en dehors de ce conteneur
EXPOSE 80

1.1.1. Structure de répertoires

Dans cette section, nous allons apprendre à créer une structure de répertoires pour placer notre fichier Dockerfile :

    Accédez à un répertoire de votre choix.

    Créez un nouveau répertoire qui hébergera le Dockerfile. Nous pouvons l’appeler premierDockerfile :

mkdir premierDockerfile

Accédez au répertoire :

cd premierDockerfile

Dans le répertoire actuel, créez un fichier appelé Dockerfile et copiez le code du Dockerfile ci-dessus.

Si nous voyons le code du Dockerfile, il y a une ligne dans laquelle nous indiquons que nous voulons copier le répertoire html de l’hôte dans le répertoire /usr/local/apache2/htdocs/ du conteneur. Nous devons donc maintenant créer ce répertoire html :

mkdir html

Dans le répertoire html, créez un fichier index.html avec le contenu HTML de votre choix.

Revenons au répertoire premierDockerfile pour que la commande tree affiche cette arborescence :

    $ tree
    .
    ├── Dockerfile
    └── html
        └── index.html

Félicitations!! Nous avons terminé la structure de répertoires.
1.1.2. Créer l’image et lancer le conteneur

Pour construire l’image décrite dans le Dockerfile, nous utiliserons la commande suivante :

docker build -t <choisir-un-nom-pour-l'image> .

Voici la signification des différents paramètres :

    docker build : commande qui nous permet d’indiquer que nous allons construire une nouvelle image.

    -t <choisir-un-nom-pour-l'image> : indique le nom de l’image que nous allons construire. Essayez d’être bref mais descriptif. Un exemple : <votre nom>-httpd-img.

    . : le dernier point indique le répertoire où se trouve le fichier Dockerfile (dans notre cas, c’est le répertoire courant).

Ensuite, lancez le serveur web :

docker run --name <nom du conteneur de votre choix> -d -p <port hôte>:80 <nom-de-l'image-choisie>

Vérifiez que l’application est en cours d’exécution. Pour ce faire, ouvrez un navigateur et tapez localhost:<port hôte>.

Vérifiez que le fichier index.html affiché est celui que vous avez dans le dossier html de l’hôte.

S’il y a quelque chose qui ne fonctionne pas, vous pouvez d’abord vérifier que le conteneur associé à l’image est actif :

docker ps

La sortie de docker ps doit être similaire à :

CONTAINER ID   IMAGE          COMMAND              CREATED          STATUS          PORTS                                   NAMES
b8f8f406b03c   httpd-juanlu   "httpd-foreground"   30 minutes ago   Up 30 minutes   0.0.0.0:8080->80/tcp, :::8080->80/tcp   quirky_tesla

Finalement, arrêtez le conteneur avec la commande suivante (les derniers chiffres sont le code de hachage affiché par docker ps) :

docker stop b8f8f406b03





## Conclusion
Vous avez appris les concepts de base de Docker, comment manipuler des contene

