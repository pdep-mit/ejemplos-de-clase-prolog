%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Estudiantes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Modelo sin listas

nota(pepito, parcial, funcional, 2).
nota(pepito, parcial, logico, 10).
nota(pepito, parcial, objetos, 9).
nota(pepito, recu(1), funcional, 9).

nota(juanita, parcial, funcional, 10).
nota(juanita, parcial, objetos, 8).
nota(juanita, recu(1), logico, 10).

nota(tito, parcial, funcional, 2).
nota(tito, recu(1), funcional, 6).
nota(tito, recu(1), logico, 4).
nota(tito, recu(2), logico, 8).

posterior(recu(_), parcial).
posterior(recu(X), recu(Y)):- X > Y.

paradigma(funcional).
paradigma(logico).
paradigma(objetos).

aprobo(Estudiante):-
  nota(Estudiante, _,_,_),
  forall(paradigma(Paradigma),
         aproboTema(Estudiante, Paradigma)).

aproboTema(Estudiante, Tema):-
  ultimaNota(Estudiante, Tema, Nota),
  Nota >= 6.

ultimaNota(Estudiante, Tema, Nota):-
  nota(Estudiante, Examen, Tema, Nota),
  not((nota(Estudiante, Examen2, Tema, _),
       posterior(Examen2, Examen))).

vecesQueRindio(Estudiante, Tema, Veces):-
  nota(Estudiante, _, Tema, _),
  findall(Nota, nota(Estudiante,_,Tema,Nota), Notas),
  length(Notas, Veces).

% Modelo alternativo, con listas

/*
notas(pepito, funcional, [2, 9]).
notas(pepito, logico, [10]).
notas(pepito, objetos, [9]).

notas(juanita, funcional, [10]).
notas(juanita, logico, [8]).
notas(juanita, objetos, [10]).

notas(tito, funcional, [2, 6]).
notas(tito, logico, [4, 8]).

ultimaNota(Estudiante, Tema, Nota):-
  notas(Estudiante, Tema, Notas),
  last(Notas, Nota).

vecesQueRindio(Estudiante, Tema, Veces):-
  notas(Estudiante, Tema, Notas),
  length(Notas, Veces).
*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% T.E.G. - Ahora, es personal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- use_module(teg_final).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
Al principio de cada turno se incorporan ejércitos al mapa.
Queremos saber cuántos ejércitos puede incorporar un jugador. Es la suma de:
- la mitad de los países que ocupa (se redondea para abajo), ó 3 si no llega a los 6 países
- lo que corresponda por cada continente ocupado por completo.
Para cada continente se indica cuántos ejércitos aporta con un predicado ejercitosPorOcupar/2.
*/

% Predicados disponibles para trabajar:
% jugador(Jugador), continente(Continente), ocupa(Jugador, Pais, Ejercitos),
% ocupaContinente(Jugador, Continente), ejercitosPorOcupar(Continente, Ejercitos)

% Problema principal:
% cantidadDeEjercitosAIncorporar(Jugador, Ejercitos)

cantidadDeEjercitosAIncorporar(Jugador, Ejercitos):-
  cantidadDeEjercitosPorPaisesOcupados(Jugador, PorPaises),
  cantidadDeEjercitosPorContinentesOcupados(Jugador, PorContinentes),
  Ejercitos is PorContinentes + PorPaises.

% la mitad de los países que ocupa (se redondea para abajo), ó 3 si no llega a los 6 países
cantidadDeEjercitosPorPaisesOcupados(Jugador, CantidadDeEjercitosAPoner):-
  jugador(Jugador),
  findall(Pais, ocupa(Jugador, Pais, _), Paises),
  length(Paises, CantidadDePaises),
  ejercitosQueDaTotalDePaises(CantidadDePaises, CantidadDeEjercitosAPoner).

ejercitosQueDaTotalDePaises(CantidadDePaises, Ejercitos) :-
  CantidadDePaises >= 6,
  Ejercitos is CantidadDePaises // 2.
ejercitosQueDaTotalDePaises(CantidadDePaises, 3) :-
  CantidadDePaises < 6.

% sumatoria de lo que corresponda por cada continente ocupado por completo
cantidadDeEjercitosPorContinentesOcupados(Jugador, CantidadDeEjercitosAPoner):-
  jugador(Jugador),
  findall(EjercitosPorContinente,
    (ocupaContinente(Jugador, Continente), ejercitosPorOcupar(Continente, EjercitosPorContinente)) ,
    ListaConEjercitos),
  sum_list(ListaConEjercitos, CantidadDeEjercitosAPoner).
