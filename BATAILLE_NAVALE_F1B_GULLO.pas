{
	ALGO BATAILLE_NAVALE
//BUT:Le jeu de la bataille Navale
//ENTREE:2 coorDOnne
//SORTIE:affiche un terrain avec une flotte genere aleatoirement

CONST
	MAX = 10  					//taille de la map
	BOATMAX = 5  				//nombre de boat MAX=8
	TAILLEMAX = 6  				//taille des boats MAX=10

Type
	cellule = ENREGISTREMENT
		ligne : ENTIER
		colonne : ENTIER
	FINENREGISTREMENT
	
Type
	boat = ENREGISTREMENT
		n : cellule
		taille : ENTIER
		nom : CHAINE
	FINENREGISTREMENT
	
Type
	flotte = ENREGISTREMENT
		n1 : boat
	FINENREGISTREMENT
	
Type	
	marge = ENREGISTREMENT
		x : ENTIER
		y : ENTIER
	FINENREGISTREMENT

Type
	TabCellule = TABLEAU [1..100] DE cellule
	TabBoat = TABLEAU [1..100] DE boat
	TabFlotte = TABLEAU [1..BOATMAX&1..100] DE flotte
	TabNom = TABLEAU [1..8] DE CHAINE
	Tab = TABLEAU [1..20] DE ENTIER
	
//BUT:		Initialisation a 0 des position des cellules
//ENTREE:	1 tableau d'entier& 1 entier& 1 constante
//SORTIE:	1 tableau d'entier set a 0

PROCEDURE IniTabCellule(VAR PosCellule,CelluleAuche:TabCellule)

VAR
	i : ENTIER
	
DEBUT
	POUR i <- 1 A MAX FAIRE
		PosCellule[i].colonne <- 0
		PosCellule[i].ligne <- 0
		CelluleAuche[i].colonne <- 0
		CelluleAuche[i].ligne <- 0
	FINPOUR
																										

//BUT:		Initialisation a 0 de la flotte
//ENTREE:	2 tableau avec 1 sous type TabFlotte& et 1 sous type TabBoat
//SORTIE:	2 tableau avec valeur 0

PROCEDURE IniTabFlotte(VAR Bateau:TabBoat  VAR Ensemble:TabFlotte)

VAR
	i : ENTIER
	j : ENTIER

DEBUT
	POUR i DE 1 A MAX FAIRE
		Bateau[i].n.colonne <- 0
		Bateau[i].n.ligne <- 0
		POUR j DE 1 A BOATMAX FAIRE
			Ensemble[j&i].n1.n.colonne <- 0
			Ensemble[j&i].n1.n.ligne <- 0
		FINPOUR
	FINPOUR
FIN
	
	
//BUT:		Affiche la map du jeu
//ENTREE:	3 entier
//SORTIE:	affichage

PROCEDURE AfficheMap()

VAR
	cpt : ENTIER
	i : ENTIER
	j : ENTIER

DEBUT
		cpt<-7
	POUR i<-1 A MAX FAIRE		//Afficher 1-10 horizontal
		GoAXY(cpt&5)
		ECRIRE i
		cpt<-cpt+4
	FINPOUR
	
	
	cpt<-8
	POUR i DE 1 A MAX FAIRE		//Affiche 1-10 vertical
		POUR j DE 1 A MAX*3 FAIRE
			GoAXY(3&cpt)
			ECRIRE'Chr(i+64)'
		FIN
		cpt <- cpt+3
	FINPOUR
		
FIN

//BUT:		effacer le texte
//ENTREE:	2 entier
//SORTIE:	affichage

PROCEDURE Clrtxt2()

VAR
	
	i : ENTIER
	j : ENTIER
DEBUT

	POUR i DE 13 A 29 FAIRE
		POUR j DE 49 A 71 FAIRE
			GoAXY(j&i)
			ECRIRE' '
		FINPOUR
	FINPOUR

FIN

//BUT:		effacer le texte
//ENTREE:	2 entier
//SORTIE:	affichage

PROCEDURE Clrtxt3()

VAR
	i : ENTIER
	j : ENTIER
DEBUT

	POUR i DE 34 A 35 FAIRE
		POUR j DE 49 A 85 FAIRE
			GoAXY(j&i)
			ECRIRE' '
		FINPOUR
	FINPOUR

FIN

//BUT:		Test les cases suivante dans la direction X pour chaque taille d'un bateau
//ENTREE:	1 tableau type TabBoat  1 tableay type TabCellule 5 entier& 2 BOOLEEN
//SORTIE:	1 BOOLEEN

FONCTION TestCaseLigne(Bateau:TabBoat ; PosCellule:TabCellule x,y,i:ENTIER) DE BOOLEEN

VAR
	j : ENTIER
	test : BOOLEEN
	test2 : BOOLEEN
	
DEBUT
	test <- FAUX
	test2 <- VRAI
	POUR j DE 1 A Bateau[i].taille FAIRE			
	
	// cellule bateau y <> position y ET cellule bateau x <>  position x + j
		
		SI (Bateau[j].n.colonne<>PosCellule[y].colonne) ET (Bateau[j].n.ligne<>PosCellule[(x+(j-1))].ligne) ALORS
			test <- VRAI 	
		FINSI
		SI test = FAUX ALORS
			test2 <- FAUX
		FINSI
	FINPOUR
	
	SI test2 = FAUX ALORS
		test <- FAUX
	FINSI
	
TestCaseLigne<-test

FIN

//BUT:		Test les cases suivante dans la direction y pour chaque taille d'un bateau
//ENTREE:	1 tableau type TabBoat, 1 tableay type TabCellule,5 entier, 2 BOOLEEN
//SORTIE:	1 BOOLEEN

FONCTION TestCaseColonne(Bateau:TabBoat ; PosCellule:TabCellule x ,y,i:ENTIER):BOOLEEN

VAR
	j:ENTIER
	test : BOOLEEN
	test2 : BOOLEEN

DEBUT

	test <- FAUX 	
	POUR j DE 1 A Bateau[i].taille FAIRE
		SI (Bateau[j].n.colonne<>PosCellule[(y+(j-1))].colonne) ET (Bateau[j].n.ligne<>PosCellule[x].ligne) ALORS
			test <- VRAI 	
		FINSI		
		SI test = FAUX ALORS
			test2 <- FAUX
		FINSI
	FINPOUR
	
	SI test2 = FAUX ALORS
		test <- FAUX
	FINSI

	TestCaseColonne <- test

FIN

//BUT:		Test pour que les bateaux de se superpose pas
//ENTREE:	1 tableau type TabBoat, 1 tableau type TabFlotte, 4 entier, 1 booleen
//SORTIE:	1 BOOLEEN

FONCTION TestCase(Bateau:TabBoat ; Ensemble:TabFlotte):BOOLEEN

VAR
	i : ENTIER
	j : ENTIER
	l : ENTIER
	k : ENTIER
	test : BOOLEEN

DEBUT
	test <- VRAI
	
	POUR i DE 1 A BOATMAX FAIRE
		POUR j DE 1 A BOATMAX FAIRE
			POUR k DE 1 A Bateau[i].taille FAIRE
				POUR l DE 1 A Bateau[i].taille FAIRE
					SI (Ensemble[i&k].n1.n.ligne=Ensemble[j&l].n1.n.ligne) ET (Ensemble[i&k].n1.n.colonne=Ensemble[j&l].n1.n.colonne) ET (j<>i) ALORS
						test <- FAUX
					FINSI
				FINPOUR
			FINPOUR
		FINPOUR
	FINPOUR
	
	TestCase <- test
FIN

//BUT:		converti les chaine (caractere) en entier (Ex:'10'>10)
//ENTREE:	1 CHAINE
//SORTIE:	1 entier

FONCTION convertisseur1(car:CHAINE):ENTIER

DEBUT
		SI longueur(car) = 1 ALORS
			SI(ord(car[1]) >= 48) ET (ord(car[1]) <= 57) ALORS
		 		convertisseur1<-ord(car[1])-48
			SINON
				convertisseur1 <- 0
			FINSI
		FINSI
			SI longueur(car)=2 ALORS
				SI (ord(car[1]) = 49) ET (ord(car[2]) = 48)ALORS
					convertisseur1 <- 10
				SINON
					convertisseur1 <- 0
				FINSI
		FINSI
			
			
FIN

//BUT:		convertisseur pour les char
//ENTREE:	1 caractere
//SORTIE:	1 entier

FONCTION convertisseur2(car:CHAR):ENTIER

DEBUT
	SI(ord(car) >= 97 ) ET (ord(car) < 97+MAX) ALORS
		convertisseur2 <- ord(car)-96
	SINON
		convertisseur2 <- 11
	FINSI
FIN

//BUT:		Test Si les coord entrer existe
//ENTREE:	1 tableau type TabFlotte& 1 tableau type TabBoat& 1 tableau type TabCellule& 3 entier
//SORTIE:	1 BOOLEEN

FONCTION trouver(Ensemble:TabFlotte ; Bateau:TabBoat ; PosCellule:TabCellule x,y:ENTIER VAR nbr:ENTIER):BOOLEEN

VAR
	i : ENTIER
	j : ENTIER
	test : BOOLEEN

DEBUT
	test <- FAUX
	POUR i DE 1 A BOATMAX FAIRE
		POUR j DE 1 A Bateau[i].taille FAIRE
			SI (Ensemble[i&j].n1.n.colonne=PosCellule[y].colonne) ET (Ensemble[i&j].n1.n.ligne=PosCellule[x].ligne) ALORS
				test <- VRAI
				nbr <- i 														//Si la position entree = a la position du bateau
			FINSI
		FINPOUR
	FINPOUR
	
	trouver <- test
FIN

//BUT:		Test si tout les bateau on coule
//ENTREE:	1 tableau type Tab
//SORTIE:	1 BOOLEEN

FONCTION final(Nb:Tab):BOOLEEN

VAR
	i : ENTIER
	cpt : ENTIER
	test : BOOLEEN
	
DEBUT
	test <- FAUX
	cpt <- 0
	POUR i DE 1 A BOATMAX FAIRE
		SI Nb[i]<1 ALORS
			cpt <- cpt+1
			SI cpt = BOATMAX ALORS
				test<-VRAI
			FINSI
		FINSI
	FINPOUR
	
	final <- test

FIN

//BUT:	Affecte les valeur x y a Pos
//ENTREE:	1 tableau type PosCellule, 2 entier
//SORTIE:	Tableau N valeur

PROCEDURE CreateCellule(VAR PosCellule:TabCellule)

VAR
	cpt : ENTIER
	i : ENTIER
	
DEBUT	
	
	cpt <- 7
	POUR i DE 1 A MAX FAIRE						//Valeur des cases y
		PosCellule[i].ligne <- cpt
		cpt<-cpt+4
	FINPOUR

	cpt<-8
	POUR i DE 1 A MAX FAIRE						//Valeur des cases x
		PosCellule[i].colonne <- cpt
		cpt <- cpt+3
	FINPOUR
FIN

//BUT:		Affecte les valeur des cellules a bateau
//ENTREE:	1 tableau type TabCellule, 1 tableau type TabBoat, 4 entier, 1 BOOLEEN
//SORTIE:	1 tableau N cellule

PROCEDURE Createboat (PosCellule:TabCellule; VAR Bateau:TabBoat i:ENTIER)

VAR
	j : ENTIER
	x : ENTIER
	y : ENTIER
	randdirection : ENTIER
	test : BOOLEEN

DEBUT

	REPETER
	Randomize
			
		randDirection <- Random(2)+1				 					//Pour choisir le positionnement au hasard
	
		cas randDirection PARMIS
			CAS1 :	DEBUT												//Positionnement bateau vertical
		
						REPETE
							x <- Random(MAX)+1 							//positionnement au hasard
							y<-Random(MAX)+1
						JUSQUA (y<=MAX-Bateau[i].taille)
						FINREPETER
					
						test<-TestCaseColonne(Bateau&PosCellule&x&y&i) 	//test si les cases sont vide pour le bateau
					
						SI test = VRAI ALORS					
							POUR j de 1 A Bateau[i].taille FAIRE						
								Bateau[j].n.colonne <- PosCellule[(y+j)-1].colonne
								Bateau[j].n.ligne <- PosCellule[x].ligne
							FINPOUR						
						FINSI					
					FIN
			
			CAS2 :	DEBUT												//Positionnement horizontal
			
					REPETER
						x<-Random(MAX)+1 								//positionnement au hasard
						y<-Random(MAX)+1
					JUSQUA (x <= MAX-Bateau[i].taille)
					
					test <- TestCaseLigne(Bateau&PosCellule&x&y&i) 		//test si les cases sont vide pour le bateau
					SI test = VRAI ALORS
						POUR j<-1 A Bateau[i].taille FAIRE
							Bateau[j].n.colonne <- PosCellule[y].colonne
							Bateau[j].n.ligne <- PosCellule[(x+j)-1].ligne
						FINPOUR
					FINSI
				FIN
		FINCAS
	JUSQUA (test=VRAI)

FIN

//BUT:	definir la taille d'un bateau
//ENTREE:	1 tableau type TabBoat et un tableau typea Tab et  2 entier
//SORTIE:	un tableau type Tab avec Nbr entier

PROCEDURE TailleBateau(VAR Bateau:TabBoat ; VAR tailleB:Tab)

VAR
	i : ENTIER
	nbr : ENTIER
	
DEBUT
	
	Randomize
	
	POUR i DE 1 A BOATMAX FAIRE
		REPETER
			nbr <- Random(TAILLEMAX)+1
		JUSQUA nbr > 1
		
		Bateau[i].taille <- nbr
		tailleB[i] <- Bateau[i].taille
	FINPOUR

FIN

//BUT:	Affecte les valeurs des boat a la flotte
//ENTREE:	1 tableau type TabBoat et 1 tableau type TabCellule et 1 tableau type Ensemble et 2 entier et 1 BOOLEEN
//SORTIE:	Tableau type TabFlotte avec N valeur entier

PROCEDURE CreateFlotte (Bateau:TabBoat ; PosCellule:TabCellule ; VAR Ensemble:TabFlotte)

VAR
	i : ENTIER
	j : ENTIER
	test : BOOLEEN
	
DEBUT
	REPETER
		IniTabFlotte(Bateau&Ensemble)
		
		POUR i DE 1 A BOATMAX FAIRE
			Createboat(PosCellule&Bateau&i)
			POUR j DE 1 A Bateau[i].taille FAIRE	
					Ensemble[i&j].n1.n.ligne <- Bateau[j].n.ligne
					Ensemble[i&j].n1.n.colonne <- Bateau[j].n.colonne
			FINPOUR
		FINPOUR

		test <- TestCase(Bateau,Ensemble)
	JUSQUA (test=VRAI)

FIN
	
	//DEBUT programme principal
VAR
	
	PosCellule : TabCellule
	Celluletouche : TabCellule
	bateau : TabBoat
	Nom : TabNom
	tailleB : Tab
	margin : marge
	Ensemble : TabFlotte
	x1 : ENTIER
	y1 : ENTIER
	i : ENTIER
	k : ENTIER
	j : ENTIER
	nbr : ENTIER
	y : CHAR
	x : CHAINE
	test : BOOLEEN
	
	
DEBUT	
	
	IniTabCellule(PosCellule&CelluleAuche) 														// Init des cellules

	AfficheMap() 																				//affiche le terrain
	
	CreateCellule(PosCellule) 																	//créer les cellules

	TailleBateau(Bateau&tailleB) 																//defini le nombre de cellule des bateau
	
	CreateFlotte(Bateau&PosCellule&Ensemble) 													//creer la flotte de bateau
	
	
	//Affiche la flotte
	{ POUR j DE 1 A BOATMAX FAIRE
		 POUR k DE 1 A Bateau[j].taille FAIRE
			GoAXY(Ensemble[j&k].n1.n.ligne&Ensemble[j&k].n1.n.colonne)
			ECRIRE j
		 FINPOUR
	 FINPOUR
	
	margin.x <- (MAX*4)+10
	margin.y <- MAX
	
					//AfficherFlotte(Bateau&margin&tailleB)
	
	REPETER															//boucle FIN

			REPETER										//boucle coord x
				GoAXY(margin.x & margin.y+13)
				ECRIRE 'Coordonne x ? 1-10'
				GoAXY(margin.x & margin.y+14)
				ECRIRE '.'
				LIRE x
				x1 <- convertisseur1(x)
				SI (x1=0) ALORS
					POUR i DE margin.x A margin.x+10 FAIRE
						GoAXY(i&margin.y+14)
						ECRIRE' '
					FINPOUR
				FINSI
			JUSQUA (x1 <> 0) ET (x <> '')
			clrtxt3
			
			REPETER									//boucle coord y
				GoAXY(margin.x & margin.y+15)
				ECRIRE 'Coordonne y ? a-j'
				GoAXY(margin.x & margin.y+16)
				ECRIRE '.'
				LIRE y
				y <- LowerCase(y)
				y1 <- convertisseur2(y)
				SI (y1=11) ALORS
					POUR i DE margin.x A margin.x+10 FAIRE
						GoAXY(i & margin.y+16)
						ECRIRE' '
					FINPOUR
				FINSI
			JUSQUA (y1 <> 11)
		
					//si les valeur corresponde
		test <- trouver(Ensemble & Bateau & PosCellule & x1 & y1 & nbr)
		SI test=VRAI ALORS															//si les cellule touche est different de la cellule donne
			SI (CelluleAuche[nbr].ligne <> PosCellule[x1].ligne) OU (CelluleAuche[nbr].colonne <> PosCellule[y1].colonne) ALORS				
				SI (tailleB[nbr]>0) ALORS
					CelluleAuche[nbr].ligne <- PosCellule[x1].ligne
					CelluleAuche[nbr].colonne <- PosCellule[y1].colonne
					GoAXY(PosCellule[x1].ligne&PosCellule[y1].colonne)
					ECRIRE'X'
					GoAXY(margin.x & margin.y+24)
					ECRIRE(Nom[nbr] & ' Aucher !')
					tailleB[nbr] <- tailleB[nbr]-1
				FINSI 			
				SI tailleB[nbr] <= 0 ALORS											//si boat detruit
					GoAXY(margin.x&margin.y+25)
					ECRIRE 'vous avez coule un boat !'
					POUR i DE 1 A Bateau[nbr].taille FAIRE
						GoAXY(Ensemble[nbr&i].n1.n.ligne & Ensemble[nbr&i].n1.n.colonne)
						ECRIRE 'C'
					FINPOUR
					tailleB[nbr] <- (-1)
				FINSI
			FINSI
		SINONSI
			GoAXY(PosCellule[x1].ligne&PosCellule[y1].colonne)
			ECRIRE '0'
		FINSI
		clrtxt2			
		test<-FINal(tailleB)					 // test si tout les bateau detruit
	JUSQUA test=VRAI 							//FIN du jeu
	delay(2000)
	
	clrtxt3
	
	GoAXY(margin.x & margin.y+24)
	ECRIRE 'FIN de la partie '
FIN.}

program Bataille_navale;

uses crt;

CONST
	MAX = 10 ;					
	BOATMAX = 5 ;				
	TAILLEMAX = 6 ;

//BEGIN type
Type
	cellule = record
		ligne : INTEGER ;
		colonne : INTEGER ;
	END ;

Type
	boat = record
		n : cellule ;
		taille : INTEGER ;
		nom : STRING ;
	END ;

Type
	flotte = record
		n1 : boat ;
	END ;

Type
	marge = record
		x : INTEGER ;
		y : INTEGER ;
	END ;

Type
	TabCellule = array [1..100] of cellule ;
	TabBoat = array[1..100] of boat ;
	TabFlotte = array[1..BOATMAX,1..100] of flotte ;
	TabNom = array[1..8] of STRING ;
	Tab = array[1..20] of INTEGER ;

PROCEDURE IniTabCellule(VAR PosCellule,CelluleTouche:TabCellule);

VAR
	i : INTEGER ;

BEGIN
	FOR i := 1 TO MAX DO
	BEGIN
		PosCellule[i].colonne := 0 ;
		PosCellule[i].ligne := 0 ;
		CelluleTouche[i].colonne := 0 ;
		CelluleTouche[i].ligne := 0 ;
	END;
END;

PROCEDURE IniTabFlotte(VAR Bateau:TabBoat; VAR Ensemble:TabFlotte);
VAR
	i : INTEGER ;
	j : INTEGER ;
BEGIN
	FOR i:=1 TO MAX DO
	BEGIN
		Bateau[i].n.colonne:=0;
		Bateau[i].n.ligne:=0;
		FOR j:=1 TO BOATMAX DO
		BEGIN
			Ensemble[j,i].n1.n.colonne:=0;
			Ensemble[j,i].n1.n.ligne:=0;
		END;
	END;
END;

PROCEDURE AfficheMap();
VAR
	cpt,i,j:INTEGER;

BEGIN
		cpt:=7;
	FOR i:=1 TO MAX DO		
	BEGIN
		GoTOXY(cpt,5);
		WRITE(i);
		cpt:=cpt+4;
	END;
	
	
	cpt:=8;
	FOR i:=1 TO MAX DO		
	BEGIN
		FOR j:=1 TO MAX*3 DO
		BEGIN
			GoTOXY(3,cpt);
			WRITE(Chr(i+64));
		END;
		cpt:=cpt+3;
	END;
		
END;

PROCEDURE Clrtxt2();
VAR
	i,j:INTEGER;
BEGIN

	FOR i:=13 TO 29 DO
	BEGIN
		FOR j:=49 TO 71 DO
		BEGIN
			GoTOXY(j,i);
			WRITE(' ');
		END;
	END;

END;

PROCEDURE Clrtxt3();
VAR
	i,j:INTEGER;
BEGIN

	FOR i:=34 TO 35 DO
	BEGIN
		FOR j:=49 TO 85 DO
		BEGIN
			GoTOXY(j,i);
			WRITE(' ');
		END;
	END;

END;

FUNCTION TestCaseLigne(Bateau:TabBoat;PosCellule:TabCellule;x,y,i:INTEGER):BOOLEAN;
VAR
	j:INTEGER;
	test,test2:BOOLEAN;
BEGIN
	test:=false;
	test2:=true;
	FOR j:=1 TO Bateau[i].taille DO
	BEGIN
		IF (Bateau[j].n.colonne<>PosCellule[y].colonne) AND (Bateau[j].n.ligne<>PosCellule[(x+(j-1))].ligne) THEN
		BEGIN
			test:=true;	
		END;
		
		IF test=false THEN
		BEGIN
			test2:=false;
		END;
	END;
	
	IF test2=false THEN
	BEGIN
		test:=false;
	END;
	
		TestCaseLigne:=test;

END;

FUNCTION TestCaseColonne(Bateau:TabBoat;PosCellule:TabCellule;x,y,i:INTEGER):BOOLEAN;
VAR
	j:INTEGER;
	test,test2:BOOLEAN;
BEGIN

	test:=false;	
	FOR j:=1 TO Bateau[i].taille DO
	BEGIN
		IF (Bateau[j].n.colonne<>PosCellule[(y+(j-1))].colonne) AND (Bateau[j].n.ligne<>PosCellule[x].ligne) THEN
		BEGIN
			test:=true;	
		END;
		
		IF test=false THEN
		BEGIN
			test2:=false;
		END;
	END;
	
	IF test2=false THEN
	BEGIN
		test:=false;
	END;

	TestCaseColonne:=test;

END;

FUNCTION TestCase(Bateau:TabBoat; Ensemble:TabFlotte):BOOLEAN;
VAR
	i,j,l,k:INTEGER;
	test:BOOLEAN;
BEGIN
	test:=true;
	
	FOR i:=1 TO BOATMAX DO
	BEGIN
		FOR j:=1 TO BOATMAX DO
		BEGIN
			FOR k:=1 TO Bateau[i].taille DO
			BEGIN
				FOR l:=1 TO Bateau[i].taille DO
				BEGIN
					IF (Ensemble[i,k].n1.n.ligne=Ensemble[j,l].n1.n.ligne) AND (Ensemble[i,k].n1.n.colonne=Ensemble[j,l].n1.n.colonne) AND (j<>i) THEN
					BEGIN
						test:=false;
					END;
				END;
			END;
		END;
	END;
	TestCase:=test;
END;

FUNCTION one1(car:STRING):INTEGER;
BEGIN
		IF length(car)=1 THEN
		BEGIN
			IF(ord(car[1])>=48) AND (ord(car[1])<=57) THEN
			BEGIN
				one1:=ord(car[1])-48
			END
				ELSE
					BEGIN
					one1:=0;
					END;
		END
		ELSE
			IF length(car)=2 THEN
			BEGIN
				
				IF (ord(car[1])=49) AND (ord(car[2])=48)THEN
				BEGIN
					one1:=10
				END
					ELSE
					BEGIN
						one1:=0;
					END;
			END;
			
			
END;

FUNCTION a1(car:CHAR):INTEGER;
BEGIN
	IF(ord(car)>=97) AND (ord(car)<97+MAX) THEN
	BEGIN	
		a1:=ord(car)-96
	END
		ELSE
			a1:=11;
END;

FUNCTION trouver(Ensemble:TabFlotte;Bateau:TabBoat;PosCellule:TabCellule;x,y:INTEGER;VAR nbr:INTEGER):BOOLEAN;
VAR
	i,j:INTEGER;
	test:BOOLEAN;
BEGIN
	test:=false;
	FOR i:=1 TO BOATMAX DO
	BEGIN
		FOR j:=1 TO Bateau[i].taille DO
		BEGIN
			IF (Ensemble[i,j].n1.n.colonne=PosCellule[y].colonne) AND (Ensemble[i,j].n1.n.ligne=PosCellule[x].ligne) THEN
			BEGIN
				test:=true;
				nbr:=i;			
			END;
		END;
	END;
	trouver:=test;
END;

FUNCTION al(Nb:Tab):BOOLEAN;
VAR
	i,cpt:INTEGER;
	test:BOOLEAN;
BEGIN
	test:=false;
	cpt:=0;
	FOR i:=1 TO BOATMAX DO
	BEGIN
		IF Nb[i]<1 THEN
		BEGIN
			cpt:=cpt+1;
			IF cpt=BOATMAX THEN
			BEGIN
				test:=true;
			END;
		END;
	al:=test;
	END;
	
END;

PROCEDURE CreateCellule(VAR PosCellule:TabCellule);
VAR
	cpt,i:INTEGER;
BEGIN	
	
	cpt:=7;
	FOR i:=1 TO MAX DO	
	BEGIN
		PosCellule[i].ligne:=cpt;
		cpt:=cpt+4;
	END;

	cpt:=8;
	FOR i:=1 TO MAX DO	
	BEGIN
		PosCellule[i].colonne:=cpt;
		cpt:=cpt+3;
	END;


END;

PROCEDURE Createboat (PosCellule:TabCellule;VAR Bateau:TabBoat;i:INTEGER);
VAR
	j,x,y,randdirection:INTEGER;
	test:BOOLEAN;
BEGIN

	REPEAT
	BEGIN
	RanDOmize;
	
	
		RandDirection:=Random(2)+1;
	
		case RandDirection of
			1:BEGIN		
					REPEAT
					BEGIN
						x:=Random(MAX)+1;
						y:=Random(MAX)+1;
					END;
					UNTIL (y<=MAX-Bateau[i].taille);
					
					test:=TestCaseColonne(Bateau,PosCellule,x,y,i);	
					IF test=true THEN
					BEGIN
						
						FOR j:=1 TO Bateau[i].taille DO
						BEGIN
							Bateau[j].n.colonne:=PosCellule[(y+j)-1].colonne;
							Bateau[j].n.ligne:=PosCellule[x].ligne;
						END;
					END;
					
				END;
			
			2:BEGIN
					REPEAT
					BEGIN
						x:=RanDOm(MAX)+1;
						y:=RanDOm(MAX)+1;
					END;
					UNTIL (x<=MAX-Bateau[i].taille);
					
					test:=TestCaseLigne(Bateau,PosCellule,x,y,i);	
					IF test=true THEN
					BEGIN
						
						FOR j:=1 TO Bateau[i].taille DO
						BEGIN
							Bateau[j].n.colonne:=PosCellule[y].colonne;
							Bateau[j].n.ligne:=PosCellule[(x+j)-1].ligne;
						END;
					END;
				
				END;
		END;

	END;
	UNTIL (test=true);

END;

PROCEDURE TailleBateau(VAR Bateau:TabBoat;VAR tailleB:Tab);
VAR
	i,nbr:INTEGER;
BEGIN
	
	RanDOmize;
	
	FOR i:=1 TO BOATMAX DO
	BEGIN
		REPEAT
			nbr:=RanDOm(TAILLEMAX)+1;
		UNTIL nbr>1;
		
		Bateau[i].taille:=nbr;
		tailleB[i]:=Bateau[i].taille;
	END;

END;

PROCEDURE CreateFlotte (Bateau:TabBoat; PosCellule:TabCellule; VAR Ensemble:TabFlotte);
VAR
	i,j:INTEGER;
	test:BOOLEAN;
BEGIN

	REPEAT
	BEGIN
		IniTabFlotte(Bateau,Ensemble);
		
		FOR i:=1 TO BOATMAX DO
		BEGIN

			Createboat(PosCellule,Bateau,i);
			

			FOR j:=1 TO Bateau[i].taille DO
			BEGIN	
					Ensemble[i,j].n1.n.ligne:=Bateau[j].n.ligne;
					Ensemble[i,j].n1.n.colonne:=Bateau[j].n.colonne;
			END;

		END;

		test:=TestCase(Bateau,Ensemble);
		
	END;
	UNTIL (test=true);

END;
	//Debut programme principal
VAR
	
	PosCellule,CelluleTouche:TabCellule;
	bateau:TabBoat;
	Nom:TabNom;
	tailleB:Tab;
	margin:marge;
	Ensemble:TabFlotte;
	x1,y1,i,k,j,nbr:INTEGER;
	y:CHAR;
	x,pseudo:STRING;
	test:BOOLEAN;
	
	
BEGIN
	clrscr;
	
	IniTabCellule(PosCellule,CelluleTOuche);

	AfficheMap();	
	
	CreateCellule(PosCellule);

	TailleBateau(Bateau,tailleB);
	
	CreateFlotte(Bateau,PosCellule,Ensemble);
	
	margin.x:=(MAX*4)+10;
	margin.y:=MAX;
	
	REPEAT
	BEGIN

			REPEAT
			BEGIN
				
				GoTOXY(margin.x,margin.y+13);
				WRITE('Coordonne x ? 1-10');
				GoTOXY(margin.x,margin.y+14);
				WRITE('.');
				READLN(x);
				x1:=one1(x);
				IF (x1=0) THEN
				BEGIN
					FOR i:=margin.x TO margin.x+10 DO
					BEGIN
						GoTOXY(i,margin.y+14);
						WRITE(' ');
					END;
				END;
			END;
			UNTIL (x1<>0) AND (x<>'');;
			
			clrtxt3;
			
			REPEAT
			BEGIN
				GoTOXY(margin.x,margin.y+15);
				WRITE('Coordonne y ? a-j');
				GoTOXY(margin.x,margin.y+16);
				WRITE('.');
				READLN(y);
				y:=LowerCase(y);
				y1:=a1(y);
				IF (y1=11) THEN
				BEGIN
					FOR i:=margin.x TO margin.x+10 DO
					BEGIN
						GoTOXY(i,margin.y+16);
						WRITE(' ');
					END;
				END;
			END;
			UNTIL (y1<>11);
			
		test:=trouver(Ensemble,Bateau,PosCellule,x1,y1,nbr);
		
		IF test=true THEN
		BEGIN
			
			IF (CelluleTouche[nbr].ligne<>PosCellule[x1].ligne) OR (CelluleTouche[nbr].colonne<>PosCellule[y1].colonne) THEN
			BEGIN
				
				IF (tailleB[nbr]>0) THEN
				BEGIN
				CelluleTouche[nbr].ligne:=PosCellule[x1].ligne;
				CelluleTouche[nbr].colonne:=PosCellule[y1].colonne;
			
				GoTOXY(PosCellule[x1].ligne,PosCellule[y1].colonne);
				WRITE('X');
				GoTOXY(margin.x,margin.y+24);
				WRITE(Nom[nbr],' toucher !');
				tailleB[nbr]:=tailleB[nbr]-1;
				END;
				
				IF tailleB[nbr]<=0 THEN
				BEGIN
					GoTOXY(margin.x,margin.y+25);
					WRITE('vous avez coule un boat !');
					FOR i:=1 TO Bateau[nbr].taille DO
					BEGIN
						GoTOXY(Ensemble[nbr,i].n1.n.ligne,Ensemble[nbr,i].n1.n.colonne);
						WRITE('C');
					END;
					tailleB[nbr]:=-1;
				END;
			END;
		END

		ELSE
		BEGIN
			GoTOXY(PosCellule[x1].ligne,PosCellule[y1].colonne);
			WRITE('0');
		END;
		
		clrtxt2;

			
		test:=al(tailleB);
	END;
	UNTIL test=true;
	delay(2000);
	
	clrtxt3;
	
	GoTOXY(margin.x,margin.y+24);
	WRITE('FIN');

	
	READLN;
END.
