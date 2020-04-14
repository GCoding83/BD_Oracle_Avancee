SET SERVEROUTPUT ON
SET VERIFY OFF


PROMPT "***********  Insertion de clients ************"
ACCEPT nom_prod PROMPT " Entrez le nom du produit: "
ACCEPT quantite_prod PROMPT " Entrez la quantite en stock du produit: "
ACCEPT prix_prod PROMPT " Entrez le prix du produit: "


BEGIN
	INSERT INTO AGPRODUIT VALUES
	('P'||seqProduit.nextval, '&nom_prod', '&quantite_prod', '&prix_prod');
	COMMIT;

EXCEPTION
	--Exception pour les doublons
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Il y a deja ce code de produit dans notre repertoire!');

END;
/

SET VERIFY ON

PAUSE Appuyer sur Enter pour continuer...
@C:\CopieSQL2\Final\INSERTION.sql