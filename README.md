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

Ce projet est un projet qui a pour objectif de permettre à l'utilisateur, à partir d'une série qui sera choisit en entrée avoir 3 séries similaires en sortie en ce basant uniquement sur les synopsis et en utilisant de l'embedding (Open AI)

## Démo 

![Demo-ezgif com-speed](https://github.com/user-attachments/assets/bc397dea-c25f-4a00-9b4b-ebad78ef6f79)




## Pré-requis
1. Un ordinateur sous windows.
2. Installer Rstudio.
3. Installer le package dplyr et readr sur R
4. Installer la base de données (toutsurserie,disponible dans ce projet) comportant toutes les titres de séries et leurs synopsis (qui ont été scraper sur Allocine)
5. Installer la base de données embedingai sur ce lien https://drive.google.com/drive/u/0/folders/1yRTKM-bMtnJP__s37f7DxQWPChWRMUHt qui contient les embeddings des synopsis et qui vont permettre de trouver les séries similaires.

## Installation
- Prendre le code Outilderecherchedeseriesimilaire pour pouvoir l'utiliser sur R
- Installer les 2 bases, toutsurserie disponible ici et embedingai sur ce lien https://drive.google.com/drive/u/0/folders/1yRTKM-bMtnJP__s37f7DxQWPChWRMUHt
- installer les 2 packages en utilisant install.packages sur R

## Explication
- Les données sur les séries viennent du site Allocine et ont été webscraper grâce à l'extension SelectorGadget et le package rvest. Le code correspondant est mis à disposition sous le nom "websraperinfoserie"
- Ensuite on à utiliser un modèle d'embedding de Open AI en utilisant leurs API, grace a cela on crée le fichier contenant les embeddings (transformer des mots pour que le code comprennent le sens de ces mots). Le code correspondant est mis à disposition sous le nom "embeddingserie" mais nécessite une clé Open AI pour être éxecuté.
- Enfin grâce aux 2 fichiers et à une série choisit en entrée, le modèle trouve la série en entrée son synopsis correspondant et l'embedding, il calcul ensuite la similarité cosinus avec toutes les séries puis nous sort les 3 qui ont la valeurs la plus élevé.

## Utilisation
En mettant le code Outilderecherchedeseriesimilaire.R dans R en appelant les 2 bases de données. Il suffit de mettre le nom d'une série dans input_series et d'éxcuter la fonction pour avoir le résultat corréspondant

## Auteurs 
- Aymane AIBICHI : [@aymanevx](https://github.com/aymanevx)
- Zineb MANAR : [@ZinebMnr](https://github.com/ZinebMnr)
  



