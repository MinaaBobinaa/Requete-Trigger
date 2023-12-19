CREATE TABLE Adresse(
id_adresse NUMBER (10,0) NOT NULL,
no_civique NUMBER (6,0) NOT NULL,
nom_rue VARCHAR(20) NOT NULL,
ville VARCHAR(20) NOT NULL,
pays VARCHAR(20) NOT NULL,
code_postal VARCHAR(8) NOT NULL,
PRIMARY KEY (id_adresse)
);

CREATE TABLE Client(
no_client NUMBER (5,0) NOT NULL,
nom VARCHAR(30) NOT NULL,
prenom VARCHAR(30) NOT NULL,
telephone VARCHAR(15) NOT NULL,
id_adresse NUMBER (10,0) NOT NULL,
PRIMARY KEY (no_client),
FOREIGN KEY (id_adresse) REFERENCES Adresse(id_adresse) 
);

CREATE TABLE Commande(
no_commande NUMBER (5,0) NOT NULL,
date_commande DATE NOT NULL,
statut VARCHAR(10) DEFAULT 'ENCOURS' NOT NULL,
no_client NUMBER (5,0) NOT NULL,
PRIMARY KEY (no_commande),
FOREIGN KEY (no_client) REFERENCES Client(no_client),
CONSTRAINT C1 CHECK (statut IN ('ENCOURS','ANNULEE','FERMEE'))
);

CREATE TABLE Fournisseur(
code_fournisseur NUMBER (5,0) NOT NULL,
raison_sociale VARCHAR(50) NOT NULL,
telephone VARCHAR(15) NOT NULL,
id_adresse NUMBER (10,0) NOT NULL,
PRIMARY KEY (code_fournisseur),
FOREIGN KEY (id_adresse) REFERENCES Adresse(id_adresse)
);

CREATE TABLE Produit(
no_produit NUMBER (5,0) NOT NULL,
description VARCHAR(50) NOT NULL,
date_inscription DATE DEFAULT SYSDATE NOT NULL, -- CHECK maybe idk? SYSDATE = system date (C2)
quantite_stock NUMBER(6,0) DEFAULT 0 NOT NULL,
quantite_seuil NUMBER(6,0) DEFAULT 0 NOT NULL,
code_fournisseur_prioritaire NUMBER(5,0) NOT NULL,
PRIMARY KEY (no_produit),
FOREIGN KEY (code_fournisseur_prioritaire) REFERENCES Fournisseur (code_fournisseur),
CONSTRAINT C3 CHECK (quantite_stock >= 0),
CONSTRAINT C4 CHECK (quantite_seuil >= 0)
);

CREATE TABLE Prix_Produit(
prix_unitaire NUMBER (8, 2) NOT NULL,
date_envigueur DATE NOT NULL,
no_produit NUMBER (5,0) NOT NULL,
PRIMARY KEY (prix_unitaire, date_envigueur, no_produit),
FOREIGN KEY (no_produit) REFERENCES Produit (no_produit)
);

CREATE TABLE Produit_Fournisseur(
no_produit NUMBER (5,0) NOT NULL,
code_fournisseur NUMBER (5,0) NOT NULL,
PRIMARY KEY (no_produit, code_fournisseur),
FOREIGN KEY (no_produit) REFERENCES Produit (no_produit),
FOREIGN KEY (code_fournisseur) REFERENCES Fournisseur (code_fournisseur)
);

CREATE TABLE Commande_Produit(
no_commande NUMBER (5,0) NOT NULL,
no_produit NUMBER (5,0) NOT NULL,
quantite_cmd NUMBER (6,0) NOT NULL,
PRIMARY KEY (no_commande, no_produit),
FOREIGN KEY (no_commande) REFERENCES Commande (no_commande),
FOREIGN KEY (no_produit) REFERENCES Produit (no_produit),
CONSTRAINT C5 CHECK (quantite_cmd > 0)
);

CREATE TABLE Livraison(
no_livraison NUMBER (5,0) NOT NULL,
date_livraison DATE NOT NULL,
PRIMARY KEY (no_livraison)
);

CREATE TABLE Livraison_Commande_Produit(
no_livraison NUMBER (5,0) NOT NULL,
no_commande NUMBER (5,0) NOT NULL,
no_produit NUMBER (5,0) NOT NULL,
quantite_livree NUMBER (6,0) NOT NULL,
PRIMARY KEY (no_livraison, no_commande, no_produit),
FOREIGN KEY (no_livraison) REFERENCES Livraison (no_livraison),
FOREIGN KEY (no_commande, no_produit) REFERENCES Commande_Produit (no_commande, no_produit),
CONSTRAINT C6 CHECK (quantite_livree > 0)
);

CREATE TABLE Approvisionnement(
no_produit NUMBER (5,0) NOT NULL,
code_fournisseur NUMBER (5,0) NOT NULL,
quantite_approvis NUMBER (6,0) NOT NULL,
date_cmd_approvis DATE NOT NULL,
statut VARCHAR(10) DEFAULT 'LIVRE' NOT NULL,
PRIMARY KEY (no_produit, code_fournisseur),
FOREIGN KEY (no_produit) REFERENCES Produit (no_produit),
FOREIGN KEY (code_fournisseur) REFERENCES Fournisseur (code_fournisseur),
CONSTRAINT C7 CHECK (quantite_approvis > 0),
CONSTRAINT C8 CHECK (statut IN ('ENCOURS','ANNULE','LIVRE')) --Autre (statut utile pour ne pas faire plus d'une commande)
);

CREATE TABLE Paiement(
id_paiement NUMBER (5,0) NOT NULL,
date_paiement DATE NOT NULL,
montant NUMBER (8, 2) NOT NULL,
type_paiement VARCHAR(20) NOT NULL,
no_cheque NUMBER (6,0) NULL,			
nom_banque VARCHAR(50) NULL,
no_carte_credit VARCHAR(16) NULL,
type_carte_credit VARCHAR(20) NULL,
no_livraison NUMBER (5,0) NOT NULL,
PRIMARY KEY (id_paiement),
FOREIGN KEY (no_livraison) REFERENCES Livraison (no_livraison),
CONSTRAINT C9 CHECK (type_paiement IN ('CASH','CHEQUE','CREDIT')),
CONSTRAINT C10 CHECK (type_carte_credit IN ('VISA','MASTERCARD','AMEX'))
);