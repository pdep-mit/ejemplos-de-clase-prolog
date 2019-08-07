%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sombrero Seleccionador
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sangre(Mago, Sangre)
sangre(harry, mestiza).
sangre(hermione, impura).
sangre(draco, pura).
sangre(ron, pura).
sangre(hermione, impura).
sangre(hanna, mestiza).

mago(Mago):-
  sangre(Mago, _).

% caracteristica(Mago, Caracteristica)
caracteristica(harry, coraje).
caracteristica(harry, amistad).
caracteristica(harry, orgullo).
caracteristica(harry, inteligencia).

caracteristica(draco, inteligencia).
caracteristica(draco, orgullo).

caracteristica(hermione, inteligencia).
caracteristica(hermione, orgullo).
caracteristica(hermione, coraje).
caracteristica(hermione, responsabilidad).

caracteristica(ron, amistad).
caracteristica(ron, coraje).

% odiaCasa(Mago, Casa)
odiaCasa(harry, slytherin).
odiaCasa(draco, hufflepuff).

% casa(Casa)
casa(gryffindor).
casa(slytherin).
casa(hufflepuff).
casa(ravenclaw).

% caracteristicaImportante(Casa, Caracteristica)
caracteristicaImportante(gryffindor, coraje).
caracteristicaImportante(slytherin, orgullo).
caracteristicaImportante(slytherin, inteligencia).
caracteristicaImportante(ravenclaw, inteligencia).
caracteristicaImportante(ravenclaw, responsabilidad).
caracteristicaImportante(hufflepuff, amistad).

caracterAdecuado(Mago, Casa):-
  mago(Mago),
  casa(Casa),
  forall(caracteristicaImportante(Casa, Caracteristica),
        caracteristica(Mago, Caracteristica)).

puedeSerSeleccionado(Mago, Casa):-
  caracterAdecuado(Mago, Casa),
  not(odiaCasa(Mago, Casa)),
  aceptado(Mago, Casa).

aceptado(Mago, Casa):-
  mago(Mago),
  casa(Casa),
  Casa \= slytherin.
aceptado(Mago, slytherin):-
  mago(Mago),
  not(sangre(Mago, impura)).

podrianSerAmigos(Mago1, Mago2):-
  amistoso(Mago1),
  amistoso(Mago2),
  Mago1 \= Mago2.
podrianSerAmigos(Mago1, Mago2):-
  puedeSerSeleccionado(Mago1, Casa),
  puedeSerSeleccionado(Mago2, Casa),
  Mago1 \= Mago2.

amistoso(Mago):- caracteristica(Mago, amistad).

esMasComplejo(MagoComplejo, OtroMago):-
  complejidadDeCaracter(MagoComplejo, ComplejidadMayor),
  complejidadDeCaracter(OtroMago, ComplejidadMenor),
  ComplejidadMayor > ComplejidadMenor.

complejidadDeCaracter(Mago, Complejidad):-
  mago(Mago),
  findall(Caracteristica, caracteristica(Mago, Caracteristica), Lista),
  length(Lista, Complejidad).

duermeEnElPatio(Mago):-
  mago(Mago),
  not(puedeSerSeleccionado(Mago, _)).
esVersatil(Mago):-
  mago(Mago),
  forall(casa(Casa), puedeSerSeleccionado(Mago, Casa)).

% Solución completa del último ejercicio
seleccionar([], []).
seleccionar([Mago | Magos], [ vaA(Mago, Casa) | MagosSeleccionados ]):-
  seleccionar(Magos, MagosSeleccionados),
  elegirCasaPara(Mago, MagosSeleccionados, Casa).

elegirCasaPara(Mago, _, hufflepuff):-
  duermeEnElPatio(Mago).
elegirCasaPara(Mago, MagosSeleccionados, Casa):-
  puedeSerSeleccionado(Mago, Casa),
  potencial(Casa, MagosSeleccionados, Potencial),
  forall(puedeSerSeleccionado(Mago, UnaCasa),
            (potencial(UnaCasa, MagosSeleccionados, UnPotencial),
  		       Potencial =< UnPotencial)).

% Calcula la sumatoria de la complejidad de los magos
% que fueron seleccionados para esa casa
potencial(Casa, MagosSeleccionados, Potencial):-
    casa(Casa),
    findall(Complejidad,
             	(member(vaA(Mago, Casa), MagosSeleccionados),
               complejidadDeCaracter(Mago, Complejidad)),
              Complejidades),
    sumlist(Complejidades, Potencial).

/*
Ejemplos de respuestas:
?- seleccionar([harry, draco, ron, hanna, hermione], MagosConCasa).
MagosConCasa = [vaA(harry, hufflepuff), vaA(draco, slytherin),
  vaA(ron, hufflepuff), vaA(hanna, hufflepuff), vaA(hermione, gryffindor)] ;
MagosConCasa = [vaA(harry, hufflepuff), vaA(draco, slytherin),
  vaA(ron, gryffindor), vaA(hanna, hufflepuff), vaA(hermione, ravenclaw)] ;
MagosConCasa = [vaA(harry, gryffindor), vaA(draco, slytherin),
  vaA(ron, hufflepuff), vaA(hanna, hufflepuff), vaA(hermione, ravenclaw)] ;
MagosConCasa = [vaA(harry, hufflepuff), vaA(draco, slytherin),
  vaA(ron, gryffindor), vaA(hanna, hufflepuff), vaA(hermione, ravenclaw)] .
*/
