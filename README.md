# INF3080-TP3

## I)Ordre d'exécution des Fichiers SQL:


---
### 1. Instructions pour Initialiser la Base de Données

Pour initialiser la base de données avec les données et les contraintes nécessaires, veuillez suivre cet ordre d'exécution :

1. **Creation.sql :** Exécutez ce script pour créer les tables de la base de données et définir leur structure.
  
2. **Triggers.sql :** Ensuite, exécutez ce script pour ajouter les déclencheurs (triggers) associés aux tables pour les opérations spécifiques.
  
3. **Insertion.sql :** Enfin, exécutez ce script pour insérer les données initiales dans les tables créées et ajouter d'éventuelles contraintes.

Veillez à respecter cet ordre d'exécution pour assurer la cohérence des données et des contraintes dans la base de données.
>[Cliquez ici pour plus d'info sur cette section](Initialisation.md)

---
### 2. Exécution des Requêtes du TP Précédent:

Pour exécuter les requêtes du TP précédent, veuillez suivre ces instructions :

4. **Requetes-TP2.sql :** Exécutez ce fichier pour mettre en place les requêtes du 
travail pratique précédent. Assurez-vous de lancer ce fichier pour obtenir les 
résultats attendus.

**Note importante :** Le fichier Requetes-TP2.sql contient un trigger 
essentiel. L'exécution de certains fichiers de test pourrait interagir avec
ce trigger et causer des problèmes. Par conséquent, exécutez ce fichier sans
hésitation pour garantir le bon fonctionnement du projet.

Veillez à exécuter ce fichier avant les fichiers qui suivent, en prenant en
considération l'avertissement concernant le trigger pour éviter tout impact 
indésirable sur les résultats.

---
### 3. Ajout des Index:
Ci-dessous, je liste les index à Exécuter :

```sql
CREATE INDEX idx_commande_date_commande ON Commande(date_commande);
CREATE INDEX idx_produit_description ON Produit(description);
CREATE INDEX idx_livraison_date_livraison ON Livraison(date_livraison);
```

>[Cliquez ici pour plus d'info sur cette section et pour la liste entiere des index](section1.md)

---
### 4. Exécution des Requêtes du TP3:
Enfin vous pouvez exécuter les requêtes du TP3, veuillez suivre ces instructions :

1. **Requetes-TP3.sql :** Ensuite, exécutez ce fichier pour avancer vers les requêtes
du TP3 . Assurez-vous de l'exécuter après Requetes-TP2.sql et avant les
fichiers de test.

## II) Les Tests :

Après avoir complété avec succès les étapes précédentes, nous sommes prêts à passer à l'exécution des
tests pour évaluer la robustesse et la fiabilité de notre système. Suivez les liens ci-dessus pour 
accéder à la documentation de chaque test et effectuez-les selon les spécifications pour garantir le
bon fonctionnement de notre application.

1. **Test des CHECK (contraintes) :**
    - [Accéder à la documentation du Test des CHECK](Tests-Check.md)

2. **Test des TRIGGER :**
    - [Accéder à la documentation du Test des TRIGGER](Tests-Trigger.md)

3. **Test de Procédure/Fonction PL/SQL :**
    - [Accéder à la documentation du Test des Procédure/Fonction PL/SQL](Tests-P-F.md)
	
---
### ***Procédure de Reprise en Cas d'Échec ou d'Erreur dans l'Ordre d'Exécution:***
>En cas de dysfonctionnement ou d'erreur dans l'exécution des étapes, ou si l'ordre
> d'exécution est incorrect, il est recommandé de procéder à la suppression des 
> éléments créés (utilisation de DROP) et de recommencer l'ordre d'exécution depuis 
> le début pour garantir l'intégrité et la cohérence du processus.
>
>Veillez à éliminer manuellement tous les déclencheurs (triggers), procédures,
> fonctions et séquences qui sont liés aux tables. Cela assure une suppression
> complète et ordonnée, évitant ainsi les dépendances non traitées dans la base de
> données
 
Voici le code pour supprimer les tables:

```sql
DROP TABLE Adresse CASCADE CONSTRAINTS;
DROP TABLE Client CASCADE CONSTRAINTS;
DROP TABLE Commande CASCADE CONSTRAINTS;
DROP TABLE Fournisseur CASCADE CONSTRAINTS;
DROP TABLE Produit CASCADE CONSTRAINTS;
DROP TABLE Prix_Produit CASCADE CONSTRAINTS;
DROP TABLE Produit_Fournisseur CASCADE CONSTRAINTS;
DROP TABLE Commande_Produit CASCADE CONSTRAINTS;
DROP TABLE Livraison CASCADE CONSTRAINTS;
DROP TABLE Livraison_Commande_Produit CASCADE CONSTRAINTS;
DROP TABLE Approvisionnement CASCADE CONSTRAINTS;
DROP TABLE Paiement CASCADE CONSTRAINTS;
```




