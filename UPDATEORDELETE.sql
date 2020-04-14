--Menu
SET SERVEROUTPUT ON
SET VERIFY OFF

CLEAR SCREEN
PROMPT MENU MISE A JOUR ET SUPPRESSION
PROMPT 1: Mettre a jour un numero de client
PROMPT 2: Supprimer un produit
PROMPT 3: Retour
ACCEPT selection PROMPT " Entrer option 1-3: "
SET TERM OFF
COLUMN script NEW_VALUE v_script
SELECT CASE '&selection '
WHEN '1' THEN 'UPDATE.sql'
WHEN '2' THEN 'DELETE.sql'
WHEN '3' THEN 'MENU.sql'
ELSE 'INSERTION.sql'
END AS script
FROM dual;
SET TERM ON
/
@C:\CopieSQL2\Final\&v_script
SET VERIFY ON