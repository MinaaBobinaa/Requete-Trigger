--------------------------Section 2 : Développement des fonctionnalités ----------------------------
--Requête 2.1
CREATE OR REPLACE FUNCTION QuantiteDejaLivree
    (cp_no_produit Commande_Produit.no_produit%TYPE,
    cp_no_commande Commande_Produit.no_commande%TYPE) RETURN NUMBER
    IS
    v_quantite_livree NUMBER;
BEGIN
    SELECT NVL(SUM(quantite_livree), 0) ---checks if quantite_livree = null, then returns 0 (if true)
    INTO v_quantite_livree
    FROM Livraison_Commande_Produit
    WHERE no_produit = cp_no_produit
    AND no_commande = cp_no_commande;

    RETURN v_quantite_livree;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; 
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,'Erreur interne');
END;

CREATE OR REPLACE PROCEDURE VerifQuantLivree(
    p_no_produit IN Commande_Produit.no_produit%TYPE,
    p_no_commande IN Commande_Produit.no_commande%TYPE
)
IS
    v_quantity_delivered NUMBER;
BEGIN
    
    v_quantity_delivered := QuantiteDejaLivree(p_no_produit, p_no_commande);
    DBMS_OUTPUT.PUT_LINE('La quantité livrée: ' || v_quantity_delivered);
END;
/

BEGIN
    VerifQuantLivree(302, 201);
END;
/