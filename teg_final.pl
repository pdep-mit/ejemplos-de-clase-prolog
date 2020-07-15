:- module(teg_final, [estaEn/2, limitrofes/2, ocupa/3,
    continente/1, jugador/1, ocupaContinente/2, ejercitosPorOcupar/2, gano/1]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% T.E.G.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Info de continentes
continente(Continente):- ejercitosPorOcupar(Continente, _).

ejercitosPorOcupar(asia, 7).
ejercitosPorOcupar(europa, 5).
ejercitosPorOcupar(americaDelNorte, 5).
ejercitosPorOcupar(americaDelSur, 3).
ejercitosPorOcupar(africa, 3).
ejercitosPorOcupar(oceania, 2).

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
estaEn(labrador, americaDelNorte).
estaEn(groenlandia, americaDelNorte).
estaEn(terranova, americaDelNorte).
estaEn(canada, americaDelNorte).
estaEn(yukon, americaDelNorte).

estaEn(alemania, europa).
estaEn(espania, europa).
estaEn(francia, europa).
estaEn(granBretania, europa).
estaEn(rusia, europa).
estaEn(polonia, europa).
estaEn(italia, europa).
estaEn(islandia, europa).
estaEn(suecia, europa).

estaEn(sahara, africa).
estaEn(egipto, africa).
estaEn(etiopia, africa).
estaEn(madagascar, africa).
estaEn(zaire, africa).
estaEn(sudafrica, africa).

estaEn(china, asia).
estaEn(japon, asia).
estaEn(gobi, asia).
estaEn(mongolia, asia).
estaEn(siberia, asia).
estaEn(kamchatka, asia).
estaEn(taymir, asia).
estaEn(tartaria, asia).
estaEn(aral, asia).
estaEn(iran, asia).
estaEn(turquia, asia).
estaEn(israel, asia).
estaEn(arabia, asia).
estaEn(india, asia).
estaEn(malasia, asia).

estaEn(australia, oceania).
estaEn(sumatra, oceania).
estaEn(borneo, oceania).
estaEn(java, oceania).

% Simétrico, irreflexivo y no transitivo
limitrofes(Pais, Limitrofe):- limitaCon(Pais, Limitrofe).
limitrofes(Pais, Limitrofe):- limitaCon(Limitrofe, Pais).
limitrofes(Pais, Limitrofe):-
  limitan(Paises),
  member(Pais, Paises),
  member(Limitrofe, Paises),
  Pais \= Limitrofe.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predicados auxiliares. Usar limitrofes/2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- discontiguous teg_final:limitan/1.
:- discontiguous teg_final:limitaCon/2.

% Límites en América del Sur
limitan([argentina, brasil, uruguay]).
limitan([argentina, peru, chile]).
limitan([colombia, brasil, peru]).
% Equivalente a:
/*
limitaCon(argentina,brasil).
limitaCon(uruguay,brasil).
limitaCon(uruguay,argentina).
limitaCon(argentina,chile).
limitaCon(chile,peru).
limitaCon(argentina,peru).
limitaCon(brasil,peru).
limitaCon(brasil,colombia).
limitaCon(colombia,peru).
*/

% Límites en América del Norte
limitaCon(california, mexico).
limitan([nuevaYork, california, oregon]).
limitan([nuevaYork, terranova, canada]).
limitaCon(nuevaYork, groenlandia).
limitaCon(labrador, groenlandia).
limitaCon(labrador, terranova).
limitan([alaska, oregon, yukon]).
limitan([canada, oregon, yukon]).

% Límites en Europa
limitaCon(espania,francia).
limitaCon(espania,granBretania).
limitan([alemania, italia,francia]).
limitaCon(alemania,granBretania).
limitaCon(islandia,granBretania).
limitaCon(islandia,suecia).
limitaCon(rusia,suecia).
limitaCon(polonia, rusia).
limitaCon(polonia, alemania).

% Límites en Asia
limitan([china, india, malasia]).
limitan([china, india, iran]).
limitan([china, gobi, iran]).
limitan([china, gobi, mongolia]).
limitan([iran, gobi, mongolia]).
limitan([china, siberia, mongolia]).
limitan([china, siberia, kamchatka]).
limitan([china, japon, kamchatka]).
limitan([aral, iran, mongolia]).
limitan([aral, siberia, mongolia]).
limitan([aral, siberia, tartaria]).
limitan([taymir, siberia, tartaria]).
limitaCon(turquia, iran).
limitan([arabia, israel, turquia]).

% Límites en Oceanía
limitaCon(australia, sumatra).
limitaCon(australia, borneo).
limitaCon(australia, java).

% Límites en África
limitan([sahara, egipto, etiopia]).
limitan([sahara, zaire, etiopia]).
limitan([sudafrica, zaire, etiopia]).
limitaCon(madagascar, egipto).
limitaCon(madagascar, zaire).

% Límites intercontinentales
limitaCon(islandia, groenlandia).
limitaCon(mexico, colombia).
limitaCon(australia, chile).
limitaCon(india, sumatra).
limitaCon(malasia, borneo).
limitaCon(alaska, kamchatka).
limitaCon(aral, rusia).
limitaCon(iran, rusia).
limitaCon(turquia, rusia).
limitan([turquia, polonia, egipto]).
limitaCon(israel, egipto).
limitaCon(sahara, brasil).
limitaCon(sahara, espania).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Estado actual de la partida
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
ocupa(amarillo, suecia, 1).

ocupa(magenta, aral, 1).
ocupa(azul, china, 1).
ocupa(azul, japon, 1).
ocupa(azul, gobi, 1).
ocupa(azul, india, 1).
ocupa(azul, malasia, 1).
ocupa(azul, iran,8).
ocupa(verde, mongolia, 1).
ocupa(verde, siberia, 2).
ocupa(verde, taymir, 1).
ocupa(verde, tartaria, 3).
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
ocupa(amarillo, labrador, 1).
ocupa(amarillo, groenlandia, 1).
ocupa(amarillo, terranova, 1).
ocupa(amarillo, canada, 1).
ocupa(amarillo, yukon, 1).

ocupa(amarillo, sahara, 1).
ocupa(amarillo, egipto, 5).
ocupa(amarillo, etiopia, 1).
ocupa(amarillo, madagascar, 1).
ocupa(amarillo, zaire, 1).
ocupa(amarillo, sudafrica, 1).

% Sabemos quiénes son los jugadores que participaron de la partida
% más allá de si ocupan países o no, por si alguno fue destruido.
jugador(rojo).
jugador(amarillo).
jugador(verde).
jugador(negro).
jugador(magenta).
jugador(azul).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Existencia y No Existencia (clase 3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
puedeEntrar/2 que se cumple para un jugador y un continente si no ocupa ningún país del mismo,
pero sí alguno que es limítrofe de al menos uno de ellos.
*/

puedeEntrar(Jugador, Continente):-
  estaEn(OtroPais, Continente),
  ocupa(Jugador, Pais, _),
  not(ocupaPaisEn(Jugador, Continente)),
  limitrofes(Pais, OtroPais).

ocupaPaisEn(Jugador, Continente):-
  ocupa(Jugador, Pais, _),
  estaEn(Pais, Continente).

/*
seVanAPelear/2 que se cumple para 2 jugadores si son los únicos que ocupan países en un continente,
y tienen allí algún país fuerte (con más de 4 ejércitos).
*/

seVanAPelear(Jugador, Rival):-
  ocupaPaisFuerteEn(Jugador, Continente),
  ocupaPaisFuerteEn(Rival, Continente),
  Jugador \= Rival,
  not((ocupaPaisEn(Tercero, Continente), Tercero \= Jugador, Tercero \= Rival)).

ocupaPaisFuerteEn(Jugador, Continente):-
  ocupa(Jugador, Pais, _),
  estaEn(Pais, Continente),
  fuerte(Pais).

fuerte(Pais):-
  ocupa(_, Pais, Ejercitos),
  Ejercitos > 4.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Para Todo (clase 3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
estaRodeado/1 que se cumple para un país si todos sus limítrofes están ocupados por rivales.
*/

ocupadoPorRival(Pais, Jugador):-
  ocupa(Rival, Pais, _),
  Rival \= Jugador.

estaRodeado(Pais):-
  ocupa(Jugador, Pais, _),
  forall(limitrofes(Pais, Otro), ocupadoPorRival(Otro, Jugador)).

/*
protegido/1 se cumple para un país si ninguno de sus limítrofes están ocupados por un rival o si es fuerte (tiene más de 4 ejércitos).
*/

protegido(Pais):-
  fuerte(Pais).

protegido(Pais):-
  ocupa(Jugador, Pais, _),
  forall(limitrofes(Pais, Limitrofe), not(ocupadoPorRival(Limitrofe, Jugador))).

/*
complicado/2 se cumple para un jugador y un continente si todos los países que ocupa en ese continente están rodeados.
*/

complicado(Jugador, Continente):-
  ocupaPaisEn(Jugador, Continente),
  forall((ocupa(Jugador, Pais, _), estaEn(Pais, Continente)), estaRodeado(Pais)).

/*
masFuerte/2 se cumple si el país en cuestión es fuerte y además es el que más ejércitos tiene de los que ocupa ese jugador.
*/

masFuerte(Pais, Jugador):-
  fuerte(Pais),
  ocupa(Jugador, Pais, MuchosEjercitos),
  forall((ocupa(Jugador, OtroPais, Ejercitos), OtroPais \= Pais), Ejercitos =< MuchosEjercitos).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Polimorfismo (clase 4)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Problema principal:
% Un jugador ganó el juego si logró cumplir todos sus objetivos.
gano(Jugador):-
  jugador(Jugador),
  forall(objetivo(Jugador, Objetivo),
         cumplioObjetivo(Jugador, Objetivo)).

/*
Representamos los siguientes con functores y átomos:
- Destruir al jugador de un color particular: destruirAl/1
- Ocupar un continente indicado: ocupar/1.
- Ocupar 3 países limítrofes entre sí en cualquier parte del mapa:
    ocuparTresPaisesLimitrofesEntreSi.
- Ocupar 2 países de un continente indicado: ocuparDosPaisesDe/2
*/

% objetivo(Jugador, Objetivo)
% El negro tiene que destruir al rojo
objetivo(negro, destruirAl(rojo)).
% El verde tiene que destruir al magenta
objetivo(verde, destruirAl(magenta)).
% El amarillo tiene que ocupar africa y
% también americaDelNorte
objetivo(amarillo, ocupar(africa)).
objetivo(amarillo, ocupar(americaDelNorte)).
% El azul tiene que ocupar 3 países limítrofes
objetivo(azul, ocuparTresPaisesLimitrofesEntreSi).
% y también los continentes oceania y americaDelSur
objetivo(azul, ocupar(oceania)).
objetivo(azul, ocupar(americaDelSur)).
% El magenta tiene que ocupar asia y dos países de americaDelSur
objetivo(magenta, ocupar(asia)).
objetivo(magenta, ocuparDosPaisesDe(americaDelSur)).
% El rojo tiene que ocupar dos países en todos los continentes
objetivo(rojo, ocuparDosPaisesDe(Continente)):-
  continente(Continente).

% cumplioObjetivo(Jugador, Objetivo)
cumplioObjetivo(Jugador, ocuparDosPaisesDe(Continente)):-
  ocupa(Jugador, Pais1, _),
  ocupa(Jugador, Pais2, _),
  estaEn(Pais1, Continente),
  estaEn(Pais2, Continente),
  Pais1 \= Pais2.

% Se cumple si ocupa todos los países del continente
cumplioObjetivo(Jugador, ocupar(Continente)):-
  ocupaContinente(Jugador, Continente).

% Se cumple si el rival no ocupa ningún país
cumplioObjetivo(Jugador, destruirAl(Rival)):-
  jugador(Jugador), jugador(Rival),
  not(ocupa(Rival, _, _)).

% Se cumple si ocupa 3 países limítrofes entre sí en cualqiuer parte del mapa
cumplioObjetivo(Jugador,
         ocuparTresPaisesLimitrofesEntreSi):-
  ocupaLimitrofes(Jugador, Pais1, Pais2),
  ocupaLimitrofes(Jugador, Pais2, Pais3),
  ocupaLimitrofes(Jugador, Pais1, Pais3).

% ocupaLimitrofes/3 se cumple si el jugador ocupa
% ambos países y son limítrofes entre ellos
ocupaLimitrofes(Jugador, Pais1, Pais2):-
  ocupa(Jugador, Pais1, _),
  ocupa(Jugador, Pais2, _),
  limitrofes(Pais1, Pais2). % Simétrico e irreflexivo

% ocupaContinente/2, relaciona un jugador con un continente
% si lo ocupa por completo.
ocupaContinente(Jugador, Continente):-
  jugador(Jugador), continente(Continente),
  forall(estaEn(Pais, Continente),
         ocupa(Jugador, Pais, _)).