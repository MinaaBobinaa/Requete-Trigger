## Section 1 :Liste des index

# Client
Nom de table : Client
Index :
* PRIMARY KEY (no_client)
Justification : L'index sur la colonne Code_Client pourrait être utile pour
 accélérer les recherches lors de l'identification d'un client ou pour la 
 recherche de commandes associées à un client spécifique.
 
# Commande
Nom de table : Commande
Index :
* PRIMARY KEY (no_commande)
Justification : L'index sur le numéro de commande faciliterait la recherche 
et l'accès rapide à une commande spécifique.
* Index (date_commande)
Justification : Un index sur la date de commande pourrait être pratique pour
 les recherches de commandes par date.
 
# Produit
Nom de table : Produit
Index :
* PRIMARY KEY (no_produit)
Justification : Un index sur la colonne Numéro_Produit peut accélérer les recherches lors de
 la consultation du catalogue des produits, notamment pour les recherches par numéro de produit.
* Index (description)
Justification : Un index sur la colonne Description pourrait être utile pour 
les recherches basées sur des mots-clés ou des préfixes de description.
 
# Livraison
Nom de table : Livraison
Index :
* PRIMARY KEY (no_livraison)
Justification : Un index sur le numéro de livraison peut aider à accélérer les recherches
 et consultations basées sur ce numéro spécifique.