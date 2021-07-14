%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Truco
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

valeMas(carta(1, espada), carta(1, basto)).
valeMas(carta(1, basto), carta(7, espada)).
valeMas(carta(7, espada), carta(7, oro)).
valeMas(carta(7, oro), carta(3, _)).
valeMas(carta(3, _), carta(2, _)).
valeMas(carta(2, _), As):- falsoAs(As).
valeMas(As, carta(12, _)):- falsoAs(As).
valeMas(carta(Figura1, _), carta(Figura2, _)):-
  between(11, 12, Figura1),
  Figura2 is Figura1 - 1.
valeMas(carta(10, _), Siete):- falsoSiete(Siete).
valeMas(Siete, carta(6, _)):- falsoSiete(Siete).
valeMas(carta(6, _), carta(5, _)).
valeMas(carta(5, _), carta(4, _)).

falsoAs(carta(1, oro)).
falsoAs(carta(1, copa)).
falsoSiete(carta(7, basto)).
falsoSiete(carta(7, copa)).

cartaDeTruco(carta(Numero, Palo)):-
  palo(Palo),
  numeroValido(Numero).

palo(basto).
palo(copa).
palo(oro).
palo(espada).

numeroValido(Numero):-
  between(1, 12, Numero),
  not(between(8, 9, Numero)).

mata(MasValiosa, MenosValiosa):-
  cartaDeTruco(MasValiosa),
  cartaDeTruco(MenosValiosa),
  valeMas(MasValiosa, MenosValiosa).

mata(MasValiosa, MenosValiosa):-
  cartaDeTruco(MasValiosa),
  cartaDeTruco(OtraCarta),
  valeMas(MasValiosa, OtraCarta),
  mata(OtraCarta, MenosValiosa).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% T.E.G. - La revancha
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- use_module(clase3).
% Predicados disponibles para trabajar:

% estaEn(Pais, Continente).
% limitrofes(Pais1, Pais2).
% ocupa(Jugador, Pais, Ejercitos).
% continente(Continente) <- generador basado en estaEn/2

% Sabemos quiénes son los jugadores que participaron de la partida
% más allá de si ocupan países o no, por si alguno fue destruido.
jugador(rojo).
jugador(amarillo).
jugador(verde).
jugador(negro).
jugador(magenta).
jugador(azul).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Problema principal:
% Un jugador ganó el juego si logró cumplir todos sus objetivos.
gano(Jugador):-
  jugador(Jugador),
  forall(objetivo(Jugador, Objetivo),
         cumplioObjetivo(Jugador, Objetivo)).

/*
Inicialmente queremos representar los siguientes:
- Destruir al jugador de un color particular.
- Ocupar un continente indicado.
- Ocupar 3 países limítrofes entre sí en cualquier parte del mapa.
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

% Se cumple si ocupa todos los países del continente
cumplioObjetivo(Jugador, ocupar(Continente)):-
  jugador(Jugador), continente(Continente),
  forall(estaEn(Pais, Continente),
         ocupa(Jugador, Pais, _)).

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


%%%%%% Agregado! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% El magenta tiene que ocupar asia y dos países de americaDelSur
% El rojo tiene que ocupar dos países en todos los continentes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

objetivo(magenta, ocupar(asia)).
objetivo(magenta, ocuparDosPaisesDe(americaDelSur)).

%% Solución por extensión, no está buena, se puede generalizar
/*
objetivo(rojo, ocuparDosPaisesDe(asia)).
objetivo(rojo, ocuparDosPaisesDe(americaDelSur)).
objetivo(rojo, ocuparDosPaisesDe(americaDelNorte)).
objetivo(rojo, ocuparDosPaisesDe(oceania)).
objetivo(rojo, ocuparDosPaisesDe(europa)).
objetivo(rojo, ocuparDosPaisesDe(africa)).
*/

%% Solución por comprensión
objetivo(rojo, ocuparDosPaisesDe(Continente)):-
  continente(Continente).

cumplioObjetivo(Jugador, ocuparDosPaisesDe(Continente)):-
  ocupa(Jugador, Pais1, _),
  estaEn(Pais1, Continente),
  ocupa(Jugador, Pais2, _),
  estaEn(Pais2, Continente),
  Pais1 \= Pais2.