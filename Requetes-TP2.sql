--Requête 2.1
SELECT DISTINCT
    nom, prenom, telephone,
    A.no_civique AS no_civique,
    A.nom_rue AS nom_rue,
    A.ville AS ville,
    A.pays AS pays,
    A.code_postal AS code_postal
FROM
    Client
JOIN
    Commande CO ON Client.no_client = CO.no_client
JOIN
    Adresse A ON Client.id_adresse = A.id_adresse;
    
--Requête 2.2
SELECT 
    no_commande, date_commande,
    C.nom AS nom_client,
    C.prenom AS prenom_client,
    C.telephone AS telephone
FROM
    Commande
JOIN
    Client C ON Commande.no_client = C.no_client
WHERE
    date_commande BETWEEN '31-OCT-2022' AND '06-NOV-2022';
--Requête 2.3
SELECT
    CO.no_commande AS no_commande,
    CO.date_commande AS date_commande,
    CP.no_produit AS no_produit,
    P.description AS description,
    CP.quantite_cmd AS quantite_cmd
FROM
    Commande CO
JOIN
    Client C ON CO.no_client = C.no_client
JOIN
    Commande_Produit CP ON CO.no_commande = CP.no_commande
JOIN
    Produit P ON CP.no_produit = P.no_produit
WHERE
    C.nom = 'Tremblay' AND C.prenom = 'Michel' AND CO.statut = 'ENCOURS'
ORDER BY
    CO.no_commande;
--Requête 2.4
--a)
SELECT
    P.no_produit AS no_produit,
    P.description AS description,
    F.raison_sociale AS raison_sociale_fournisseur,
    F.telephone AS telephone_fournisseur
FROM
    Produit P
JOIN
    Produit_Fournisseur PF ON P.no_produit = PF.no_produit
JOIN
    Fournisseur F ON PF.code_fournisseur = F.code_fournisseur;
--b)
SELECT
    P.description AS description,
    (
        SELECT COUNT(*)
        FROM Produit_Fournisseur PF
        WHERE PF.no_produit = P.no_produit
    ) AS nombre_de_fournisseurs
FROM
    Produit P
ORDER BY
    P.description;

--Requête 2.5
SELECT
    P.no_produit AS no_produit,
    P.description AS description,
    P.quantite_stock AS quantite_en_stock,
    PP.prix_unitaire AS prix_unitaire,
    PP.date_envigueur AS date_en_vigueur
FROM
    Produit P
JOIN
    Prix_Produit PP ON P.no_produit = PP.no_produit
ORDER BY
    PP.date_envigueur;
    
--------------------------------------------------------------------------------------

--Rectification :
ALTER TABLE Produit
ADD prix_unite NUMBER(8,2);

--Requête 3.1

CREATE SEQUENCE increment_par_1
  start with 1000 
  increment by 1;

CREATE TRIGGER incr_id_paiement
  BEFORE INSERT ON Paiement
  FOR EACH ROW
DECLARE
BEGIN
  IF( :new.id_paiement IS NULL )
  THEN
    :new.id_paiement := increment_par_1.nextval;
  END IF;
END;
/

--Requête 3.2
--a)
CREATE VIEW V_commande_item AS
SELECT 
    CLT.nom AS nom_client,
    CLT.prenom AS prenom_client,
    CMD.no_commande AS no_commande,
    CP.quantite_cmd AS quantite_cmd,
    PP.prix_unitaire AS prix_unitaire_produit,
    CMD.statut AS statut_cmd
FROM Commande CMD
JOIN Client CLT ON CMD.no_client = CLT.no_client
JOIN Commande_Produit CP ON CMD.no_commande = CP.no_commande
JOIN Produit P ON CP.no_produit = P.no_produit
JOIN Prix_Produit PP ON CP.no_produit = PP.no_produit AND PP.date_envigueur = (
    SELECT MAX(date_envigueur) FROM Prix_Produit WHERE no_produit = CP.no_produit
);
SELECT * FROM V_commande_item;

--b)
SELECT V.*, (quantite_cmd*prix_unitaire_produit)AS Prix_Total_item
FROM V_commande_item V
WHERE prenom_client = 'Michel' AND nom_client = 'Tremblay';

--c)
SELECT V.*, (quantite_cmd*prix_unitaire_produit)AS Prix_Total_item
FROM V_commande_item V
WHERE no_commande = 300;

--d)
SELECT SUM(quantite_cmd * prix_unitaire_produit) AS Montant_Total
FROM V_commande_item
WHERE no_commande = 300;

--Requête 3.3
SELECT statut, COUNT(*) AS nombre_de_commandes
FROM Commande
GROUP BY statut;

--Requête 3.4a
SELECT CP.no_commande, COUNT(*) AS nombre_items
FROM Commande_Produit CP
GROUP BY CP.no_commande
ORDER BY nombre_items DESC;

--Requête 3.4b
SELECT no_commande, nombre_items
FROM (
    SELECT CP.no_commande, COUNT(*) AS nombre_items
    FROM Commande_Produit CP
    GROUP BY CP.no_commande
) CmdPlusUnItem
WHERE nombre_items > 1;

--Requête 3.5
SELECT SUM(montant) AS total_paiements_en_especes
FROM Paiement
WHERE type_paiement = 'CASH'
  AND TO_CHAR(date_paiement, 'MON') = 'NOV';
  
--Requête 3.6
SELECT MAX(nombre_items) AS nombre_items_max
FROM (SELECT no_commande, COUNT(*) AS nombre_items
      FROM Commande_Produit
      GROUP BY no_commande);
      
SELECT no_commande
FROM (SELECT no_commande, COUNT(*) AS nombre_items
      FROM Commande_Produit
      GROUP BY no_commande)
WHERE nombre_items = (SELECT MAX(nombre_items)
                        FROM (SELECT no_commande, COUNT(*) AS nombre_items
                              FROM Commande_Produit
                              GROUP BY no_commande));
      
      

      
      
SELECT CMD.no_commande, CMD.date_commande, CMD.statut, CMD.no_client, Cl.nom, Cl.prenom
FROM Commande CMD
JOIN Client Cl ON CMD.no_client = Cl.no_client
WHERE CMD.no_commande IN (
    SELECT no_commande
    FROM (
        SELECT CP.no_commande, COUNT(*) AS nombre_items
        FROM Commande_Produit CP
        GROUP BY CP.no_commande
        HAVING COUNT(*) = (
            SELECT MAX(nombre_items)
            FROM (
                SELECT CP.no_commande, COUNT(*) AS nombre_items
                FROM Commande_Produit CP
                GROUP BY CP.no_commande
            )
        )
    )
);       
                              

  
  
  
  
  
  