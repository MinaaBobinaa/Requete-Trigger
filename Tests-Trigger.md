# Fonctionnement des Tests pour les Triggers

>Tous les tests se retrouvent dans ('/Tests/Test-Triggers.sql')
>
>Prérequis: `Triggers.sql`, `Insertion.sql` et `Requetes-TP2.sql`

## Test I : Tentative de Suppression de produit

### Description du trigger:
Ce déclencheur est une mesure de sécurité pour empêcher toute suppression de ligne dans
la table "Produit". Chaque fois qu'une commande DELETE est exécutée sur cette table, ce 
déclencheur est activé avant la suppression effective de la ligne. Si ce déclencheur est déclenché,
il génère une erreur d'application indiquant qu'il est interdit de supprimer un produit, empêchant 
ainsi la suppression.

### Étapes :
1. **Action :** Exécution de la commande DELETE pour supprimer une ligne existante dans la table "Produit".
2. **Résultat Attendu :** Si le déclencheur fonctionne comme prévu, la tentative de suppression de la ligne générera 
une erreur et ne sera pas effectuée. Vous devriez obtenir un message indiquant qu'il est interdit de supprimer un produit.

### Commande SQL:
```sql
-- Test I
DELETE FROM Produit
WHERE no_produit = 301;
```
## Test II : Interdit de modifier le numéro et la description du produit

### Description du trigger:
Ce déclencheur vise à prévenir toute modification des champs "no_produit" et "description" dans la table "Produit".
Lorsqu'une commande UPDATE est exécutée sur cette table, ce déclencheur est déclenché avant la mise à jour effective
de la ligne. S'il détecte une tentative de modification du numéro de produit ou de sa description, il génère une erreur
d'application indiquant qu'il est interdit de procéder à ces modifications, empêchant ainsi la mise à jour.

### Étapes :
1. **Action :** Exécution de la commande UPDATE pour modifier les champs "description" ou "no_produit" d'une ligne 
existante dans la table "Produit".
2. **Résultat Attendu :** Si le déclencheur fonctionne correctement, toute tentative de modification du numéro de 
produit ou de sa description générera une erreur. Vous devriez obtenir un message indiquant qu'il est interdit de
 modifier le numéro et la description du produit.

### Commande SQL:
```sql
-- Test II
--a)
UPDATE Produit
SET description = 'une description quelconque'
WHERE no_produit = 301;
--b)
UPDATE Produit
SET no_produit = 420
WHERE no_produit = 301;
```

## Test III : Approvisionnement automatique en cas d'atteinte du seuil minimum d'un produit

### Description du trigger:
Ce déclencheur est conçu pour automatiser le processus d'approvisionnement d'un produit lorsqu'un seuil
minimum est atteint. Il est déclenché après une opération d'INSERTION ou de MISE À JOUR dans la table
"Produit". Si la quantité en stock du nouveau produit ou mise à jour est inférieure ou égale à son seuil 
minimal, le déclencheur déclenche automatiquement un processus d'approvisionnement en mettant à jour la table
"Approvisionnement". Il augmente la quantité d'approvisionnement de deux fois le seuil minimal, met à jour la
date de commande d'approvisionnement et définit le statut comme "ENCOURS".

### Étapes :
1. **Action :** Effectuer une opération d'INSERTION ou de MISE À JOUR sur un produit dont la quantité
en stock sera réduite à un niveau inférieur ou égal à son seuil minimal.
2. **Résultat Attendu :** Après l'exécution de l'opération qui réduit la quantité en stock en dessous
du seuil minimal, le déclencheur devrait automatiquement mettre à jour la table "Approvisionnement"
en augmentant la quantité d'approvisionnement et en mettant à jour la date de commande pour le 
produit concerné.

### Commande SQL:
```sql
-- Test III
-- Afficher avant
SELECT no_produit, quantite_approvis
FROM Approvisionnement
WHERE no_produit = 306;

-- Diminuer quantite en stock
UPDATE Produit
SET quantite_stock = 0
WHERE no_produit = 306;

-- Afficher après
SELECT no_produit, quantite_approvis
FROM Approvisionnement
WHERE no_produit = 306;
```

## Test IV : Conditions pour annuler une commande

