

--Creation tables AGCLIENT, AGPRODUIT et AGVENTECLIENT

BEGIN

	--Creer table AGCLIENT
	DECLARE
		table_client EXCEPTION;
		PRAGMA EXCEPTION_INIT(table_client, -955);

	BEGIN
		EXECUTE IMMEDIATE'create table AGCLIENT(numclient varchar2(8) primary key, prenomclient varchar2(50) NOT NULL, nomclient varchar2(50) NOT NULL, telephone varchar2(15) NOT NULL, norue number(5), nomrue varchar2(50), ville varchar2(50), province varchar2(30), codepostal varchar2(7), pays varchar2(20))';	
	EXCEPTION
		WHEN table_client THEN
			DBMS_OUTPUT.PUT_LINE('La table AGCLIENT existe deja!');
	
	END;

	--Creer table AGPRODUIT
	DECLARE
		table_produit EXCEPTION;
		PRAGMA EXCEPTION_INIT(table_produit, -955);
	BEGIN
		EXECUTE IMMEDIATE'create table AGPRODUIT(numprod varchar2(11) primary key, nom varchar2(30) NOT NULL, quantitestock number(5) NOT NULL, prix number(6,2) NOT NULL)';

	EXCEPTION
		WHEN table_produit THEN
			DBMS_OUTPUT.PUT_LINE('La table AGPRODUIT existe deja!');

	END;

	--Creer table AGVENTECLIENT
	DECLARE
		table_venteclient EXCEPTION;
		PRAGMA EXCEPTION_INIT(table_venteclient, -955);
	BEGIN
		EXECUTE IMMEDIATE'create table AGVENTECLIENT(
						codevente number(20) primary key, 
						numclient varchar2(8) constraint FK_CLIENT references AGCLIENT (numclient), 
						numprod varchar2(11) constraint FK_PRODUIT references AGPRODUIT (numprod), 
						datevente date NOT NULL, 
						quantitevendue number(4) NOT NULL,
						prixvente number(6,2) NOT NULL)';
 

	EXCEPTION
		WHEN table_venteclient THEN
			DBMS_OUTPUT.PUT_LINE('La table AGVENTECLIENT existe deja!');

	END;

	--Creer table AGPRODUITSUPPRIMES
	DECLARE
		table_produitSup EXCEPTION;
		PRAGMA EXCEPTION_INIT(table_produitSup, -955);
	BEGIN
		EXECUTE IMMEDIATE'create table AGPRODUITSUPPRIMES(numprodSup varchar2(11) primary key, nomSup varchar2(30) NOT NULL, quantitestockSup number(5) NOT NULL, prixSup number(6,2) NOT NULL)';

	EXCEPTION
		WHEN table_produitSup THEN
			DBMS_OUTPUT.PUT_LINE('La table AGPRODUIT existe deja!');

	END;

END;
/








