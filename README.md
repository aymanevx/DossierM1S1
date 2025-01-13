# Projet outil de recherche de séries similaires.
## Table des matières

- [Description](#description)
- [Démo](#démo)
- [Pré-requis](#pré-requis)
- [Installation](#installation)
- [Explication](#explication)
- [Utilisation](#utilisation)
- [Auteurs](#auteurs)

## Description

Ce projet a pour objectif de permettre à l'utilisateur, à partir d'une série choisie en entrée, d'obtenir trois séries similaires en sortie, en se basant uniquement sur les synopsis et en utilisant la technologie des embeddings (OpenAI).

## Démo 

![Demo-ezgif com-speed](https://github.com/user-attachments/assets/bc397dea-c25f-4a00-9b4b-ebad78ef6f79)




## Pré-requis
1. Un ordinateur sous windows.
2. Installation de Rstudio.
3. Installation des packages dplyr et readr dans R
4. Téléchargement de la base de données toutsurserie (disponible dans ce projet), contenant tous les titres de séries et leurs synopsis, récupérés par web scraping sur Allociné.
5. Téléchargement de la base de données embedingai via ce lien https://drive.google.com/drive/u/0/folders/1yRTKM-bMtnJP__s37f7DxQWPChWRMUHt Cette base contient les embeddings des synopsis, nécessaires pour identifier les séries similaires.
   
## Installation
1. Obtenez le code : Téléchargez le code Outilderecherchedeseriesimilaire pour l'utiliser dans R.
2. Installez les bases de données :
- Téléchargez les fichiers toutsurserie et embedingai depuis https://drive.google.com/drive/u/0/folders/1yRTKM-bMtnJP__s37f7DxQWPChWRMUHt
3. Installez les packages nécessaires :
- Utilisez la commande install.packages dans R pour installer les packages requis.

## Explication
  Les données sur les séries proviennent du site Allociné et ont été collectées par web scraping à l'aide de l'extension SelectorGadget et du package rvest. Le code correspondant est disponible sous le nom "webscraperinfoserie".
  Ensuite, nous avons utilisé un modèle d'embedding d'OpenAI via leur API. Cela nous a permis de créer un fichier contenant les embeddings (représentations vectorielles des mots, permettant au code de comprendre le sens des textes). Le code correspondant est disponible sous le nom "embeddingserie", mais il nécessite une clé API OpenAI pour être exécuté.
  Enfin, en utilisant ces deux fichiers et une série choisie en entrée, le modèle identifie la série sélectionnée, son synopsis correspondant et son embedding. Il calcule ensuite la similarité cosinus avec toutes les autres séries, puis renvoie les trois séries ayant les scores de similarité les plus élevés.

## Utilisation
  Pour utiliser cet outil, placez le fichier Outilderecherchedeseriesimilaire.R dans R et assurez-vous de charger les deux bases de données nécessaires.
  Il suffit ensuite de renseigner le nom d'une série dans la variable input_series et d'exécuter la fonction pour obtenir le résultat correspondant.

## Auteurs 
- Aymane AIBICHI : [@aymanevx](https://github.com/aymanevx)
- Zineb MANAR : [@ZinebMnr](https://github.com/ZinebMnr)
  



