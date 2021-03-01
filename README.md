# Salesforce Developer Case Study

## Introduction
Les élements suivants ont été développés : 
* création d'un composant affichant la météo sur la page d'un compte (selon le code postal et la ville du compte) ou en page d'accueil (selon le géolocalisation de l'utilisateur connecté)
* le composant affiche la température (en degré Celcius), la vitesse du vent (en Noeuds), l'humidité (en %) et un icône décrivant la tendance actuelle (soleil, pluie, nuage, brouillard ou neige)
* un bouton permet l'envoi du bulletin météo aux contacts liés au compte (et possédant un email valide) ou à l'utilisateur connecté, selon le contexte d'utilisateur du composant
* lors de l'envoi de l'email, la date d'envoi est mise à jour sur le compte ou sur l'utilisateur, selon le contexte d'utilisateur du composant (champ "Last Weather Report Send Date")

Une gestion simple des éventuelles erreurs à été mise en place et affiche un message d'erreur à la place du bulletin météo :
* erreur lors de l'appel de l'API 
* impossibilité de déterminer la géolocalisation de l'utilisateur ou du compte (ville & code postal incorrects par exemple)
* aucun bulletin météo trouvé
* etc.

![schema](https://github.com/Illymor/salesforce-developer-case-study/blob/main/docs/illustration-erreur.png?raw=true)

## Conception
La solution globale repose sur l'enchainement suivant : 

![schema](https://github.com/Illymor/salesforce-developer-case-study/blob/main/docs/schema-solution.png?raw=true)

## Installation

### Lien d'installation du package
L'installation dans une org. Salesforce se fait via l'installation d'un package non géré ("unmanaged package"). Le lien d'installation du package est : 

### Actions post-installations
Une fois le package installé, il suffit d'ajouter le composant nommé "Weather Observation" sur la page Lightning d'un compte et/ou sur une page d'accueil.
Le rapport météo se chargera automatiquement 

## Améliorations & version future

