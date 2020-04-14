SET SERVEROUTPUT ON 

CREATE OR REPLACE TRIGGER triggerProduitDelete 
AFTER DELETE ON AGPRODUIT 
FOR EACH ROW 

BEGIN     
	DBMS_OUTPUT.PUT_LINE('Suppression en cascade de : ' ||:OLD.numprod);     
	DELETE FROM AGVENTECLIENT WHERE numprod=:OLD.numprod; 

END; 
/ 

--Requete de suppression
SET SERVEROUTPUT ON

PROMPT "***********  Suppression Produit ************"
ACCEPT oldprod PROMPT " Entrez le code actuel du produit a supprimer: "

DECLARE entrees number;
BEGIN
	SELECT count(*)
	INTO entrees
	FROM AGPRODUIT
	WHERE numprod = '&oldprod';
	
	IF entrees = 1
	THEN
		DBMS_OUTPUT.PUT_LINE('Ajout des donnees supprimees dans la table AGPRODUITSUPPRIMES'); 
		INSERT INTO AGPRODUITSUPPRIMES(numprodsup, nomsup, quantitestocksup, prixsup)
		SELECT * FROM AGPRODUIT
		WHERE numprod = '&oldprod';
		COMMIT;

		DELETE FROM AGPRODUIT
		WHERE numprod = '&oldprod';


	ELSE
		DBMS_OUTPUT.PUT_LINE('Code inexistant');
	END IF;
	COMMIT;
END;
/

PAUSE Appuyer sur Enter pour continuer...
@C:\CopieSQL2\Final\UPDATEORDELETE.sql