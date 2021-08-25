%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Práctica Integradora - One Piece
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Relaciona Pirata con Tripulacion
tripulante(luffy, sombreroDePaja).
tripulante(zoro, sombreroDePaja).
tripulante(nami, sombreroDePaja).
tripulante(ussop, sombreroDePaja).
tripulante(sanji, sombreroDePaja).
tripulante(chopper, sombreroDePaja).
tripulante(law, heart).
tripulante(bepo, heart).
tripulante(arlong, piratasDeArlong).
tripulante(hatchan, piratasDeArlong).

% Relaciona Pirata, Evento y Monto
impactoEnRecompensa(luffy, arlongPark, 30000000).
impactoEnRecompensa(luffy, baroqueWorks, 70000000).
impactoEnRecompensa(luffy, eniesLobby, 200000000).
impactoEnRecompensa(luffy, marineford, 100000000).
impactoEnRecompensa(luffy, dressrosa, 100000000).
impactoEnRecompensa(zoro, baroqueWorks, 60000000).
impactoEnRecompensa(zoro, eniesLobby, 60000000).
impactoEnRecompensa(zoro, dressrosa, 200000000).
impactoEnRecompensa(nami, eniesLobby, 16000000).
impactoEnRecompensa(nami, dressrosa, 50000000).
impactoEnRecompensa(ussop, eniesLobby, 30000000).
impactoEnRecompensa(ussop, dressrosa, 170000000).
impactoEnRecompensa(sanji, eniesLobby, 77000000).
impactoEnRecompensa(sanji, dressrosa, 100000000).
impactoEnRecompensa(chopper, eniesLobby, 50).
impactoEnRecompensa(chopper, dressrosa, 100).
impactoEnRecompensa(law, sabaody, 200000000).
impactoEnRecompensa(law, descorazonamientoMasivo, 240000000).
impactoEnRecompensa(law, dressrosa, 60000000).
impactoEnRecompensa(bepo, sabaody, 500).
impactoEnRecompensa(arlong, llegadaAEastBlue,20000000).
impactoEnRecompensa(hatchan, llegadaAEastBlue, 3000).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Punto 1

seCruzaronEn(Tripulacion1, Tripulacion2, Evento):-
  participoEnEvento(Tripulacion1, Evento),
  participoEnEvento(Tripulacion2, Evento),
  Tripulacion1 \= Tripulacion2.

participoEnEvento(Tripulacion, Evento):-
  tripulante(Pirata, Tripulacion),
  impactoEnRecompensa(Pirata, Evento, _).

% Punto 2

/*
pirataQueMasSeDestaco(PirataDestacado, Evento):-
  impactoEnRecompensa(PirataDestacado, Evento, MontoMayor),
  not((impactoEnRecompensa(Pirata, Evento, Monto),
       Pirata \= PirataDestacado, Monto > MontoMayor)).
*/

pirataQueMasSeDestaco(PirataDestacado, Evento):-
  impactoEnRecompensa(PirataDestacado, Evento, MontoMayor),
  forall(
    (impactoEnRecompensa(Pirata, Evento, Monto), Pirata \= PirataDestacado), Monto =< MontoMayor).

% Punto 3

pasoDesapercibido(Pirata, Evento):-
  tripulante(Pirata, Tripulacion),
  participoEnEvento(Tripulacion, Evento),
  not(impactoEnRecompensa(Pirata, Evento, _)).

% Punto 4

recompensaTotal(Tripulacion, RecompensaTotal):-
  tripulante(_, Tripulacion),
  findall(RecompensaPirata,
    (tripulante(Pirata, Tripulacion), recompensaActual(Pirata, RecompensaPirata)),
    Recompensas),
  sum_list(Recompensas, RecompensaTotal).

recompensaActual(Pirata, RecompensaPirata):-
  tripulante(Pirata, _),
  findall(Recompensa, impactoEnRecompensa(Pirata, _, Recompensa), Recompensas),
  sum_list(Recompensas, RecompensaPirata).

% Punto 5

temible(Tripulacion):-
  recompensaTotal(Tripulacion, RecompensaTotal),
  RecompensaTotal > 500000000.
temible(Tripulacion):-
  tripulante(_, Tripulacion),
  forall(tripulante(Pirata, Tripulacion), esPeligroso(Pirata)).

esPeligroso(Pirata):-
  recompensaActual(Pirata, Recompensa),
  Recompensa > 100000000.

% Punto 6

esPeligroso(Pirata):-
  comioFruta(Pirata, Fruta),
  frutaPeligrosa(Fruta).

comioFruta(luffy, paramecia(gomugomu)).
comioFruta(buggy, paramecia(barabara)).
comioFruta(law, paramecia(opeope)).
comioFruta(chopper, zoan(hitohito, humano)).
comioFruta(lucci, zoan(nekoneko, leopardo)).
comioFruta(smoker, logia(mokumoku, humo)).

frutaPeligrosa(paramecia(opeope)).
frutaPeligrosa(zoan(_, Especie)):-
  feroz(Especie).
frutaPeligrosa(logia(_,_)).

feroz(lobo).
feroz(leopardo).
feroz(anaconda).

/*
Esto no se pedía, fue para mostrar nada más cómo podría relacionarse una fruta con su nombre, o con su tipo si fuera necesario
*/
nombreDeFruta(paramecia(Nombre), Nombre).
nombreDeFruta(zoan(Nombre, _), Nombre).
nombreDeFruta(logia(Nombre, _), Nombre).

tipoDeFruta(paramecia(_), paramecia).
tipoDeFruta(zoan(_, _), zoan).
tipoDeFruta(logia(_, _), logia).

%% Punto 7

/*
piratasDeAsfalto(Tripulacion):-
  tripulante(_, Tripulacion),
  forall(tripulante(Pirata, Tripulacion), not(puedeNadar(Pirata))).
*/

piratasDeAsfalto(Tripulacion):-
  tripulante(_, Tripulacion),
  not((tripulante(Pirata, Tripulacion), puedeNadar(Pirata))).

puedeNadar(Persona):-
  tripulante(Persona, _),
  not(comioFruta(Persona, _)).