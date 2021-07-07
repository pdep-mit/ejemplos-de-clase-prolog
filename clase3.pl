:- module(clase3, [estaEn/2, limitrofes/2, ocupa/3,
  puedeEntrar/2, seVanAPelear/2, estaRodeado/1, ocupadoPorRival/2,jugador/1, continente/1, protegido/1, complicado/2, masFuerte/2]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% T.E.G.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Descripción del mapa

% estaEn(Pais, Continente).
estaEn(argentina, americaDelSur).
estaEn(uruguay, americaDelSur).
estaEn(brasil, americaDelSur).
estaEn(chile, americaDelSur).
estaEn(peru, americaDelSur).
estaEn(colombia, americaDelSur).

estaEn(mexico, americaDelNorte).
estaEn(california, americaDelNorte).
estaEn(nuevaYork, americaDelNorte).
estaEn(oregon, americaDelNorte).
estaEn(alaska, americaDelNorte).

estaEn(alemania, europa).
estaEn(espania, europa).
estaEn(francia, europa).
estaEn(granBretania, europa).
estaEn(rusia, europa).
estaEn(polonia, europa).
estaEn(italia, europa).
estaEn(islandia, europa).

estaEn(sahara, africa).
estaEn(egipto, africa).
estaEn(etiopia, africa).

estaEn(aral, asia).
estaEn(china, asia).
estaEn(gobi, asia).
estaEn(mongolia, asia).
estaEn(siberia, asia).
estaEn(india, asia).
estaEn(iran, asia).
estaEn(kamchatka, asia).
estaEn(turquia, asia).
estaEn(israel, asia).
estaEn(arabia, asia).

estaEn(australia, oceania).
estaEn(sumatra, oceania).
estaEn(borneo, oceania).
estaEn(java, oceania).

% Como limitaCon/2 pero simétrico
limitrofes(Pais, Limitrofe):- limitaCon(Pais, Limitrofe).
limitrofes(Pais, Limitrofe):- limitaCon(Limitrofe, Pais).

% Antisimétrico, irreflexivo y no transitivo
% Predicado auxiliar. Usar limitrofes/2.
limitaCon(argentina,brasil).
limitaCon(uruguay,brasil).
limitaCon(uruguay,argentina).
limitaCon(argentina,chile).
limitaCon(argentina,peru).
limitaCon(brasil,peru).
limitaCon(chile,peru).
limitaCon(brasil,colombia).
limitaCon(colombia,peru).

limitaCon(mexico, colombia).
limitaCon(california, mexico).
limitaCon(nuevaYork, california).
limitaCon(oregon, california).
limitaCon(oregon, nuevaYork).
limitaCon(alaska, oregon).

limitaCon(espania,francia).
limitaCon(espania,granBretania).
limitaCon(alemania,francia).
limitaCon(alemania,granBretania).
limitaCon(polonia, alemania).
limitaCon(polonia, rusia).
limitaCon(italia,francia).
limitaCon(alemania,italia).
limitaCon(granBretania, islandia).

limitaCon(china,india).
limitaCon(iran,india).
limitaCon(china,iran).
limitaCon(gobi,china).
limitaCon(aral, iran).
limitaCon(gobi, iran).
limitaCon(china, kamchatka).
limitaCon(mongolia, gobi).
limitaCon(mongolia, china).
limitaCon(mongolia, iran).
limitaCon(mongolia, aral).
limitaCon(siberia, mongolia).
limitaCon(siberia, aral).
limitaCon(siberia, kamchatka).
limitaCon(siberia, china).
limitaCon(turquia, iran).
limitaCon(israel, turquia).
limitaCon(arabia, israel).
limitaCon(arabia, turquia).

limitaCon(australia, sumatra).
limitaCon(australia, borneo).
limitaCon(australia, java).

limitaCon(sahara, egipto).
limitaCon(etiopia, sahara).
limitaCon(etiopia, egipto).

limitaCon(australia, chile).
limitaCon(aral, rusia).
limitaCon(iran, rusia).
limitaCon(india, sumatra).
limitaCon(alaska, kamchatka).
limitaCon(sahara, brasil).
limitaCon(sahara, espania).
limitaCon(egipto, polonia).
limitaCon(turquia, polonia).
limitaCon(turquia, rusia).
limitaCon(turquia, egipto).
limitaCon(israel, egipto).

%% Estado actual de la partida

% ocupa(Jugador, Pais, Ejercitos)
ocupa(azul, argentina, 5).
ocupa(azul, uruguay, 3).
ocupa(verde, brasil, 7).
ocupa(azul, chile, 8).
ocupa(verde, peru, 1).
ocupa(verde, colombia, 1).

ocupa(rojo, alemania, 2).
ocupa(rojo, espania, 1).
ocupa(rojo, francia, 6).
ocupa(rojo, granBretania, 1).
ocupa(amarillo, rusia, 6).
ocupa(amarillo, polonia, 1).
ocupa(verde, italia, 1).
ocupa(amarillo, islandia, 1).

ocupa(magenta, aral, 1).
ocupa(azul, china, 1).
ocupa(azul, gobi, 1).
ocupa(azul, india, 1).
ocupa(azul, iran,8).
ocupa(verde, mongolia, 1).
ocupa(verde, siberia, 2).
ocupa(verde, kamchatka, 2).
ocupa(amarillo, turquia, 10).
ocupa(negro, israel, 1).
ocupa(negro, arabia, 3).

ocupa(azul, australia, 1).
ocupa(azul, sumatra, 1).
ocupa(azul, borneo, 1).
ocupa(azul, java, 1).

ocupa(amarillo, mexico, 1).
ocupa(amarillo, california, 1).
ocupa(amarillo, nuevaYork, 3).
ocupa(amarillo, oregon, 1).
ocupa(amarillo, alaska, 4).

ocupa(amarillo, sahara, 1).
ocupa(amarillo, egipto, 5).
ocupa(amarillo, etiopia, 1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Existencia y No Existencia
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Predicados disponibles para trabajar:

% estaEn(Pais, Continente).
% limitrofes(Pais1, Pais2).
% ocupa(Jugador, Pais, Ejercitos).

/*
puedeEntrar/2 que se cumple para un jugador y un continente si no ocupa ningún país del mismo,
pero sí alguno que es limítrofe de al menos uno de ellos.
*/
ocupaAlgunPaisEnContinente(Jugador, Continente):-
  ocupaPaisEnContinente(Jugador, Continente, _).

puedeEntrar(Jugador, Continente):-
  ocupa(Jugador, Pais, _),
  limitrofes(Limitrofe, Pais),
  estaEn(Limitrofe, Continente),
  not(ocupaAlgunPaisEnContinente(Jugador, Continente)).

/*
seVanAPelear/2 que se cumple para 2 jugadores si son los únicos que ocupan países en un continente,
y tienen allí algún país fuerte (con más de 4 ejércitos).
*/

ocupaPaisEnContinente(Jugador, Continente, Pais):-
  ocupa(Jugador, Pais, _),
  estaEn(Pais, Continente).

seVanAPelear(Jugador, Rival):-
  ocupaPaisEnContinente(Jugador, Continente, PaisDeJugador),
  ocupaPaisEnContinente(Rival, Continente, PaisDeRival),
  Jugador \= Rival,
  not((ocupaAlgunPaisEnContinente(OtroJugador, Continente),
        OtroJugador \= Jugador, OtroJugador \= Rival)),
  fuerte(PaisDeJugador),
  fuerte(PaisDeRival).

fuerte(Pais):-
  ocupa(_,Pais, Ejercitos),
  Ejercitos > 4.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Para Todo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
estaRodeado/1 que se cumple para un país si todos sus limítrofes están ocupados por rivales.
*/

ocupadoPorRival(Pais, Jugador):-
  ocupa(Rival, Pais, _),
  Rival \= Jugador.

% Solución con not/1
/*
estaRodeado(Pais):-
  ocupa(Jugador, Pais, _),
  not(( limitrofes(Pais, Otro), not(ocupadoPorRival(Otro, Jugador)) )).
*/

% No existe un país que sea limítrofe de Pais y no esté ocupado por un rival de Jugador

% Solución con forall/2, mucho más linda

estaRodeado(Pais):-
  ocupa(Jugador, Pais, _),
  forall(limitrofes(Pais, Otro), ocupadoPorRival(Otro, Jugador)).

% Antecedente: para todo país que sea limítrofe de Pais
% Consecuente: se cumple que ese otro país está ocupado por un rival de Jugador


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cierre
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Predicados generadores que estaban en la PPT, por si hacen falta
jugador(Jugador):- ocupa(Jugador, _,_).
continente(Continente):- estaEn(_, Continente).

/*
protegido/1 se cumple para un país si ninguno de sus limítrofes están ocupados por un rival o si es fuerte (tiene más de 4 ejércitos).
*/

protegido(Pais):-
  fuerte(Pais).

%% versión con not
/*
protegido(Pais):-
  ocupa(Jugador, Pais, _),
  not((
    limitrofes(Pais, Limitrofe),
    ocupadoPorRival(Limitrofe, Jugador)
    )).
*/

%% versión con forall
protegido(Pais):-
  ocupa(Jugador, Pais, _),
  forall(limitrofes(Pais, Limitrofe), not(ocupadoPorRival(Limitrofe, Jugador))).


/*
complicado/2 se cumple para un jugador y un continente si todos los países que ocupa en ese continente están rodeados.
*/

%% Primera solución: es inversible, pero notamos que si no aseguramos que esté en el continente,
%% se cumple para quienes no tengan ningún país ahí
/*
complicado(Jugador, Continente):-
  jugador(Jugador), continente(Continente),
  forall(ocupaPaisEnContinente(Jugador, Continente, Pais), estaRodeado(Pais)).
*/

%% Segunda solución: ocupaAlgunPaisEnContinente/2 además de ligar ambas variables agrega
%% la condición necesaria para que no se cumpla para quienes no tienen países en el continente
complicado(Jugador, Continente):-
  ocupaAlgunPaisEnContinente(Jugador, Continente),
  forall(ocupaPaisEnContinente(Jugador, Continente, Pais), estaRodeado(Pais)).


/*
masFuerte/2 se cumple si el país en cuestión es fuerte y además es el que más ejércitos tiene de los que ocupa ese jugador.
*/

masFuerte(PaisFuerte, Jugador):-
  fuerte(PaisFuerte),
  ocupa(Jugador, PaisFuerte, Ejercitos),
  forall(
    (ocupa(Jugador, OtroPais, OtrosEjercitos), OtroPais \= PaisFuerte),
    OtrosEjercitos =< Ejercitos
  ).