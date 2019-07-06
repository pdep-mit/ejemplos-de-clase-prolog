% seraphim/2 relaciona al seraphim con el elemento que domina

seraphim(lailah, fuego).
seraphim(mikleo, agua).
seraphim(dezel, aire).
seraphim(zaveid, aire).
seraphim(edna, tierra).
seraphim(maotelus, luz).
seraphim(heldalf, malevolencia).

% humano/2 relaciona al humano con su nivel de malevolencia
humano(alisha, 15).
humano(rose, 25).
humano(sergei, 50).
humano(maltran, 90).

elemento(tierra).
elemento(fuego).
elemento(agua).
elemento(aire).
elemento(luz).
elemento(malevolencia).

% puedePercibir/2 relaciona a un humano con un seraphim que puede percibir
puedePercibir(rose, mikleo).
puedePercibir(rose, dezel).
puedePercibir(rose, zaveid).
puedePercibir(alisha, zaveid).

% poder/2 relaciona un seraphim con su poder
poder(lailah, 70).
poder(mikleo, 30).
poder(dezel, 45).
poder(zaveid, 20).
poder(edna, 60).
poder(maotelus, 100).
poder(heldalf, 100).

% ejercicio 1: agregar a Sorey

humano(sorey, 0).
puedePercibir(sorey, Seraphim) :- 
	seraphim(Seraphim, _), 
	Seraphim \= maotelus.

% ejercicio 2: amigos /2

amigos(Humano, Seraphim) :- 
 puedePercibir(Humano, Seraphim), 
 humano(Humano, Maldad),
 Maldad < 40.

amigos(Humano, Seraphim) :- 
 humano(Humano, Maldad),
 seraphim(Seraphim, malevolencia),
 Maldad > 70.

% ejercicio 3: aislado /1

aislado(Seraphim) :- 
 seraphim(Seraphim, _),
 not(puedePercibir(_, Seraphim)).

% ejercicio 4: sheperd /1

sheperd(Humano) :- 
 humano(Humano, _),
 forall(
 elementoFundamental(Elemento),
 (seraphim(Seraphim, Elemento), amigos(Humano, Seraphim))
 ),
 not((amigos(Humano, SeraphimMalo), seraphim(SeraphimMalo, malevolencia))).

elementoFundamental(tierra).
elementoFundamental(agua).
elementoFundamental(fuego).
elementoFundamental(aire).

% ejercicio 5: pactoDeEscudero /2

pactoDeEscudero(Escudero, Sheperd) :- 
 sheperd(Sheperd),
 amigos(Escudero, Seraphim),
 amigos(Sheperd, Seraphim),
 not(sheperd(Escudero)).

% ejercicio 6: pactoPoderoso /2

pactoPoderoso(Escudero, Sheperd) :-
 pactoDeEscudero(Escudero, Sheperd),
 amigos(Escudero, Seraphim1),
 amigos(Sheperd, Seraphim2),
 Seraphim1 \= Seraphim2,
 sumaDePoderes(Seraphim1, Seraphim2, Poder),
 Poder > 100.
 
sumaDePoderes(Seraphim1, Seraphim2, Poder) :-
 poder(Seraphim1, Poder1),
 poder(Seraphim2, Poder2),
 Poder is Poder1 + Poder2.
 
% ejercicio 7: puedeFusionarseCon /2
puedeFusionarseCon(Humano, Seraphim) :-
 humanoPoderoso(Humano),
 seraphim(Seraphim, ElementoFundamental),
 elementoFundamental(ElementoFundamental),
 forall(
 seraphim(UnSeraphim, ElementoFundamental),
 puedePercibir(Humano, UnSeraphim)
 ).

humanoPoderoso(Humano) :-
 sheperd(Humano).
humanoPoderoso(Humano) :-
 pactoPoderoso(Humano, _).
 
%%%Algo que nada que ver: Factorial
%%%factorial 0 = 1
%%%factorial n = n * factorial n-1

factorial(0, 1).
factorial(Valor, Resultado) :-
 Valor > 0,
 ValorAnterior is Valor - 1,
 factorial(ValorAnterior, FactorialAnterior),
 Resultado is Valor * FactorialAnterior.