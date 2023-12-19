# Section 1 :Liste des index

>Avant d'exécuter les commandes d'index ci-dessous, veuillez vous assurer d'avoir lu attentivement
> le fichier README.md. Assurez-vous d'avoir suivi et achevé l'ÉTAPE I) décrite dans ce fichier.
> 
> Veuillez exécuter ces trois nouvelles commandes de création d'index pour améliorer les performances de
> la base de données conformément aux recommandations fournies.

## Nom de table : Adresse

Index :

* SYS_C005775047 (id_adresse)

## Nom de table : Client

Index :

* SYS_C005775053 (no_client)

## Nom de table : Commande

Index :

* SYS_C005775060 (no_commande)
* IDX_COMMANDE_DATE_COMMANDE (date_commande)

**Commande SQL:**
```sql
CREATE INDEX idx_commande_date_commande ON Commande(date_commande);
```

## Nom de table : Fournisseur

Index :

* SYS_C005775066 (code_fournisseur)

## Nom de table : Produit

Index :

* SYS_C005775076 (no_produit)
* IDX_PRODUIT_DESCRIPTION (description)

**Commande SQL:**
```sql
CREATE INDEX idx_produit_description ON Produit(description);
```

## Nom de table : Prix_Produit

Index :

* SYS_C005775081 (prix_unitaire, date_envigueur, no_produit)

## Nom de table : Produit_fournisseur

Index :

* SYS_C005775085 (no_produit, code_fournisseur)

## Nom de table : Commande_Produit

Index :

* SYS_C005775092 (no_commande, no_produit)

## Nom de table : Livraison

Index :

* SYS_C005775097 (no_livraison)
* IDX_LIVRAISON_DATE_LIVRAISON (date_livraison)

**Commande SQL:**
 ```sql
CREATE INDEX idx_livraison_date_livraison ON Livraison(date_livraison);
```

## Nom de table : Livraison_Commande_Produit

Index :

* SYS_C005775103 (no_livraison, no_commande, no_produit)

## Nom de table : Approvisionnement

Index :

* SYS_C005775113 (no_produit, code_fournisseur)

## Nom de table : Paiement

Index :

* SYS_C005775123 (id_paiement)
