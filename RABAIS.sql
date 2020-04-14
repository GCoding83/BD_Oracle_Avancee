
SET SERVEROUTPUT ON
SET VERIFY OFF


CREATE OR REPLACE PROCEDURE RABAIS(numeroClient IN VARCHAR2, dateDeVente IN DATE) IS

	varcode AGVENTECLIENT.numclient%TYPE:=numeroClient;
	vardate AGVENTECLIENT.datevente%TYPE:=dateDeVente;
	taux NUMBER(4, 2);
	entrees NUMBER;

	CURSOR Cur_rabais IS
	SELECT  numprod, prixvente, quantitevendue FROM AGVENTECLIENT
	WHERE numclient = varcode
	AND datevente = to_date(vardate, 'dd/mm/yyyy')
	FOR UPDATE OF prixvente;

	Le_curseur_rabais Cur_rabais%ROWTYPE;
	
	
BEGIN	
	SELECT count(*)
	INTO entrees
	FROM AGVENTECLIENT
	WHERE numclient = varcode
	AND datevente = vardate;

	IF entrees >= 1
	THEN
		--3. Traitement du curseur
		FOR Le_curseur_rabais IN Cur_rabais LOOP
			IF (Le_curseur_rabais.prixvente * Le_curseur_rabais.quantitevendue)  <= 100 THEN
				taux := 0.95;


			ELSIF (Le_curseur_rabais.prixvente * Le_curseur_rabais.quantitevendue) > 100 AND  (Le_curseur_rabais.prixvente * Le_curseur_rabais.quantiteVendue) <= 500 THEN
				taux := 0.90;

			ELSE
				taux := 0.85;

			END IF;

			UPDATE AGVENTECLIENT
			SET prixvente = Le_curseur_rabais.prixvente * taux
			WHERE CURRENT OF Cur_rabais;



		END LOOP;
		COMMIT;

	ELSE
		DBMS_OUTPUT.PUT_LINE('Aucune entree pour ce numero de client a cette date');
	END IF;

END;
/


--4. Affichage dU RABAIS

ACCEPT code_client PROMPT " Entrez le numero du client pour lequel vous souhaitez afficher les ventes "
ACCEPT date_vente PROMPT " Entrez la date de vente (format JJ/MM/AAAA): "

DECLARE
  --r_vente AGVENTECLIENT%ROWTYPE;
 	taxeVente number(8,2):=0;
	sommeSousTotal number(8,2):=0;
	sommeTotal number(8,2):=0;
	entrees2 number(8,2);


BEGIN 

	SELECT count(*)
	INTO entrees2
	FROM AGVENTECLIENT
	WHERE numclient = '&code_client'
	AND datevente = '&date_vente';

	IF entrees2 >= 1
	THEN
		DBMS_OUTPUT.PUT_LINE('*******************************');
		DBMS_OUTPUT.PUT_LINE('PRIX TOTAL POUR CLIENT ' || '&code_client' || ' le ' || '&date_vente' ||':');
		DBMS_OUTPUT.PUT_LINE('---');

		--Appliquer le rabais en utilisant la procedure rabais()
		rabais('&code_client', '&date_vente');

		--Afficher le resultat apres rabais
		sommeSousTotal := TAXEPACKAGE.coutvente('&code_client', '&date_vente');
		taxeVente := TAXEPACKAGE.taxe('&code_client', '&date_vente');
		sommeTotal := sommeSousTotal + taxeVente;


		DBMS_OUTPUT.PUT_LINE('Client #' || '&code_client');
		DBMS_OUTPUT.PUT_LINE('Date: ' || '&date_vente');
		DBMS_OUTPUT.PUT_LINE('***');
		DBMS_OUTPUT.PUT_LINE('SOUS-TOTAL: ' || sommeSousTotal ||'$');
		DBMS_OUTPUT.PUT_LINE('TAXES: ' || taxeVente||'$');	
		DBMS_OUTPUT.PUT_LINE('TOTAL: ' || sommeTotal||'$');
		DBMS_OUTPUT.PUT_LINE('');
		DBMS_OUTPUT.PUT_LINE('');


	
	ELSE
		FOR moncurseur IN (SELECT numclient, datevente, MIN(quantitevendue) 
			FROM AGVENTECLIENT
			GROUP BY numclient, datevente)
		LOOP
			--Afficher le resultat
			sommeSousTotal := TAXEPACKAGE.coutvente(moncurseur.numclient, moncurseur.datevente);
			taxeVente := TAXEPACKAGE.taxe(moncurseur.numclient, moncurseur.datevente);
			sommeTotal := sommeSousTotal + taxeVente;

			DBMS_OUTPUT.PUT_LINE('Client #' || moncurseur.numclient);
			DBMS_OUTPUT.PUT_LINE('Date: ' || moncurseur.datevente);
			DBMS_OUTPUT.PUT_LINE('***');
			DBMS_OUTPUT.PUT_LINE('SOUS-TOTAL: ' || sommeSousTotal||'$');
			DBMS_OUTPUT.PUT_LINE('TAXES: ' || taxeVente||'$');	
			DBMS_OUTPUT.PUT_LINE('TOTAL: ' || sommeTotal||'$');
			DBMS_OUTPUT.PUT_LINE('');
			DBMS_OUTPUT.PUT_LINE('');

		END LOOP;


	END IF;

END;
/

PAUSE Appuyer sur Enter pour continuer...
@C:\CopieSQL2\Final\MENU.sql