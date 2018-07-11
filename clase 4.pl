/* Casas de Hogwarts Ejercitacion Pre-pre-parcial */
lugarProhibido(bosque,50).
lugarProhibido(seccionRestringida,10).
lugarProhibido(tercerPiso,75).

alumnoFavorito(flitwick,hermione).
alumnoFavorito(snape,draco).
alumnoOdiado(snape,harry). /*spoilers*/

hizo(harry,fueraDeCama).
hizo(hermione,irA(tercerPiso)).
hizo(hermione,responder(dondeSeEncuentraUnBezoar,15,snape)).
hizo(hermione,responder(wingardiumLeviosa,25,flitwick)).
hizo(harry,irA(bosque)).
hizo(draco,irA(mazmorras)).

esDe(harry,gryffindor).
esDe(hermione,gryffindor).
esDe(draco,slytherin).

sangre(mestiza,harry).
sangre(pura,draco).
sangre(impura,hermione).

caracteriza(harry,amistoso).
caracteriza(harry,corajudo).
caracteriza(harry,orgulloso).
caracteriza(harry,inteligente).
caracteriza(draco,inteligente).
caracteriza(draco,orgulloso).
caracteriza(hermione,inteligente).
caracteriza(hermione,orgulloso).
caracteriza(hermione,responsable).

odiariaIr(harry,slytherin).
odiariaIr(draco,hufflepuff). /*cuanta maldad*/

importante(gryffindor,corajudo).
importante(slytherin,orgulloso).
importante(slytherin,inteligente).
importante(ravenclaw,inteligente).
importante(ravenclaw,responsable).
importante(hufflepuff,amistoso).

esCasa(gryffindor).
esCasa(slytherin).
esCasa(hufflepuff).
esCasa(ravenclaw).

esMago(Mago):-
	sangre(_,Mago). /*Es mago si tiene sangre, todos somos magos :D*/

/* 2 */

permiteEntrar(Casa,Mago):-
	esCasa(Casa),
	esMago(Mago),
	Casa \= slytherin.

permiteEntrar(slytherin,Mago):-
	esMago(Mago),
	not(sangre(impura,Mago)).

/* 3 */

caracterApropiado(Mago,Casa):-
	esMago(Mago),
	esCasa(Casa), 
	forall(importante(Casa,Caracteristica),
	caracteriza(Mago,Caracteristica)). 

/* 4 */

podriaQuedarEn(gryffindor,hermione).

podriaQuedarEn(Casa,Mago):-
	caracterApropiado(Mago,Casa),
	not(odiariaIr(Mago,Casa)),
	permiteEntrar(Casa,Mago).

/* 5 */

podrianSerAmigos(Mago1,Mago2):-
	caracteriza(Mago1,amistoso),
	caracteriza(Mago2,amistoso),
	Mago1 \= Mago2 .

podrianSerAmigos(Mago1,Mago2):-
	podriaQuedarEn(Casa,Mago1),
	podriaQuedarEn(Casa,Mago2),
	Mago1 \= Mago2 .

/* Bonus podrianSerAmigos si pudiesen */
/* tener un amigo en comun */

/* podrianSerAmigos(Mago1,Mago3):-
	podrianSerAmigos(Mago1,Mago2),
	podrianSerAmigos(Mago2,Mago3),
	Mago1 \= Mago3 . */

/* ------------------------------------- */

/* Parte 2 */

/* lugarProhibido(Lugar,PuntosQueRestan) */
/* alumnoFavorito(Profesor, Alumno) */
/* alumnoOdiado(Profesor,Alumno) */
/* hizo(Alumno, Accion) */

buenAlumno(Mago):-
	hizo(Mago,_), 
	forall(hizo(Mago,Accion),
	not(malaAccion(Mago, Accion))).

/*
malaAccion(fueraDeCama).
malaAccion(irA(Lugar)):-
	lugarProhibido(Lugar,_).
 */

malaAccion(Mago, Accion):-
	puntos(Mago,Accion,Puntos),
	Puntos < 0.

puntosObtenidos(Casa,Puntos):-
	esDe(Mago,Casa),
	hizo(Mago,Accion),
	puntos(Mago,Accion,Puntos).

/* Agregamos acciones con la forma buenaAccion(Accion,Puntos) */

puntos(_,buenaAccion(_,Puntos),Puntos).

puntos(_,fueraDeCama,-50).

puntos(_,irA(LugarProhibido),-Puntos):-
	lugarProhibido(LugarProhibido,Puntos).

puntos(Mago,responder(_,PuntajeEstandar,Profesor),Puntos):-
	influenciaSobre(Mago,Profesor,Coeficiente),
	Puntos is PuntajeEstandar * Coeficiente.

influenciaSobre(Mago,Profesor,1):-
	not(alumnoOdiado(Profesor,Mago)),
	not(alumnoFavorito(Profesor,Mago)).

influenciaSobre(Mago,Profesor,2):-
	alumnoFavorito(Profesor,Mago).



/* FELICES VACACIONES (terminen el TP) */