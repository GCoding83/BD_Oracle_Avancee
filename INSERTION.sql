--Menu
SET SERVEROUTPUT ON
SET VERIFY OFF

CLEAR SCREEN
PROMPT INSERTION
PROMPT 1: Ajouter un produit
PROMPT 2: Ajouter un client
PROMPT 3: Ajouter une vente
PROMPT 4: Retour
ACCEPT selection PROMPT " Entrer option 1-4: "
SET TERM OFF
COLUMN script NEW_VALUE v_script
SELECT CASE '&selection '
WHEN '1' THEN 'PRODUITS.sql'
WHEN '2' THEN 'CLIENT.sql'
WHEN '3' THEN 'VENTECLIENT.sql'
WHEN '4' THEN 'MENU.sql'
ELSE 'INSERTION.sql'
END AS script
FROM dual;
SET TERM ON
/
@C:\CopieSQL2\Final\&v_script
SET VERIFY ON