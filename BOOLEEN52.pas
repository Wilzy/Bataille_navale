program BOOLEEN52;

uses CRT;

VAR
	a ,b ,c ,d ,e : BOOLEAN ;
BEGIN
        clrscr ;
	a := TRUE;
	b := FALSE;
	c := NOT a OR NOT b ;
	d := a and b and c ;
	e := a AND b OR b OR c AND d AND a;
	
	Writeln ( a ,' ' , b, ' ', c, ' ' , d ,' ' , e, ' ' );
	readln ();
END.

