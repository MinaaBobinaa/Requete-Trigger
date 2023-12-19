# Fonctionnement des Tests pour les Check

>Tous les tests se retrouvent dans ('/Tests/Test-CHECK.sql')
>
>Prérequis: `Creation.sql`

## Violation de la contrainte C1 de la table Commande :

### Description de la contrainte:
 Le statut de la commande doit être parmi 'ENCOURS', 'ANNULEE', ou 'FERMEE'.
 
### Commande SQL:
```sql
INSERT INTO Commande (no_commande, date_commande, statut, no_client)
VALUES (101, SYSDATE, 'INVALIDE', 1);
``` 

**Résultat Attendu :**

```text
Error starting at line : (numero ligne) in command -
INSERT INTO Commande (no_commande, date_commande, statut, no_client)
VALUES (101, SYSDATE, 'INVALIDE', 1);
Error report -
ORA-02290: check constraint (CH091976.C1) violated
```

## Violation de la contrainte C3 de la table Commande :

### Description de la contrainte:
La quantité en stock doit être supérieure ou égale à zéro.

### Commande SQL:
```sql
UPDATE Produit SET quantite_stock = -10 WHERE no_produit = 301;
```

**Résultat Attendu :**

```text
Error starting at line : (numero ligne) in command -
UPDATE Produit SET quantite_stock = -10 WHERE no_produit = 301;
Error report -
ORA-02290: check constraint (CH091976.C3) violated
```

## Violation de la contrainte C4 de la table Commande :

### Description de la contrainte:
La quantité seuil doit être supérieure ou égale à zéro.

### Commande SQL:
```sql
UPDATE Produit SET quantite_seuil = -5 WHERE no_produit = 302;
``` 

**Résultat Attendu :**

```text
Error starting at line : (numero ligne) in command -
UPDATE Produit SET quantite_seuil = -5 WHERE no_produit = 302;
Error report -
ORA-02290: check constraint (CH091976.C4) violated
```

## Violation de la contrainte C5 de la table Commande :

### Description de la contrainte:
La quantité commandée doit être supérieure à zéro

### Commande SQL:
```sql
INSERT INTO Commande_Produit (no_commande, no_produit, quantite_cmd)
VALUES (201, 301, 0);
``` 

**Résultat Attendu :**

```text
Error starting at line : (numero ligne) in command -
INSERT INTO Commande_Produit (no_commande, no_produit, quantite_cmd)
VALUES (201, 301, 0);
Error report -
ORA-02290: check constraint (CH091976.C5) violated
```

## Violation de la contrainte C6 de la table Commande :

### Description de la contrainte:
La quantité livrée doit être supérieure à zéro.

### Commande SQL:
```sql
UPDATE Livraison_Commande_Produit SET quantite_livree = -5 WHERE no_livraison = 50041 AND no_commande = 201 AND no_produit = 303;
``` 

**Résultat Attendu :**

```text
Error starting at line : (numero ligne) in command -
UPDATE Livraison_Commande_Produit SET quantite_livree = -5 WHERE no_livraison = 50041 AND no_commande = 201 AND no_produit = 303;
Error report -
ORA-02290: check constraint (CH091976.C6) violated
```

## Violation de la contrainte C7 de la table Commande :

### Description de la contrainte:
 La quantité approvisionnée doit être supérieure à zéro.

### Commande SQL:
```sql
UPDATE Approvisionnement SET quantite_approvis = 0 WHERE no_produit = 301 AND code_fournisseur = 45;
``` 

**Résultat Attendu :**

```text
Error starting at line : (numero ligne) in command -
UPDATE Approvisionnement SET quantite_approvis = 0 WHERE no_produit = 301 AND code_fournisseur = 45;
Error report -
ORA-02290: check constraint (CH091976.C7) violated
```

## Violation de la contrainte C8 de la table Commande :

### Description de la contrainte:
Le statut doit être parmi 'ENCOURS', 'ANNULE', ou 'LIVRE'.

### Commande SQL:
```sql
UPDATE Approvisionnement SET statut = 'INVALIDE' WHERE no_produit = 301 AND code_fournisseur = 45;
``` 

**Résultat Attendu :**

```text
Error starting at line : (numero ligne) in command -
UPDATE Approvisionnement SET statut = 'INVALIDE' WHERE no_produit = 301 AND code_fournisseur = 45;
Error report -
ORA-02290: check constraint (CH091976.C8) violated
```

## Violation de la contrainte C9 de la table Commande :

### Description de la contrainte:
 Le type de paiement doit être parmi 'CASH', 'CHEQUE', ou 'CREDIT'.

### Commande SQL:
```sql
INSERT INTO Paiement (id_paiement, date_paiement, montant, type_paiement, no_livraison)
VALUES (1001, SYSDATE, 150.00, 'INVALIDE', 501);
``` 

**Résultat Attendu :**

```text
Error starting at line : (numero ligne) in command -
INSERT INTO Paiement (id_paiement, date_paiement, montant, type_paiement, no_livraison)
VALUES (1001, SYSDATE, 150.00, 'INVALIDE', 501);
Error report -
ORA-02290: check constraint (CH091976.C9) violated
```

## Violation de la contrainte C10 de la table Commande :

### Description de la contrainte:
Le type de carte de crédit doit être parmi 'VISA', 'MASTERCARD', ou 'AMEX'.

### Commande SQL:
```sql
INSERT INTO Paiement (id_paiement, date_paiement, montant, type_paiement, type_carte_credit, no_livraison)
VALUES (1002, SYSDATE, 200.00, 'CREDIT', 'INVALIDE', 502);
``` 

**Résultat Attendu :**

```text
Error starting at line : (numero ligne) in command -
INSERT INTO Paiement (id_paiement, date_paiement, montant, type_paiement, type_carte_credit, no_livraison)
VALUES (1002, SYSDATE, 200.00, 'CREDIT', 'INVALIDE', 502);
Error report -
ORA-02290: check constraint (CH091976.C10) violated
```