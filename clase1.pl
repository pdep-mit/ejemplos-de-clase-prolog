%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Programadores
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Predicados definidos con hechos y tipos de consultas %%

% Arrancamos con el conocimiento de que juan, mariana y nahue saben programar
sabeProgramar(juan).
sabeProgramar(mariana).
sabeProgramar(nahue).

/*
El predicado sabeProgramar/1 se compone de 3 clásulas,
que son hechos porque no dependen de nada para ser ciertas.

Consultas individuales:
?- sabeProgramar(nahue). %¿Es cierto que Nahue sabe programar?
Yes

?- sabeProgramar(lassie).  %¿Es cierto que Lassie es sabe programar?
No

Se deduce por universo cerrado que Lassie no sabe programar

Consultas existenciales (con variables)
?- sabeProgramar(_). %¿Es cierto que existe alguien que sabe programar en nuestro universo?
Yes.

?- sabeProgramar(Alguien). %¿Quiénes saben programar?
Alguien = juan ;
Alguien = mariana ;
Alguien = nahue

Cada respuesta es independiente de las otras, le tenemos que pedir más respuestas con ;
*/

% NUEVA CONSIGNA: Queremos saber en qué lenguaje programa una persona.
% Necesitamos establecer una RELACION entre cada persona y cada lenguaje que usa
programaEn(juan, haskell).
programaEn(juan, prolog).
programaEn(nahue, js).
programaEn(nahue, prolog).
programaEn(mariana, wollok).
programaEn(mariana, haskell).
programaEn(gas, scala).

/*
Ahora podemos jugar un poco más con las consultas con el predicado programaEn/2:

?- programaEn(nahue, Lenguaje). %¿En qué lenguajes sabe programar Nahue?
Lenguaje = js ;
Lenguaje = prolog

?- programaEn(juan, Lenguaje). %¿Existe algún lenguaje en el que programe juan?
Lenguaje = haskell;
Lenguaje = prolog

?- programaEn(Persona, haskell). %¿Existe alguna persona que programe en Haskell?
Persona = juan;
Persona = mariana

?- programaEn(_, haskell). %¿Existe alguien que programe en Haskell?
Yes

?- programaEn(lassie, _). %¿Existe algún lenguaje en el que programe Lassie?
No
*/

%% Introducimos las reglas (implicación), la conjunción y disyunción %%

% NUEVA CONSIGNA: Una persona cursó un cuatrimestre de PdeP si programa tanto en Haskell como en Prolog,
% o si programa en Wollok

cursoUnCuatriDePdeP(Persona):-
	programaEn(Persona, haskell),
	programaEn(Persona, prolog).
cursoUnCuatriDePdeP(Persona):-
	programaEn(Persona, wollok).

/*
El predicado cursoUnCuatriDePdeP/1 se compone de 2 clásulas, ambas son reglas.

Para la disyunción alcanza con agregar tantas cláusulas como condiciones hayan que querramos que se comporten como un "o".

Para la conjunción tenemos que separar las condiciones con comas, por ende una persona satisface la condición para
la primer cláusula de cursoUnCuatriDePdeP/1 si es cierto que programa en haskell y también es cierto que programa en prolog.
Usamos la misma variable Persona para ambas consultas porque estamos hablando del mismo individuo.

Consultas:
?- cursoUnCuatriDePdeP(mariana).
Yes

?- cursoUnCuatriDePdeP(lassie).
Yes

?- cursoUnCuatriDePdeP(_).
Yes

?- cursoUnCuatriDePdeP(Alguien).
Alguien = juan ;
Alguien = mariana

Estas respuestas se consiguen gracias a que juan programa tanto en Prolog como Haskell
y a que mariana programa en Wollok.

IMPORTANTE: siempre que podamos deducir el valor de verdad de algo en función del valor de verdad
de otras cosas que ya sabemos, hay que resolverlo con reglas, ya que explican por qué ese algo debería ser cierto
y se mantienen consistentes automáticamente!

Los hechos deberían usarse sólo cuando realmente esa afirmación no depende de ninguna otra cosa.

Teniendo esto en cuenta podríamos borrar los hechos que hicimos para sabeProgramar y reemplazarlos por una regla:
sabeProgramar(Persona) :- programaEn(Persona, _).

Es posible combinar hechos y reglas al definir un predicado, siempre y cuando el problema lo amerite, claro.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% UNA BRUJA!
%% https://www.youtube.com/watch?v=Ux6fBfXOIuo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
esBruja(Persona):- flota(Persona).

flota(Persona) :- estaHechaDeMadera(Persona).

%% Si agregáramos
%% flota(nahue).
%% La consulta esBruja(nahue) sería cierta

estaHechaDeMadera(Persona) :-
  pesa(Persona, Peso),
  pesa(ganso, Peso),
	Persona \= ganso. % Contamos que esto tiene que ir después de consultar pesa(Persona, Peso),
										% porque \= no es inversible, necesita que Persona ya esté ligada con un individuo
										% para poder hacer consultas existenciales y que respondan como queremos

pesa(ganso, 40).
pesa(luisa, 40).
pesa(nahue, 70).
pesa(julia, 50).
pesa(ganso, 50).

/*
Consultas:
?- esBruja(julia).
Yes

?- esBruja(ganso).
No

?- esBruja(mora).
No

?- esBruja(Persona).
Persona = luisa ;
Persona = julia
*/
