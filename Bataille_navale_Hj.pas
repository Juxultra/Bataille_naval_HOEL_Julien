PROGRAM BatNavale;

uses crt;


CONST
	MAX=14;			
	MAXBAT=5;		 
	NBJOUEUR=2;		

TYPE
	coord=RECORD
		x,y:INTEGER
END;

TYPE
	bateau=RECORD
		cases:ARRAY[1..5] OF coord;
		taille:INTEGER;
END;

TYPE grille=ARRAY[1..NBJOUEUR] OF flotte;								

								
FUNCTION Flotte (flotte1:flotte ; coord1:coord) : BOOLEAN;

VAR	
	i:INTEGER;
BEGIN
	Flotte:=FALSE;								
	FOR i:=1 TO MAXBAT DO								
		IF (OwnBateau(flotte1.bateau[i],coord1)=TRUE) THEN
			BEGIN
				Flotte:=TRUE;
			END;
END;

PROCEDURE NewCoord(x,y:INTEGER ; var coord1:coord);

BEGIN
	coord1.x:=x;
	coord1.y:=y;
END;
						

FUNCTION NewBateau (compteur,taille:INTEGER): Bateau;

VAR
	i:INTEGER;
	stock:INTEGER;
	x,y:1..MAX;
	sens:CHAR;
	coord:coord;
	bateau1:bateau;
BEGIN
	REPEAT																											
		writeln('Entrez les coordonnées de votre bateau de ', taille, ' de longeur (entre 1 et ', MAX, ' pour x et y.)');
		writeln('Entrez les x et y de votre bateau');
		readln(x,y);
		NewCoord(x,y,coord);			
		bateau1.taille:=taille;
		REPEAT														
			writeln('Entrez l orientation de votre bateau :');		
			writeln('Pour NORD écrire : N , Pour SUD écrire : S , Pour EST écrire : E ,Pour OUEST écrire : O');
			readln(sens);
		UNTIL (sens='N') OR (sens='E') OR (sens='S') OR  (sens='O');
			FOR i:=1 TO bateau1.taille DO						
			BEGIN
				CASE sens OF							
					'S':
						BEGIN
							(bateau1.cases[i].x):=(stock.x);
							(bateau1.cases[i].y):=(stock.y+i-1);
						END;
					'E':
						BEGIN
							(bateau1.cases[i].x):=(stock.x+i-1);
							(bateau1.cases[i].y):=(stock.y);
						END;
					'N':
						BEGIN
							(bateau1.cases[i].x):=(stock.x);
							(bateau1.cases[i].y):=(stock.y-i+1);
						END;
					'O':
						BEGIN
							(bateau1.cases[i].x):=(stock.x-i+1);
							(bateau1.cases[i].y):=(stock.y);
						END;
				END;
			END;
	UNTIL (i=bateau1.taille)
	Newbateau:=bateau1;	
END;
								
PROCEDURE AffichageTableau(flotte1:flotte);			

VAR
	i,j:INTEGER;
	stock:coord;
BEGIN
	FOR i:=0 TO MAX DO								
	BEGIN
		FOR j:=0 TO MAX DO					
		BEGIN
			stock.x:=j;				
			stock.y:=i;
			IF (i=0)THEN				
				IF j>9 THEN				
					write(' ',j)
				ELSE
					write('  ',j)
			ELSE
			IF (j=0) THEN			
				IF i>9 THEN			
					write(' ',i,' ')
				ELSE
					write('  ',i,' ')
			ELSE
			IF Flotte(flotte1,stock) THEN
				write(' ',CHR(129),' ')
			ELSE				
				write(' . ')
		END;
			writeln;
	END;			
END;

PROCEDURE InitFlotte (var flotte1:flotte);

VAR
	i,j:INTEGER;
	bateau1:bateau;
BEGIN
	FOR i:=1 TO MAXBAT DO
	BEGIN
		CASE i OF
			1:flotte1.bateau[i].taille:=2;		
			2:flotte1.bateau[i].taille:=3;
		ELSE
			flotte1.bateau[i].taille:=i
		END;
		REPEAT
			bateau1:=CreaBateau(i,flotte1.bateau[i].taille);
			writeln('ok 1');
			IF bateauflotte(flotte1,bateau1) THEN
			BEGIN
				writeln('ok 1');
				writeln('Erreur, recommencez');
			END;
		UNTIL bateauflotte(flotte1,bateau1)=FALSE;
		writeln('ok 1');
		flotte1.bateau[i]:=bateau1;
		writeln('ok 1');
		AffichageTableau(flotte1);
	END;
