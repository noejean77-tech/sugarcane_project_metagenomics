# STAGE TUTORE CIBIG 
## THEME : Caracterisation des entités genetiques associées à la canne a sucre par sequencage ONT 

### ce projet consiste a analysé les données de sequencage ONT de la canne a sucre 
### structure du projet 
```
-scripts : ce dossier contient tous les scripts utilisés pour les differents analyses 
- AnalyseR : ce dossier contient les scripts utliser sur R  
``` 
```
Avant toute chose  les données on été reorganisé dans le but de mieux faciliter les analyse 
pour la reagornisation nous avons utilisé le script reoganized_data.sh pour disposer les fichiers les fichiers par numero de barcodes 
puis nous avons fusionner les fichiers de chaque barcodes a l'aide de la commande cat: 
 cat *.fastq > barcode75_merged.fastq 
```
