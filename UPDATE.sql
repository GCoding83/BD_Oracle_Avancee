SET SERVEROUTPUT ON 

CREATE OR REPLACE TRIGGER triggerClientUpdate 
AFTER UPDATE OF numclient ON AGCLIENT 
FOR EACH ROW 
BEGIN     
	DBMS_OUTPUT.PUT_LINE('Modification en cascade de : ' ||:NEW.numclient);     
	update AGVENTECLIENT set numclient=:NEW.numclient where numclient=:OLD.numclient;  
END; 
/ 

--Requete de mise ajour
SET SERVEROUTPUT ON

PROMPT "***********  Mise a jour Numero Client ************"
ACCEPT oldclient PROMPT " Entrez le code actuel du client a modifier: "
ACCEPT newclient PROMPT " Entrez le nouveau numero de client: "

DECLARE entrees number;
BEGIN
	SELECT count(*)
	INTO entrees
	FROM AGCLIENT
	WHERE numclient = '&oldclient';
	
	IF entrees = 1
	THEN
		UPDATE AGCLIENT
		SET numclient = '&newclient'
		WHERE numclient = '&oldclient';
	ELSE
		DBMS_OUTPUT.PUT_LINE('Code inexistant');
	END IF;
	COMMIT;
END;
/
	
PAUSE Appuyer sur Enter pour continuer...
@C:\CopieSQL2\Final\UPDATEORDELETE.sql