END;

FUNCTION BateauCoule(bateau1:bateau) : INTEGER;							

VAR
	i:INTEGER;
BEGIN
	BateauCoule:=0;
	FOR i:=1 TO bateau1.taille DO
		IF (bateau1.cases[i].x=0) AND (bateau1.cases[i].y=0) THEN
			BateauCoule:=BateauCoule+1
END;
FUNCTION Perdu(flotte1:flotte): BOOLEAN;				

VAR
	i,j,stock:INTEGER;
BEGIN
	stock:=0;
	FOR i:=1 TO MAXBAT DO										
	BEGIN
		FOR j:=1 TO flotte1.bateau[i].taille DO 
		BEGIN
			IF (flotte1.bateau[i].cases[j].x=-1) AND (flotte1.bateau[i].cases[j].y=-1) THEN
				stock:=stock+1/ 
		END;
	END;
	IF stock=MAXBAT THEN 
	BEGIN
		Perdu:=TRUE;
		writeln('Le joueur ',flotte1.joueur,' a perdu');
	END
	ELSE
			Perdu:=FALSE
END;
								
PROCEDURE Tour(flotte1:flotte ; var flotte2:flotte);

VAR
	i,j:INTEGER;
	stock:coord;
	x,y:1..MAX;
						
BEGIN
	writeln('Voici votre flotte');
	AffichageTableau(flotte1);																
	writeln('Ordres du joueur ',flotte1.joueur);
	writeln('Entrez les coordonnées de votre tir');
	writeln('Ordre: x, y');
	readln(x,y);
	NewCoord(x,y,stock);																			
	clrscr;
	IF Flotte(flotte2,stock)=TRUE THEN										
	BEGIN
		writeln('Touché :)');
		FOR i:=1 TO MAXBAT DO														
		BEGIN
			FOR j:=1 TO flotte2.bateau[i].taille DO							
			BEGIN
				IF (Comparaison(flotte2.bateau[i].cases[j],stock)) THEN
				BEGIN
					flotte2.bateau[i].cases[j].x:=0;					
					flotte2.bateau[i].cases[j].y:=0;
				END;
				IF (BateauCoule(flotte2.bateau[i])=flotte2.bateau[i].taille) THEN
				BEGIN
					writeln('/!\ Coulé /!\');
					flotte2.restants:=(flotte2.restants-1);			
					flotte2.bateau[i].cases[j].x:=-1;
					flotte2.bateau[i].cases[j].y:=-1; 				
				END;
			END;
		END;
	END
	ELSE
	BEGIN
		writeln('Manqué :(');
	END;
	FOR i:=0 TO MAX DO
	BEGIN
		FOR j:=0 TO MAX DO
		BEGIN
		IF (i=0)THEN
			IF j>9 THEN
				write(' ',j)
			ELSE
				write('  ',j)
		ELSE
			IF (j=0) THEN
				IF i>9 THEN
					write(' ',i,' ')
				ELSE
					write('  ',i,' ')
			ELSE
				IF (stock.x=j) AND (stock.y=i) THEN
					write(' ',CHR(64),' ')
				ELSE 
					write(' . ')
		END;
		writeln;
	END;
	writeln('Votre adversaire possède ',flotte2.restants,' bateau. Appuiez sur une touche pour continuer');
	readln;		
END;

VAR
	nGrille:grille;
	i,j:INTEGER;
	Confirm:STRING;
BEGIN
	clrscr;
	writeln('Bienvenue dans la bataille navale');
	writeln('Appuiez sur une touche pour commencer la partie');
	readln;
	clrscr;
	FOR i:=1 TO nbJoueur DO												
	BEGIN
		REPEAT
			writeln;
			writeln('Joueur ' , i ,' :');
			InitFlotte(nGrille[i]);
			nGrille[i].joueur:=i;			
			nGrille[i].restants:=MAXBAT;
			writeln('Entrez "OK" pour confirmer');
			readln(Confirm);
		UNTIL (Confirm='OK');
		clrscr;
	END;
	REPEAT														
		Tour(nGrille[1],nGrille[2]);	
		clrscr;
			IF Perdu(nGrille[1])=FALSE THEN
			BEGIN
				Tour(nGrille[2],nGrille[1]);
				clrscr;
			END;
	UNTIL (Perdu(nGrille[1])) OR (Perdu(nGrille[2]));
	readln;
	
END.
