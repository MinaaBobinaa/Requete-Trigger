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

**Commande SQL :**

```sql
BEGIN
    checkdeliveredquantity(302, 201);
END;
/ 
```
**Résultat Attendu :**

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