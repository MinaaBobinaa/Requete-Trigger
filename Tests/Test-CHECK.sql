--------------Contredire les contraintes CHECK :-------------------------

-- Contredire la contrainte C1 de la table Commande
INSERT INTO Commande (no_commande, date_commande, statut, no_client)
VALUES (101, SYSDATE, 'INVALIDE', 1);

-- Contredire la contrainte C3 de la table Produit
UPDATE Produit SET quantite_stock = -10 WHERE no_produit = 301;

-- Contredire la contrainte C4 de la table Produit
UPDATE Produit SET quantite_seuil = -5 WHERE no_produit = 302;

-- Contredire la contrainte C5 de la table Commande_Produit
INSERT INTO Commande_Produit (no_commande, no_produit, quantite_cmd)
VALUES (201, 301, 0);

-- Contredire la contrainte C6 de la table Livraison_Commande_Produit
UPDATE Livraison_Commande_Produit SET quantite_livree = -5 WHERE no_livraison = 50041 AND no_commande = 201 AND no_produit = 303;

-- Contredire la contrainte C7 de la table Approvisionnement
UPDATE Approvisionnement SET quantite_approvis = 0 WHERE no_produit = 301 AND code_fournisseur = 45;

-- Contredire la contrainte C8 de la table Approvisionnement
UPDATE Approvisionnement SET statut = 'INVALIDE' WHERE no_produit = 301 AND code_fournisseur = 45;

-- Contredire la contrainte C9 de la table Paiement
INSERT INTO Paiement (id_paiement, date_paiement, montant, type_paiement, no_livraison)
VALUES (1001, SYSDATE, 150.00, 'INVALIDE', 501);

-- Contredire la contrainte C10 de la table Paiement
INSERT INTO Paiement (id_paiement, date_paiement, montant, type_paiement, type_carte_credit, no_livraison)
VALUES (1002, SYSDATE, 200.00, 'CREDIT', 'INVALIDE', 502);
