--Menu
SET SERVEROUTPUT ON
SET VERIFY OFF

CLEAR SCREEN
PROMPT MENU PRINCIPAL
PROMPT 1: Inserer des donnees
PROMPT 2: Afficher la facturation
PROMPT 3: Faire un rabais
PROMPT 4: Mise a jour et Suppression
PROMPT 5: Quitter
ACCEPT selection PROMPT " Entrer option 1-5: "
SET TERM OFF
COLUMN script NEW_VALUE v_script
SELECT CASE '&selection'
WHEN '1' THEN 'INSERTION.sql'
WHEN '2' THEN 'FACTURE.sql'
WHEN '3' THEN 'RABAIS.sql'
WHEN '4' THEN 'UPDATEORDELETE.sql'
WHEN '5' THEN 'QUITTER.sql'
ELSE 'menu.sql'
END AS script
FROM dual;
SET TERM ON
/
@C:\CopieSQL2\Final\&v_script
SET VERIFY ON