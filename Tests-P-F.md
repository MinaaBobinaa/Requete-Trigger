# Fonctionnement des Tests pour les Procédure/Fonction PL/SQL

>Tous les tests se retrouvent dans ('/Tests/Test-Requete-TP3.sql')
>
>Prérequis: `Requetes-TP3.sql`

## IMPORTANT AVANT EXCECUTION:

Veillez à exécuter cette commande avant les tests qui suivent:

```
SET SERVEROUTPUT ON;
```

Cette commande est utilisee pour activer l'affichage des messages DBMS_OUTPUT.

---
## Test Requête 2.1:

### 1. Test 1: Un numéro d’article et un numéro de commande qui ont une quantité déjà livrée

**Commande SQL :**

```sql
BEGIN
    VerifQuantLivree(304, 202);
END;
/ 
```
**Résultat Attendu :**

```text
La quantité livrée: 3
```

### 2. Test 2: Un numéro d’article et un numéro de commande qui n'ont pas une quantité livrée OU aucun des deux existent

**Commande SQL :**

```sql
BEGIN
    VerifQuantLivree(302, 201);
END;
/ 
```

```sql
BEGIN
    VerifQuantLivree(0, 1);
END;
/ 
```
**Résultat Attendu :**

```text
La quantité livrée: 0
```

---
## Test Requête 2.2:

### 1. Test 1: Le no_client existe et a des commandes 'ENCOURS'

**Commande SQL :**

```sql
DECLARE
    v_no_client NUMBER := 100; --Remplacez ceci par un numéro de client
BEGIN
    PreparerLivraison(v_no_client);
END;
/
``` 

**Résultat Attendu :**

```text
Nom du client : Tremblay
Prénom du client : Michel
Téléphone : (123) 456-7890
Adresse : 123 Maple Street, Toronto, Canada, M5V 2W6
Numéro de livraison : (numero livraison)
Date de livraison : (SYSDATE)
Commande n°201, date commande : 15-OCT-22, Description produit : Ordinateur portable,Quantité à livrer: 5
Commande n°201, date commande : 15-OCT-22, Description produit : Smartphone,Quantité à livrer: 2
Commande n°201, date commande : 15-OCT-22, Description produit : Tablette,Quantité à livrer: 4
Commande n°202, date commande : 16-OCT-22, Description produit : Clavier,Quantité à livrer: 3
Commande n°202, date commande : 16-OCT-22, Description produit : Routeur,Quantité à livrer: 1
Commande n°202, date commande : 16-OCT-22, Description produit : Écran,Quantité à livrer: 4
```

### 2. Test 2: Le no_client existe mais n'a pas de commandes 'ENCOURS'

**Commande SQL :**

```sql
DECLARE
    v_no_client NUMBER := 103; 
BEGIN
    PreparerLivraison(v_no_client);
END;
/
```

**Résultat Attendu :**

```text
Nom du client : Davis
Prénom du client : Sarah
Téléphone : (456) 789-0123
Adresse : 101 Elm Street, Calgary, Canada, T2P 0R5
Numéro de livraison : (numero livraison)
Date de livraison : (SYSDATE)
```

### 3. Test 3: Le no_client n'existe pas 

**Commande SQL :**

```sql
DECLARE
    v_no_client NUMBER := 10011; 
BEGIN
    PreparerLivraison(v_no_client);
END;
/
```

**Résultat Attendu :**

```text
Error starting at line : (num) in command -
DECLARE
    v_no_client NUMBER := 10011;
BEGIN
    PreparerLivraison(v_no_client);
END;
Error report -
ORA-20001: Client non trouvé pour le numéro spécifié.
ORA-06512: at "CH091976.PREPARERLIVRAISON", line (num)
ORA-06512: at line (num)
```

---
## Test Requête 2.3:

### 1. Test 1: Numéro de livraison est dans la table Livraison_Commande_Produit

**Commande SQL :**

```sql
BEGIN
ProduireFacture(50041);
END;
/
``` 

**Résultat Attendu :**

```text
----------------------Informations sur la facture:----------------------------- 
Nom du client: Tremblay
Prénom du client: Michel
Adresse: 123 Maple Street, Toronto, Canada, M5V 2W6
Numéro de livraison / Facture: 50041
Date de livraison: 25-11-2022
-------------------------------Montant: --------------------------------------
Montant total avant taxe: 1999.96
Montant des taxes (15%): 299.99
Montant total de la facture: 2299.95
---------------------------Liste des produits livrés:-------------------------- 
Numéro de produit: 303
Description: Tablette
Numéro de commande: 201
Prix unitaire: 499.99
Quantité livrée: 1
Prix total du produit: 499.99
```

### 2. Test 2: Autre exemple du test 1

**Commande SQL :**

```sql
BEGIN
ProduireFacture(51076);
END;
/
``` 

**Résultat Attendu :**

```text
----------------------Informations sur la facture:----------------------------- 
Nom du client: Brown
Prénom du client: Michael
Adresse: 789 Cedar Lane, Vancouver, Canada, V6C 1B1
Numéro de livraison / Facture: 51076
Date de livraison: 29-11-2022
-------------------------------Montant: --------------------------------------
Montant total avant taxe: 1399.98
Montant des taxes (15%): 210
Montant total de la facture: 1609.98
---------------------------Liste des produits livrés:-------------------------- 
Numéro de produit: 302
Description: Smartphone
Numéro de commande: 205
Prix unitaire: 699.99
Quantité livrée: 1
Prix total du produit: 699.99
```

### 3. Test 3: Numéro de livraison n'est pas dans la table Livraison_Commande_Produit

**Commande SQL :**

```sql
BEGIN
ProduireFacture(0);
END;
/
``` 

**Résultat Attendu :**

```text
Error starting at line : (num) in command -
BEGIN
ProduireFacture(0);
END;
Error report -
ORA-20004: Numéro de livraison non trouvé dans la table Livraison_Commande_Produit.
ORA-06512: at "CH091976.PRODUIREFACTURE", line (num)
ORA-06512: at line (num)
```