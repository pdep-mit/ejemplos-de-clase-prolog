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
% Necesitamos establecer una RELACION entre cada persona y cada lenguaje que usa.
% Sabemos que Juan programa en Haskell y Prolog, Nahue en js y Prolog.

programaEn(juan, haskell).
programaEn(juan, prolog).
programaEn(nahue, js).
programaEn(nahue, prolog).

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

%% Introducimos las reglas (implicación) %%
/*
Nos damos cuenta que estaría bueno no tener que definir por extensión quiénes saben programar,
si esa información se puede deducir en base a programaEn/1.

Si el día de mañana tenemos que contemplar que Mora programa en Prolog, Hasekll y js estaría bueno
tener que agregar solamente los hechos:

programaEn(mora, js).
programaEn(mora, haskell).
programaEn(mora, prolog).

Y no también que Mora sabe programar con otro hecho para el predicado sabeProgramar/1.

Para eso podríamos reemplazar todos los hechos del predicado sabeProgramar/1 que consideremos redundantes,
y agregar una REGLA para el predicado sabeProgramar/1.

Por más que cambiemos la implementación, vamos a poder hacer las mismas consultas que antes.

La nueva implementación quedaría así:
*/
sabeProgramarGeneralizado(mariana). % Como no sabemos en qué programa Mariana, este hecho lo tenemos que conservar.
sabeProgramarGeneralizado(Persona) :-
  programaEn(Persona, _).

programaEn(mora, js).
programaEn(mora, haskell).
programaEn(mora, prolog).

/*
IMPORTANTE: siempre que podamos deducir el valor de verdad de algo en función del valor de verdad
de otras cosas que ya sabemos, hay que resolverlo con reglas, ya que explican por qué ese algo debería ser cierto
y se mantienen consistentes automáticamente!

Los hechos deberían usarse sólo cuando realmente esa afirmación no depende de ninguna otra cosa, no tenemos cómo
deducir que eso es cierto.

Es posible combinar hechos y reglas al definir un predicado, siempre y cuando el problema lo amerite, claro.
*/

%% Introducimos la disyunción %%

/*
NUEVA CONSIGNA: A una persona le gusta funcional si programa en Haskell o en js.
Identificamos que esto es una disyunción (O lógico), que aunque no nos hayamos dado cuenta, ya estábamos usando
para los predicados anteriores. Cuando tenemos múltiples cláusulas para un predicado se genera una disyunción.

Podemos resolver este problema definiendo dos reglas, una que indique que a la persona le gusta funcional
si programa en Haskell y otra que indique que a la persona le gusta funcional si programa en js.
*/
leGustaFuncional(Persona):- programaEn(Persona, haskell).
leGustaFuncional(Persona):- programaEn(Persona, js).

/*
?- leGustaFuncional(Alguien).
Alguien = juan ;
Alguien = mora ;
Alguien = nahue ;
Alguien = mora.

Nota: el individuo mora satisface el predicado leGustaFuncional/1 por más de un camino, es por ese
motivo que aparece más de una vez como respuesta. Esto no es un problema, vale ignorar las respuestas repetidas.
*/

%% Introducimos la conjunción %%

/*
NUEVA CONSIGNA: Una persona cursó PdeP si programa tanto en Haskell como en Prolog.
Identificamos que esto es una conjunción (Y lógico) y la podemos resolver con una única regla.

Para la conjunción tenemos que separar las condiciones con comas, por ende una persona satisface la condición para
la regla de cursoPdeP/1 si es cierto que programa en Haskell y también es cierto que programa en Prolog.
Usamos la misma variable Persona para ambas consultas porque estamos hablando del mismo individuo.
*/
cursoPdeP(Persona):-
	programaEn(Persona, haskell),
	programaEn(Persona, prolog).

/*
Consultas:
?- cursoPdeP(mora).
Yes

?- cursoPdeP(_).
Yes

?- cursoPdeP(Alguien).
Alguien = juan ;
Alguien = mora.

Estas respuestas se consiguen gracias a que juan y mora programan tanto en Prolog como Haskell.
Eso no se cumple para nahue, porque no programa en Haskell.
*/
