# SEA21
**14/09/24**
**Fait par ER ROUASSE Ayoub**

## Résumé
Nous avons créé un script bat sur Windows permettant à un administrateur de créer des machines virtuelles automatiquement, de pouvoir choisir leur nom et leurs caractéristiques. Le script est également capable de les supprimer, de les démarrer, de les lister et de les arrêter.

### Version 1
La première version du script permet de créer une machine virtuelle, mais ne dispose pas d'arguments permettant de personnaliser l'installation. Il est important de noter que si une machine virtuelle existante possède le même nom, la machine existante sera supprimée et la nouvelle machine pourra être créée.

### Version 2
La deuxième version est bien plus complète que la précédente. Elle propose cinq choix de fonctionnalités pour le programme. Il est possible de:
- '[L]' Lister l'ensemble des machines virtuelles
- '[C]' Créer une nouvelle machine en spécifiant des arguments tels que le nom, la RAM et la taille du disque
- '[S]' Supprimer une machine en utilisant son nom
- '[D]' Démarrer une machine 
- '[A]' Arrêter une machine

### Version 3
Dans cette version du programme, il est possible d'ajouter des métadonnées à une machine virtuelle. Ces métadonnées peuvent être lues à l'aide de la commande '[L]' telle qu'elle est présentée dans la version précédente. C'est dans cette partie que nous avons rencontré le plus de difficultés à propos de comment afficher les métadonnées à la suite du echo.


### Version 4

Dans cette version du programme, l'idée est de créer une version qui pourrait aider à gagner plus de temps. Si une seule machine doit être créée, le programme fonctionne toujours de la même façon mais pour plusieur machines ce processus reste lent. C'est pour ça que la nouvelle version de ce programme permet de créer, démarer, arreter, et supprimer, plusieur VM à la fois. 

Pour ça,  l'utilisateur va créer plusieur VM à partir d'un nom de base, qu'on incrementera pour créer une suite de VM avec le même nom en suffix. Pour démarer, arreter, et supprimer, on doit utiliser cette base comme nom de VM.

La deuxième version est bien plus complète que la précédente. Elle propose cinq choix de fonctionnalités pour le programme. Il est possible de:
- '[L]' Lister l'ensemble des machines virtuelles
- '[C]' Créer une nouvelle machine en spécifiant des arguments tels que le nom, la RAM et la taille du disque
- '[S]' Supprimer une machine en utilisant son nom
- '[D]' Démarrer une machine 
- '[A]' Arrêter une machine

- '[SC]' Créer plusieurs machine avec le nom du suffix, le nombre de machine, la taille de la RAM, et la taille du sique
- '[SD]' Démarrer plusieurs machine avec le nom du suffix et l'incrementation de la plus grande machine
- '[SA]' Arrêter plusieurs machine avec le nom du suffix et l'incrementation de la plus grande machine
- '[SS]' Supprimer plusieurs machine avec le nom du suffix et l'incrementation de la plus grande machine

Les fichier .vdi sont enregistrer dans un sous dossier disk.

### Version 5

Creation d'une interface graphique basique avec python. Cette interface permet de réaliser toute les commandes "super". Elle donne une option suplémentaire pour l'administrateur réseau en charge de la gestion des VM.

Les limites que recontre le programe sont:
Les machines n'ont pas d'OS mais le PXE est activé à leur création. Il faudrait donc configurer un PXE sur VirtuaBox pour intaller les OS en même temps que la cration des VM.