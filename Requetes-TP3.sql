--------------------------Section 2 : Développement des fonctionnalités ----------------------------

-----------------------------------------Requête 2.1-------------------------------------------------

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

-------------------------------------
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

-----------------------------------------Requête 2.2-------------------------------------------------

CREATE SEQUENCE seq_num_livraison
  START WITH 52000
  INCREMENT BY 1;
  
CREATE OR REPLACE PROCEDURE PreparerLivraison (p_no_client NUMBER)
IS
    v_nom_client Client.nom%TYPE;
    v_prenom_client Client.prenom%TYPE;
    v_telephone Client.telephone%TYPE;
    v_id_adresse Client.id_adresse%TYPE;
    v_adresse VARCHAR(200);
    v_no_livraison Livraison.no_livraison%TYPE;
    v_date_livraison Livraison.date_livraison%TYPE;

BEGIN
    
    SELECT nom, prenom, telephone, id_adresse
    INTO v_nom_client, v_prenom_client, v_telephone, v_id_adresse
    FROM Client
    WHERE no_client = p_no_client;
    
     IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Le numéro de client spécifié n''existe pas.');
    END IF;
    

    SELECT seq_num_livraison.NEXTVAL INTO v_no_livraison FROM dual;
    INSERT INTO Livraison (no_livraison, date_livraison)VALUES (v_no_livraison, SYSDATE);

    
    DBMS_OUTPUT.PUT_LINE('Nom du client : ' ||  v_nom_client);
    DBMS_OUTPUT.PUT_LINE('Prénom du client : ' ||  v_prenom_client);
    DBMS_OUTPUT.PUT_LINE('Téléphone : ' || v_telephone);
    SELECT no_civique || ' ' || nom_rue || ', ' || ville || ', ' || pays || ', ' || code_postal
    INTO v_adresse
    FROM Adresse
    WHERE id_adresse = v_id_adresse;
    DBMS_OUTPUT.PUT_LINE('Adresse : ' || v_adresse);
    DBMS_OUTPUT.PUT_LINE('Numéro de livraison : ' ||  v_no_livraison);
    DBMS_OUTPUT.PUT_LINE('Date de livraison : ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY'));
    
    FOR prod IN (SELECT CP.no_commande, C.date_commande, P.description, CP.quantite_cmd, CP.no_produit
                 FROM Commande_Produit CP
                 INNER JOIN Commande C ON CP.no_commande = C.no_commande
                 INNER JOIN Produit P ON CP.no_produit = P.no_produit
                 WHERE C.no_client = p_no_client AND C.statut = 'ENCOURS')
    LOOP
        
        DECLARE
            v_stock_disponible Produit.quantite_stock%TYPE;
        BEGIN
            SELECT quantite_stock INTO v_stock_disponible
            FROM Produit
            WHERE no_produit = prod.no_produit;

            
            IF prod.quantite_cmd <= v_stock_disponible THEN
                
                INSERT INTO Livraison_Commande_Produit (no_livraison, no_commande, no_produit, quantite_livree)
                VALUES (v_no_livraison, prod.no_commande, prod.no_produit, prod.quantite_cmd);

                
                UPDATE Produit
                SET quantite_stock = quantite_stock - prod.quantite_cmd
                WHERE no_produit = prod.no_produit;
            ELSE
                
                NULL; 
            END IF;
        END;
    END LOOP;
    FOR prod IN (SELECT CP.no_commande, C.date_commande, P.description, CP.quantite_cmd
                 FROM Commande_Produit CP
                 INNER JOIN Commande C ON CP.no_commande = C.no_commande
                 INNER JOIN Produit P ON CP.no_produit = P.no_produit
                 WHERE C.no_client = p_no_client AND C.statut = 'ENCOURS')
    LOOP
        DBMS_OUTPUT.PUT_LINE('Commande n°' ||  prod.no_commande ||  ', date commande : ' || prod.date_commande ||
        ', Description produit : ' || prod.description || ',Quantité à livrer: ' || prod.quantite_cmd);
    END LOOP;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'Client non trouvé pour le numéro spécifié.');
    WHEN OTHERS THEN
        RAISE;
END;
/

-----------------------------------------Requête 2.3-------------------------------------------------

