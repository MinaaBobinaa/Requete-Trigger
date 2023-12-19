# Initialisation de la Base de Données

Pour configurer la base de données avec les données et les contraintes nécessaires, suivez attentivement ces étapes.

## Étape 1 : Création des Tables

Le script `Creation.sql` contient les instructions pour créer les tables de la base
de données. Pour une approche prudente, exécutez chaque création de table séparément.

## Étape 2 : Ajout des Déclencheurs
Les déclencheurs sont définis dans le script `Triggers.sql` pour effectuer des 
actions spécifiques lors d'événements dans la base de données. Pour une sécurité
accrue, exécutez chaque déclencheur séparément.

Exécutez chaque déclencheur individuellement pour assurer l'intégrité des actions 
déclenchées.

## Étape 3 : Insertion des Données Initiales
Le script `Insertion.sql` contient les instructions pour insérer des données initiales 
dans les tables créées. Comme précédemment, exécutez ces instructions une par
une pour chaque table.

Procédez avec précaution en exécutant chaque instruction d'insertion de données
pour garantir leur ajout correct dans les tables correspondantes.