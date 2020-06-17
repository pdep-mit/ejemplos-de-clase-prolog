%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Introducción
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

humano(socrates).

mortal(Alguien):-
	humano(Alguien).
mortal(lassie).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Programadores
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% programaEn/2 relaciona una persona con un lenguaje

programaEn(nahuel, javascript).
programaEn(juan, haskell).
programaEn(juan, ruby).
programaEn(caro, haskell).
programaEn(caro, scala).

%% colegas/2 relaciona dos personas si programan en un mismo lenguaje

colegas(Persona, Colega):-
  programaEn(Persona, Lenguaje),
	programaEn(Colega, Lenguaje),
	Persona \= Colega.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% La familia
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% hije/2 Se cumple si la segunda persona es padre/madre de la primera
hije(herbert, abraham).
hije(homero, abraham).
hije(homero, mona).
hije(marge, clancy).
hije(marge, jacqueline).
hije(patty, clancy).
hije(patty, jacqueline).
hije(selma, clancy).
hije(selma, jacqueline).
hije(bart, homero).
hije(bart, marge).
hije(lisa, homero).
hije(lisa, marge).
hije(maggie, homero).
hije(maggie, marge).
hije(ling, selma).

% hermanes/2 se cumple si ambas personas son hijas de una persona en común.

% descendiente/2 se cumple si la primera persona es descendiente de la segunda