### Description du trigger:
Ce déclencheur est conçu pour empêcher l'annulation d'une commande lorsqu'au moins un des articles 
commandés a été livré. Il s'active avant toute mise à jour de la table "Commande". Si la commande est
marquée comme "ANNULEE" et qu'au moins un article de cette commande a été livré, le déclencheur génère
une erreur d'application empêchant l'annulation de la commande.

### Étapes :
1. **Action :** Effectuer une mise à jour sur une commande en modifiant son statut à "ANNULEE".
2. **Résultat Attendu :** Si des articles de cette commande ont été livrés, la tentative d'annulation devrait 
générer une erreur indiquant qu'il est interdit d'annuler une commande partiellement ou complètement livrée.

### Commande SQL:
```sql
-- Test IV
UPDATE Commande
SET statut = 'ANNULEE'
WHERE no_commande = 201;
```

## Test V : Interdiction de modifier les informations d'une commande après sa confirmation

### Description du trigger: 
Ce déclencheur est conçu pour empêcher la modification des détails d'une commande une fois 
qu'elle a été confirmée. Il s'active avant toute mise à jour sur la table "Commande". Si une
tentative est faite pour modifier les champs autres que le statut de la commande après sa
confirmation, le déclencheur génère une erreur d'application interdisant cette action.

### Étapes : 
1. **Action :**  Effectuer des mises à jour sur une commande déjà confirmée, en modifiant des
champs autres que son statut.
2. **Résultat Attendu :** La tentative de modification des détails de la commande (autres que le statut) 
devrait générer une erreur indiquant qu'il est interdit de modifier une commande après sa confirmation.

### Commande SQL:
```sql
-- Test V
--Modifier no_commande
UPDATE Commande
SET no_commande = 999
WHERE no_commande = 201;
--Modifier date_commande
UPDATE Commande
SET date_commande = '02-OCT-1999'
WHERE no_commande = 201;
--Modifier no_client
UPDATE Commande
SET no_client = 777
WHERE no_commande = 201;
```

## Test VI : Vérification avant livraison d'un produit

### Description du trigger: 
Ce déclencheur est conçu pour vérifier avant la livraison d'un produit que celui-ci a été effectivement commandé 
par le client associé au bon numéro de commande, et que la quantité à livrer n'excède pas la quantité commandée.
Il est activé avant toute opération d'INSERTION ou de MISE À JOUR sur la table "Livraison_Commande_Produit". Si 
la quantité à livrer excède la quantité commandée pour le produit dans cette commande spécifique, le déclencheur
génère une erreur d'application.

### Étapes :
1. **Action :** Effectuer une opération d'INSERTION ou de MISE À JOUR sur une livraison de produit, en indiquant
une quantité livrée supérieure à celle commandée dans une commande existante.
2. **Résultat Attendu :** La tentative de livraison d'une quantité supérieure à celle commandée devrait générer
une erreur indiquant que le produit n'a pas été commandé ou a déjà été livré.

### Commande SQL:
```sql
-- Test VI
UPDATE Livraison_Commande_Produit
SET quantite_livree = 99
WHERE no_commande = 201 AND no_produit = 302;
```

## Test requete 3.1 (TP2) : Création automatique de l’ID de la table Paiement (commence à 1000)

### Description du trigger: 
 Ce déclencheur est activé avant toute opération d'INSERTION dans la table Paiement. Il vérifie si la colonne 
 `id_paiement` est nulle pour chaque nouvelle ligne insérée. Si c'est le cas, il utilise la séquence increment_par_1
 pour générer automatiquement la valeur suivante pour cette colonne.
 
### Étapes :
1. **Action :** Effectuer deux (ou seulement 1) opérations d'INSERTION dans la table Paiement pour des numéros de livraison
différents.
2. **Résultat Attendu :**  Les insertions devraient ajouter des enregistrements dans la table Paiement avec des 
identifiants qui commencent par 1000 et qui incrementent a chaque INSERT.

### Commande SQL:
```sql
-- Test 3.1
INSERT INTO Paiement (date_paiement, montant, type_paiement, no_livraison) 
VALUES ('27-DEC-2022', 100.00, 'CASH', 50041);

INSERT INTO Paiement (date_paiement, montant, type_paiement, no_livraison) 
VALUES ('28-DEC-2022', 50.00, 'CASH', 51076);
```
```sql
SELECT * FROM Paiement WHERE no_livraison = 50041;
```
```sql
SELECT * FROM Paiement WHERE no_livraison = 51076;
```