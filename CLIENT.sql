SET SERVEROUTPUT ON
SET VERIFY OFF

PROMPT "***********  Insertion de clients ************"
ACCEPT prenom_client PROMPT " Entrez le prenom du client: "
ACCEPT nom_client PROMPT " Entrez le nom du client: "
ACCEPT telephone_client PROMPT " Entrez le numero de telephone du client (format: (000)000-0000): "
ACCEPT norue_client PROMPT " Entrez le numero de rue du client: "
ACCEPT nomrue_client PROMPT " Entrez le nom de rue du client: "
ACCEPT ville PROMPT " Entrez la ville du client: "
ACCEPT province PROMPT " Entrez la province du client: "
ACCEPT codepostal PROMPT " Entrez le code postal du client (format: (A1A-1A1)): "
ACCEPT pays PROMPT " Entrez le pays du client: "

DECLARE
	vartel VARCHAR2(30):='&telephone_client';
	varpostal VARCHAR2(10):='&codepostal';
	varville VARCHAR2(50):='&ville';

BEGIN
	--expression reguliere pour code postal

	IF REGEXP_LIKE(varpostal, '^[ABCEGHJKLMNPRSTVXY][0-9][ABCEGHJKLMNPRSTVWXYZ][-]?[0-9][ABCEGHJKLMNPRSTVWXYZ][0-9]$') = false
	THEN
		dbms_output.put_line('Veuillez entrer un code postal valide, au format H1H-1H1.');

	ELSE
		--expression reguliere pour telephone
		IF REGEXP_LIKE(vartel,'^\(\d{3}\)\d{3}-\d{4}$') = false 
		THEN
			--Verifier si l'usager a simplement omis le code regional
			IF REGEXP_LIKE(vartel,'^\d{3}-\d{4}$') = true
			THEN 
				dbms_output.put_line('Aucun code regional!');


				--Ajuster pour Montreal
				IF varville = 'Montreal'
				THEN
					dbms_output.put_line('Montreal!');
					vartel := '(514)'||vartel;
					dbms_output.put_line(vartel);

				--Ajuster pour Longueuil ou Laval
				ELSIF varville = 'Longueuil' OR varville = 'Laval'
				THEN
				    dbms_output.put_line('Laval ou Longueuil!');
					vartel := '(450)'||vartel;
					dbms_output.put_line(vartel);

				--Ajuster pour les autres
				ELSE
					dbms_output.put_line('Autre!');
					vartel := '(000)'||vartel;
					dbms_output.put_line(vartel);

				END IF;

			
			--Si le numero est carrement absurde, alors:
			ELSE

				dbms_output.put_line('Veuillez entrer un format de telephone valide, au format (000)000-0000');

			END IF;

		--Si le formattage du telephone est bon
		ELSE
			INSERT INTO AGCLIENT VALUES
			(substr('&nom_client',0,3)|| substr('&prenom_client',0,1)|| substr('&telephone_client',10,14), '&prenom_client', '&nom_client', '&telephone_client', '&norue_client', '&nomrue_client', '&ville', '&province', '&codepostal', '&pays');
			COMMIT;
		END IF;
	END IF;


EXCEPTION
	--Exception pour les doublons
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Il y a deja ce code de client dans notre repertoire!');
END;
/

SET VERIFY ON

PAUSE Appuyer sur Enter pour continuer...
@C:\CopieSQL2\Final\INSERTION.sql
