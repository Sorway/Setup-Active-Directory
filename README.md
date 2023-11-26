# Installation et Gestion de l'Active Directory

Ce script PowerShell facilite la configuration et la gestion de l'Active Directory sur un serveur Windows. Il offre plusieurs fonctionnalités pour simplifier la gestion de votre Active Directory.

<p>
    <img src="https://img.shields.io/badge/Powershell-2CA5E0?style=for-the-badge&logo=powershell&logoColor=white" alt="version">
</p>

## Auteur
* [**Sorway**](https://github.com/Sorway)

## Inspiré de:
* [**IT-Connect**](https://www.it-connect.fr/)

## Fonctionnalités

Le script propose les fonctionnalités suivantes :

1. **Configuration par défaut du serveur** : Cette option permet de configurer le serveur avec des paramètres par défaut pour l'Active Directory.
2. **Installer l'Active Directory** : Utilisez cette option pour installer l'Active Directory sur votre serveur.
3. **Créer des Unités Organisationnelles (UO)** : Créez des UO en fonction d'un fichier CSV pour organiser vos objets Active Directory.
4. **Créer des groupes** : Créez des groupes en fonction d'un fichier CSV pour gérer les permissions et l'accès des utilisateurs.
5. **Créer des utilisateurs** : Créez des utilisateurs en fonction d'un fichier CSV pour ajouter rapidement des comptes d'utilisateurs.
6. **Création des profils itinérants** : Cette option vous aide à configurer des profils itinérants pour les utilisateurs.
7. **Mappage du lecteur réseau personnel** : Configurez le mappage automatique du lecteur réseau personnel des utilisateurs.
8. **Forcer le changement du mot de passe** : Active l'option ChangePasswordAtLogon pour tous les utilisateurs, les obligeant à changer leur mot de passe lors de la prochaine connexion.
9. **Quitter** : Quittez le script.

## Utilisation

Pour utiliser ce script, suivez ces étapes simples :

1. Clonez ou téléchargez ce référentiel sur votre ordinateur.
2. Ouvrez PowerShell en tant qu'administrateur.
3. Naviguez vers le répertoire où vous avez enregistré les fichiers du script.
4. Exécutez le script `Setup.ps1`
5. Vous verrez le menu principal avec différentes options. Sélectionnez l'option correspondante à la tâche que vous souhaitez effectuer en entrant le numéro correspondant.
6. Suivez les instructions à l'écran pour configurer et gérer l'Active Directory en fonction de vos besoins.
7. Lorsque vous avez terminé, sélectionnez l'option "Quitter" pour quitter le script.

Assurez-vous de disposer des autorisations appropriées pour effectuer certaines opérations, notamment l'installation de l'Active Directory, qui peut nécessiter des privilèges d'administrateur sur le serveur.

N'hésitez pas à explorer chaque option du menu pour configurer et gérer efficacement votre Active Directory à l'aide de ce script.

## Avertissement

Assurez-vous que l'exécution de scripts PowerShell est autorisée sur votre système. Vous pouvez vérifier cela en exécutant la commande suivante dans PowerShell:

```powershell
Get-ExecutionPolicy
```

Si la politique d'exécution est restreinte, vous devrez peut-être la modifier en exécutant la commande suivante (en tant qu'administrateur):

```powershell
Set-ExecutionPolicy RemoteSigned
```

## Licence
Ce script est distribué sous la licence MIT. Consultez le fichier LICENSE pour plus d'informations.
