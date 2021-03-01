# Salesforce Developer Case Study

## Introduction
Les élements suivants ont été développés : 
* création d'un composant affichant la météo sur la page d'un compte (selon le code postal et la ville du compte) ou en page d'accueil (selon le géolocalisation de l'utilisateur connecté)
* le composant affiche la température (en degré Celcius), la vitesse du vent (en Noeuds), l'humidité (en %) et un icône décrivant la tendance actuelle (soleil, pluie, nuage, brouillard ou neige)
* un bouton permet l'envoi du bulletin météo aux contacts liés au compte (et possédant un email valide) ou à l'utilisateur connecté, selon le contexte d'utilisateur du composant
* lors de l'envoi de l'email, la date d'envoi est mise à jour sur le compte ou sur l'utilisateur, selon le contexte d'utilisateur du composant (champ "Last Weather Report Send Date")

## Conception
La solution globale repose sur l'enchainement suivant : 
![schema](https://github.com/Illymor/salesforce-developer-case-study/blob/main/docs/schema-solution.png?raw=true)

## Installation

### lien d'installation du package
L'installation dans une org. Salesforce se fait via l'installation d'un package non géré ("unmanaged package"). Le lien d'installation du package est : 

### actions post-installations
Une fois le package installé, 


## Améliorations & version future

