SET SERVEROUTPUT ON

--Debuter le code pour l'insertion d'une nouvelle vente
PROMPT "***********  Insertion dans la liste de ventes client ************"
ACCEPT num_cli PROMPT " Entrez le numero du client (au format AaaA0000): "
ACCEPT num_prod PROMPT " Entrez le numero du produit (au format P0000000000)): "
ACCEPT dateV PROMPT " Entrez la date de vente (au format jj/mm/aaaa): "
ACCEPT la_quantite PROMPT " Entrez la quantite vendue: "
ACCEPT prixV PROMPT " Entrez le prix de vente (ou laissez vide si vous garder le prix original du prix): "


DECLARE
	varprixProduit NUMBER(7,2);
	varQuantiteStock  NUMBER(5);

	err_code EXCEPTION;

	PRAGMA EXCEPTION_INIT(err_code, -2291);


BEGIN
	SELECT prix INTO varprixProduit FROM AGPRODUIT
	WHERE  numprod= '&num_prod';

	SELECT quantitestock INTO varQuantiteStock FROM AGPRODUIT
	WHERE  numprod= '&num_prod';


	--S'assurer qu'on a assez de produits en stock pour cette vente
	IF varQuantiteStock = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Vente annulee. Nous n''avons malheureusement plus ce produit en inventaire');
	ELSIF varQuantiteStock < '&la_quantite' THEN
		DBMS_OUTPUT.PUT_LINE('Vente annulee. La quantite demandee est superieure a la quantite disponible en stock');
	ELSE

		--Si aucune valeur n'est entree pour le prix de vente, alors utiliser le prix qui se trouve dans la table Produit
		IF '&prixV' IS NOT NULL THEN
			--S'assurer que le prix entre est egal ou superieur au prix qui se trouve dans la table Produit, sinon utilise le produit minimum permis.
			IF '&prixV' < varprixProduit THEN
				INSERT INTO AGVENTECLIENT VALUES
				(seqVente.nextval, '&num_cli','&num_prod', TO_DATE('&dateV', 'dd/mm/yyyy'), '&la_quantite', varprixProduit);
				DBMS_OUTPUT.PUT_LINE('Le prix de vente ne doit pas etre inferieur au prix minimum pre-determine pour ce produit. Nous avons donc utilise le prix minimum.');
				COMMIT;	
			ELSE
				INSERT INTO AGVENTECLIENT VALUES
				(seqVente.nextval, '&num_cli','&num_prod', TO_DATE('&dateV', 'dd/mm/yyyy'), '&la_quantite', '&prixV');
				COMMIT;
			END IF;
		ELSE
			INSERT INTO AGVENTECLIENT VALUES
			(seqVente.nextval, '&num_cli','&num_prod', TO_DATE('&dateV', 'dd/mm/yyyy'), '&la_quantite', varprixProduit);
			COMMIT;	
		END IF;


		--Mettre a jour la quantite en stock apres la vente
		UPDATE AGPRODUIT 
		SET quantitestock = quantitestock - '&la_quantite'
		WHERE  numprod= '&num_prod';



	END IF;



EXCEPTION
	--Exception pour les doublons
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Il y a deja ce code dans notre repertoire!');
	WHEN err_code THEN
		DBMS_OUTPUT.PUT_LINE('Le code que avez entre n''existe pas!');
	--WHEN OTHERS THEN
	--	DBMS_OUTPUT.PUT_LINE('Une erreur s''est produite!');
END;
/

PAUSE Appuyer sur Enter pour continuer...
@C:\CopieSQL2\Final\INSERTION.sql