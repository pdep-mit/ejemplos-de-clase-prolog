%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% La familia Simpson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Repaso de la clase anterior
%% Arrancamos con esta base de conocimiento

padre(abraham, herbert).
padre(abraham, homero).
padre(mona, homero).
padre(clancy, marge).
padre(jacqueline, marge).
padre(clancy, patty).
padre(jacqueline, patty).
padre(clancy, selma).
padre(jacqueline, selma).
padre(homero, bart).
padre(marge, bart).
padre(homero, lisa).
padre(marge, lisa).
padre(homero, maggie).
padre(marge, maggie).
padre(selma, ling).

edad(homero, 36).
edad(marge, 34).
edad(patty, 45).
edad(selma, 45).
edad(lisa, 8).
edad(bart, 10).
edad(maggie, 1).
edad(herbert, 30).

%% Definir los siguientes predicados:

% hermanos/2: dos personas que tienen el mismo padre
hermanos(Persona1, Persona2) :-
  padre(Padre, Persona1),
  padre(Padre, Persona2),
  Persona1 \= Persona2.

% abuelo/2: si el primero es el padre del padre del segundo
abuelo(Abuelo, Nieto) :-
  padre(Abuelo, Padre),
  padre(Padre, Nieto).

% mellizos/2: hermanos de la misma edad

mellizos(Persona1, Persona2) :-
  hermanos(Persona1, Persona2),
  mismaEdad(Persona1, Persona2).

mismaEdad(Persona1, Persona2):-
  edad(Persona1, Edad),
  edad(Persona2, Edad).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% hijoUnico/1: alguien que no tiene hermanos
hijoUnico(Persona) :-
  padre(_, Persona),
  not( hermanos(Persona, _) ).

% abueloCompleto/1: todos sus hijos tienen hijos

abueloCompletoConNot(Persona) :-
  abuelo(Persona, _),
  not(
   (padre(Persona, Hijo),
   not(tieneHijos(Hijo)))
  ).

abueloCompleto(Persona) :-
  abuelo(Persona, _),
  forall(padre(Persona, Hijo), tieneHijos(Hijo)).

tieneHijos(Persona) :- padre(Persona, _).

% esHijoMenor/1: personas que, sin ser hijos únicos,
% sólo tienen hermanos mayores

esHijoMenor(Persona) :-
  padre(_, Persona),
  not(hijoUnico(Persona)),
  forall(hermanos(Persona, Hermano),
    esMayor(Hermano, Persona)).

esMayor(PersonaMayor, PersonaMenor):-
  edad(PersonaMayor, EdadMayor),
  edad(PersonaMenor, EdadMenor),
  EdadMayor > EdadMenor.

% Para practicar:
% tieneCanasVerdes/1: todos sus hijos tienen menos de 15 años
