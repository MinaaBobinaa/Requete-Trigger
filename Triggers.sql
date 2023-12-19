--------------------------TRIGGER------------------------------

-- I. Il est interdit de supprimer un produit
CREATE TRIGGER interdit_suppr_produit
BEFORE DELETE ON Produit
FOR EACH ROW
DECLARE
BEGIN
    RAISE_APPLICATION_ERROR(-20000,'Il est interdit de supprimer un produit');
END;
/

-- II. Interdit de modifié numéro et description du produit
CREATE TRIGGER interdit_update_num_descr
BEFORE UPDATE ON Produit
FOR EACH ROW
DECLARE
BEGIN
    IF (:NEW.no_produit != :OLD.no_produit)
    OR (:NEW.description != :OLD.description)
    THEN
        RAISE_APPLICATION_ERROR(-20001, 'Interdit de modifie numero et description du produit');
    END IF;
END;
/

-- III. Si seuil minimum d'un produit est atteint -> approvisionnement automatiquement
-- et inventaire mis à jour
CREATE TRIGGER approvisionnement_automatique
AFTER INSERT OR UPDATE ON Produit
FOR EACH ROW
DECLARE
BEGIN
    IF (:NEW.quantite_stock <= :NEW.quantite_seuil)
    THEN
        UPDATE Approvisionnement
        SET
            quantite_approvis = quantite_approvis + :NEW.quantite_seuil*2,
            date_cmd_approvis = SYSDATE,
            statut = 'ENCOURS'
        WHERE :OLD.no_produit = Approvisionnement.no_produit
        AND :NEW.code_fournisseur_prioritaire = Approvisionnement.code_fournisseur;
    END IF;
END;
/

-- IV. Il est possible d'annuler une commande seulement lorsqu'aucun des items commandés n'a été livré
CREATE TRIGGER condition_annul_commande
BEFORE UPDATE ON Commande
FOR EACH ROW
DECLARE
    quantite_livree_temp NUMBER(6,0);
BEGIN
    SELECT SUM(quantite_livree)
    INTO quantite_livree_temp
    FROM Livraison_Commande_Produit LCP
    WHERE LCP.no_commande = :OLD.no_commande;
    IF (quantite_livree_temp > 0)
    AND (:NEW.statut = 'ANNULEE')
    THEN
        RAISE_APPLICATION_ERROR(-20002, 'Interdit d''annuler une commande qui est partiellement ou complement livree');
    END IF;
END;
/

-- V. Il est interdit de modifier l'information d'une commande après sa confirmation.
CREATE TRIGGER interdit_modif_commande
BEFORE UPDATE ON Commande
FOR EACH ROW
DECLARE
BEGIN
    IF (:NEW.no_commande != :OLD.no_commande)
    OR (:NEW.date_commande != :OLD.date_commande)
    OR (:NEW.no_client != :OLD.no_client)
    THEN
        RAISE_APPLICATION_ERROR(-20003, 'Interdit de modifie une commande (sauf son statut)');
    END IF;
END;
/

-- VI. avant de livrer, vérifier que le produit est commandé par le client (bon no_commande)
--     et que la quantité commandée n'est pas déjà atteinte
CREATE TRIGGER condition_livrer
BEFORE UPDATE OR INSERT ON Livraison_Commande_Produit
FOR EACH ROW
DECLARE
    quantite_cmd_temp NUMBER (6,0);
BEGIN
    SELECT quantite_cmd
    INTO quantite_cmd_temp
    FROM Commande_Produit CP
    WHERE CP.no_commande = :NEW.no_commande
    AND CP.no_produit = :NEW.no_produit;
    IF
        (:NEW.quantite_livree > quantite_cmd_temp)
    THEN
        RAISE_APPLICATION_ERROR(-20004, 'Le produit n''a pas ete commande ou est deja livree');
    END IF;
END;
/