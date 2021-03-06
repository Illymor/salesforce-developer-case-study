# Salesforce Developer Case Study
Sommaire
* [Introduction](https://github.com/Illymor/salesforce-developer-case-study#introduction)
* [Conception](https://github.com/Illymor/salesforce-developer-case-study#conception)
* [Installation](https://github.com/Illymor/salesforce-developer-case-study#installation)
* [Améliorations & version future](https://github.com/Illymor/salesforce-developer-case-study#am%C3%A9liorations--version-future)


## Introduction
Les élements suivants ont été développés : 
* création d'un composant affichant la météo sur la page d'un compte (selon le code postal et la ville du compte) ou en page d'accueil (selon le géolocalisation de l'utilisateur connecté)
* le composant affiche la température (en degré Celsius), la vitesse du vent (en Noeuds), l'humidité (en %) et un icône décrivant la tendance actuelle (soleil, pluie, nuage, brouillard ou neige)
* un bouton permet l'envoi du bulletin météo aux contacts liés au compte (et possédant un email valide) ou à l'utilisateur connecté, selon le contexte d'utilisation du composant
* lors de l'envoi de l'email, la date d'envoi est mise à jour sur le compte ou sur l'utilisateur, selon le contexte d'utilisation du composant (champ "Last Weather Report Send Date")

Sur la page d'un compte, le composant utilise la ville (BillingCity) et le code postal (BillingPostalCode) afin de déterminer la géolocalisation exacte (latitude et longitude) du compte, la ville seule ne suffisant pas via l'API GeoNames. Si cette adresse est modifiée, la page doit être actualisée manuellement pour que le bulletin météo se mette à jour.

Sur une page d'accueil, la géolocalisation de l'utilisateur connecté est déterminée uniquement si l'utilisateur a autorisé le navigateur a communiqué sa position. Une message d'erreur s'affichera dans le cas contraire (voir ci-dessous).

Des illustrations sont présentes dans le dossier "docs".

Une gestion simple des éventuelles erreurs à été mise en place et affiche un message d'erreur à la place du bulletin météo :
* erreur lors de l'appel de l'API 
* impossibilité de déterminer la géolocalisation de l'utilisateur ou du compte (ville & code postal incorrects par exemple)
* aucun bulletin météo trouvé
* etc.

![schema](https://github.com/Illymor/salesforce-developer-case-study/blob/main/docs/illustration-erreur.png?raw=true)

## Conception
La solution globale repose sur l'enchainement suivant : 

![schema](https://github.com/Illymor/salesforce-developer-case-study/blob/main/docs/schema-solution.png?raw=true)

Le nommage (préfixe) des développements se base sur la règle suivante : 
* AURA : pour les Aura Component
* AW : pour les classes APEX utilisées comme contrôleur d'Aura Component
* AU : pour les classes APEX utilitaires (classe objet, 
* UT : pour les classes APEX de tests unitaires
* CORE : pour les classes APEX transverses (variables globales, fonctions globales réutilisables...)

## Installation

### Lien d'installation du package
L'installation dans une org. Salesforce se fait via l'installation d'un package non géré ("unmanaged package"). 
Le lien d'installation du package est : https://login.salesforce.com/packaging/installPackage.apexp?p0=04t1v0000028Qrr
  
### Actions post-installations
Une fois le package installé, il suffit d'ajouter le composant nommé "Weather Observation" sur la page Lightning d'un compte et/ou sur une page d'accueil.
Le rapport météo se chargera automatiquement après un court délai.

![schema](https://github.com/Illymor/salesforce-developer-case-study/blob/main/docs/illustration-installation.png?raw=true)

Afin de visualiser la date d'envoi du bulletin (sur un compte et/ou un utilisateur), il est possible d'affecter les layouts suivants aux profils souhaités : 
* pour les utilisateurs : SDCS User Layout
* pour les comptes : SDCS Account Layout

## Améliorations & version future
Plusieurs points n'ont pas été traités et pourraient être améliorés dans une v2, notamment : 
* rendre le composant disponible dans une page Web hors Salesforce (Lightning Out)
* utiliser un process standard pour l'envoi des emails (création d'un template d'email, d'alertes emails et envoi par Process Builder), pour faciliter la maintenance
* améliorer/détailler la gestion des erreurs ( aucun contact n'est rattaché au compte pour lequel on envoie l'email, timeout suite à l'appel API ...)
* afficher un spinner de chargement le temps que le bulletin météo se charge
* gérer la langue et les unités (degré Fahrenheit ...)
* améliorer la couverture et les cas de tests autos APEX
* utiliser des Custom Labels pour l'affichage des textes et messages sur le composant
* permettre au composant de se rafraichir automatiquement en cas de changement de l'adresse du compte par exemple
