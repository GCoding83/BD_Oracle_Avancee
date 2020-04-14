--Packages qui seront utilisés pour l'affichage de la facture

--En-tete du package
CREATE OR REPLACE PACKAGE TAXEPACKAGE AS
	
	FUNCTION COUTVENTE(numeroClient IN VARCHAR2, dateV IN DATE) 
	RETURN NUMBER;

	FUNCTION TAXE(numeroClient IN VARCHAR2, dateV IN DATE) 
	RETURN NUMBER;

END TAXEPACKAGE;
/

--Corps du package
CREATE OR REPLACE PACKAGE BODY TAXEPACKAGE AS 
	
	--Fonction COUTVENTE qui calcule la somme totale des achats avant taxes pour un client a une date precise
	FUNCTION COUTVENTE(numeroClient IN VARCHAR2, dateV IN DATE) 
	RETURN NUMBER AS

	CURSOR c_coutvente IS  
		SELECT  prixvente, quantitevendue FROM AGVENTECLIENT
		WHERE numclient = numeroClient
		AND datevente = dateV;

	sommeSousTotal NUMBER(8,2):=0;

	r_coutvente c_coutvente%ROWTYPE;
	
	BEGIN
		FOR r_coutvente IN c_coutvente LOOP
			sommeSousTotal := sommeSousTotal + (r_coutvente.prixvente * r_coutvente.quantitevendue);
		END LOOP;

		RETURN(sommeSousTotal);

	END COUTVENTE;


	--Fonction TAXES qui calcule la somme totale des achats apres taxes pour un client a une date precise
	FUNCTION TAXE(numeroClient IN VARCHAR2, dateV IN DATE) 
	RETURN NUMBER AS
	BEGIN
		
		RETURN(coutvente(numeroClient, dateV) * 0.15);
			
	END TAXE;

END TAXEPACKAGE; 
/


--Affichage de la facture

SET SERVEROUTPUT ON
SET VERIFY OFF

ACCEPT code_client PROMPT " Entrez le numero du client pour lequel vous souhaitez afficher la facture: "
ACCEPT date_vente PROMPT " Entrez la date de vente (format JJ/MM/AAAA): "


DECLARE
	entrees number;
	varnumcli AGVENTECLIENT.numclient%TYPE:='&code_client';
	vardate AGVENTECLIENT.datevente%TYPE:='&date_vente';

	enteteLue NUMBER:=0;
	taxeVente number:=0;
	sommeSousTotal number:=0;
	sommeTotal number:=0;

	CURSOR Cur_ventes IS SELECT c.numclient, c.prenomclient, c.nomclient, c.telephone, c.norue, c.nomrue, c.ville, c.province, c.pays, c.codepostal, 
	v.numprod, v.datevente, v.quantitevendue, p.nom
	FROM AGCLIENT c, AGPRODUIT p, AGVENTECLIENT v
	WHERE v.numclient = c.numclient
	AND v.numprod = p.numprod
	AND v.numclient = varnumcli
	AND v.datevente = vardate;

	Le_curseur_ventes Cur_ventes%ROWTYPE;


BEGIN
	SELECT count(*)
	INTO entrees
	FROM AGVENTECLIENT
	WHERE numclient = '&code_client'
	AND datevente = '&date_vente';

	IF entrees >= 1
	THEN
		FOR Le_curseur_ventes IN Cur_ventes LOOP

			--Ecrire l'en-tete et les informations du client seulement une fois. 
			IF enteteLue = 0
			THEN

				DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
				DBMS_OUTPUT.PUT_LINE('----------------------FACTURE-----------------------');
				DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
				DBMS_OUTPUT.PUT_LINE('');
				DBMS_OUTPUT.PUT_LINE(Le_curseur_ventes.datevente);
				DBMS_OUTPUT.PUT_LINE(Le_curseur_ventes.prenomclient || ' ' || Le_curseur_ventes.nomclient || ': '||Le_curseur_ventes.norue||' '||Le_curseur_ventes.nomrue||', '||Le_curseur_ventes.ville||', '||Le_curseur_ventes.province||', '||Le_curseur_ventes.pays||', '||Le_curseur_ventes.codepostal||', '||Le_curseur_ventes.telephone);		

				enteteLue := enteteLue + 1;
				DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

			END IF;

			DBMS_OUTPUT.PUT_LINE(Le_curseur_ventes.quantitevendue || ' ' || Le_curseur_ventes.nom);

		END LOOP;
		
		sommeSousTotal := TAXEPACKAGE.coutvente(varnumcli, vardate);
		taxeVente := TAXEPACKAGE.taxe(varnumcli, vardate);
		sommeTotal := sommeSousTotal + taxeVente;

		DBMS_OUTPUT.PUT_LINE('');
		DBMS_OUTPUT.PUT_LINE('SOUS-TOTAL: ' || sommeSousTotal || '$');
		DBMS_OUTPUT.PUT_LINE('TAXES: ' || taxeVente || '$');
		DBMS_OUTPUT.PUT_LINE('TOTAL: ' || sommeTotal || '$');


	ELSE
		DBMS_OUTPUT.PUT_LINE('Numero de client inexistant');
	END IF;
END;
/
SET VERIFY ON




PAUSE Appuyer sur Enter pour continuer...
@C:\CopieSQL2\Final\MENU.sql