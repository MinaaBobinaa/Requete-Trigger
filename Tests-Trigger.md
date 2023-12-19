# Fonctionnement des Tests pour les Triggers

>Tous les tests se retouvent dans ('/Tests/Test-Triggers.sql')
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