CREATE OR REPLACE PROCEDURE ProduireFacture (p_no_livraison IN NUMBER)
IS
  v_nom_client Client.nom%TYPE;
  v_prenom_client Client.prenom%TYPE;
  
  v_no_civique Adresse.no_civique%TYPE;
  v_nom_rue Adresse.nom_rue%TYPE;
  v_ville Adresse.ville%TYPE;
  v_pays Adresse.pays%TYPE;
  v_code_postal Adresse.code_postal%TYPE;
  v_date_livraison Livraison.date_livraison%TYPE;
  v_montant_total_avant_taxe NUMBER(10, 2);
  v_montant_taxes NUMBER(10, 2);
  v_montant_total NUMBER(10, 2);
BEGIN
 
  SELECT cl.nom, cl.prenom, a.no_civique, a.nom_rue, a.ville, a.pays, a.code_postal, l.date_livraison
  INTO v_nom_client, v_prenom_client, v_no_civique, v_nom_rue, v_ville, v_pays, v_code_postal, v_date_livraison
  FROM Livraison_Commande_Produit lcp
  JOIN Commande c ON lcp.no_commande = c.no_commande
  JOIN Client cl ON c.no_client = cl.no_client
  JOIN Adresse a ON cl.id_adresse = a.id_adresse
  JOIN Livraison l ON lcp.no_livraison = l.no_livraison
  WHERE lcp.no_livraison = p_no_livraison;

  
  DBMS_OUTPUT.PUT_LINE('----------------------Informations sur la facture:----------------------------- ');
  DBMS_OUTPUT.PUT_LINE('Nom du client: ' || v_nom_client);
  DBMS_OUTPUT.PUT_LINE('Prénom du client: ' || v_prenom_client);
  DBMS_OUTPUT.PUT_LINE('Adresse: ' || v_no_civique || ' ' || v_nom_rue || ', ' || v_ville || ', ' || v_pays || ', ' || v_code_postal);
  DBMS_OUTPUT.PUT_LINE('Numéro de livraison / Facture: ' || p_no_livraison);
  DBMS_OUTPUT.PUT_LINE('Date de livraison: ' || TO_CHAR(v_date_livraison, 'DD-MM-YYYY'));

  
  SELECT SUM(cp.quantite_cmd * pp.prix_unitaire) INTO v_montant_total_avant_taxe
  FROM Livraison_Commande_Produit lcp
  JOIN Commande_Produit cp ON lcp.no_commande = cp.no_commande AND lcp.no_produit = cp.no_produit
  JOIN Prix_Produit pp ON cp.no_produit = pp.no_produit
  WHERE lcp.no_livraison = p_no_livraison;

  v_montant_taxes := v_montant_total_avant_taxe * 0.15;
  v_montant_total := v_montant_total_avant_taxe + v_montant_taxes;

  DBMS_OUTPUT.PUT_LINE('-------------------------------Montant: --------------------------------------');
  DBMS_OUTPUT.PUT_LINE('Montant total avant taxe: ' || v_montant_total_avant_taxe);
  DBMS_OUTPUT.PUT_LINE('Montant des taxes (15%): ' || v_montant_taxes);
  DBMS_OUTPUT.PUT_LINE('Montant total de la facture: ' || v_montant_total);

 
  DBMS_OUTPUT.PUT_LINE('---------------------------Liste des produits livrés:-------------------------- ');
  FOR prod IN (SELECT lcp.no_produit, p.description, lcp.no_commande, pp.prix_unitaire, lcp.quantite_livree,
                      pp.prix_unitaire * lcp.quantite_livree AS prix_total_produit
               FROM Livraison_Commande_Produit lcp
               JOIN Produit p ON lcp.no_produit = p.no_produit
               JOIN Commande_Produit cp ON lcp.no_commande = cp.no_commande AND lcp.no_produit = cp.no_produit
               JOIN Prix_Produit pp ON lcp.no_produit = pp.no_produit
               WHERE lcp.no_livraison = p_no_livraison)
  LOOP
    DBMS_OUTPUT.PUT_LINE('Numéro de produit: ' || prod.no_produit);
    DBMS_OUTPUT.PUT_LINE('Description: ' || prod.description);
    DBMS_OUTPUT.PUT_LINE('Numéro de commande: ' || prod.no_commande);
    DBMS_OUTPUT.PUT_LINE('Prix unitaire: ' || prod.prix_unitaire);
    DBMS_OUTPUT.PUT_LINE('Quantité livrée: ' || prod.quantite_livree);
    DBMS_OUTPUT.PUT_LINE('Prix total du produit: ' || prod.prix_total_produit);
  END LOOP;
  
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004, 'Numéro de livraison non trouvé dans la table Livraison_Commande_Produit.');
    WHEN OTHERS THEN
        RAISE;
END;
/
