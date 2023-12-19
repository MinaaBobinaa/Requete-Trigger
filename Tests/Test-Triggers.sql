---------------TEST-TRIGGER---------

-- Test I
DELETE FROM Produit
WHERE no_produit = 301;

-- Test II
UPDATE Produit
SET description = 'une description quelconque'
WHERE no_produit = 301;
UPDATE Produit
SET no_produit = 420
WHERE no_produit = 301;

-- Test III
-- Afficher avant
SELECT no_produit, quantite_approvis
FROM Approvisionnement
WHERE no_produit = 306;
-- Diminuer quantite en stock
UPDATE Produit
SET quantite_stock = 0
WHERE no_produit = 306;
-- Afficher apres
SELECT no_produit, quantite_approvis
FROM Approvisionnement
WHERE no_produit = 306;

-- Test IV
UPDATE Commande
SET statut = 'ANNULEE'
WHERE no_commande = 201;

-- Test V
UPDATE Commande
SET no_commande = 999
WHERE no_commande = 201;
UPDATE Commande
SET date_commande = '02-OCT-1999'
WHERE no_commande = 201;
UPDATE Commande
SET no_client = 777
WHERE no_commande = 201;

-- Test VI
UPDATE Livraison_Commande_Produit
SET quantite_livree = 99
WHERE no_commande = 201 AND no_produit = 302;

--Test 3.1
INSERT INTO Paiement (date_paiement, montant, type_paiement, no_livraison) 
VALUES ('27-DEC-2022', 100.00, 'CASH', 50041);
INSERT INTO Paiement (date_paiement, montant, type_paiement, no_livraison) 
VALUES ('28-DEC-2022', 50.00, 'CASH', 51076);

SELECT * FROM Paiement WHERE no_livraison = 50041;
---------------------------------------------------
SELECT * FROM Paiement WHERE no_livraison = 51076;