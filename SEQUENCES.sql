--Creer la sequence pour la table produit
CREATE SEQUENCE seqProduit
increment by 1
start with 1000000000
minvalue 1000000000
maxvalue 9999999999;

--Creer la sequence pour la table vente
CREATE SEQUENCE seqVente
increment by 1
start with 1
minvalue 1
maxvalue 99999999999999999999;