%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  BROOKLYN 9-9
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% La comisaría 99 de Brooklyn nos pidió que con nuestros conocimientos de Prolog
% le ayudemos a resolver cuestiones de vital importancia para la seguridad de Nueva York.
% Disponemos de la siguiente información:

% Personal de la comisaría
detective(jake).
detective(amy).
detective(rosa).
detective(charles).
detective(hitchcock).
detective(scully).
sargento(terry).
secretaria(gina).
capitan(ray).

% Testigos
testigo(billy).
testigo(johanna).
testigo(leo).

% Famosos
famoso(vikyXipolitakis).
famoso(marley).
famoso(susana).

% caso(Id, Caso, Detectives) donde Caso puede ser de cualquiera de estas formas:
% - robo(Criminales, CosaRobada),
% - estafa(Criminales),
% - homicidio(Criminales, Asesinado),
% - secuestro(Criminales, Secuestrado),
% - tomaRehenes(Criminales)

caso(1, robo([bryan, johnny], cartera), [jake,charles]).
caso(2, estafa([rihanna, cate, sandra, sarah]), [rosa,amy]).
caso(3, homicidio([norma, norman], missWatson), [hitchcock]).
caso(4, secuestro([fumador, garganta], leo), [scully]).
caso(5, tomaRehenes([karl, kristoff, hans]), [jake,rosa]).
caso(6, homicidio([dimitri, villanelle], billy), [amy, charles]).
caso(7, estafa([parker, elliot, hardison, hans]), [jake]).

%% Requerimiento: Precisan saber cuántos empleados tiene cada jefe.
%% Su estructura jerárquica establece que el capitán es jefe de todos, y el sargento de los detectives.

cantidadEmpleados(Jefe,CantidadEmpleados):-
  esJefeDe(Jefe, _), % Para que sea inversible y además nos diga falso consultar cantidadEmpleados(jake, _)
  findall(Empleado,esJefeDe(Jefe,Empleado),Empleados),
  length(Empleados,CantidadEmpleados).

esJefeDe(Jefe,Empleado):-
  detective(Empleado),
  sargento(Jefe).

esJefeDe(Jefe,Empleado):-
  capitan(Jefe),
  empleado(Empleado),
  not(capitan(Empleado)).

empleado(UnEmpleado):-
  detective(UnEmpleado).
empleado(UnEmpleado):-
  secretaria(UnEmpleado).
empleado(UnEmpleado):-
  sargento(UnEmpleado).

%% Requerimiento: También les gustaría saber quién es el mejor detective.
%% Esto se decide según quién tenga más puntos, problema que abordaremos más adelante.

mejorDetective(Detective):-
  puntos(Detective,MasPuntos),
  forall((puntos(OtroDetective,OtrosPuntos), Detective\=OtroDetective),
    MasPuntos > OtrosPuntos).

%% Observación: No es necesario armar un conjunto con los detectives para determinar
%% quién tiene el puntaje máximo.

%% Para determinar los puntos de un detective: es la suma de los puntos que le da cada caso resuelto.
%% Por resolver un caso, se obtienen 5 puntos.
%% Adicionalmente si lo resolvió solo le da 10 más, o 5 si como máximo tuvo un sólo compañero;
%% y si fue peligroso, suma 20 puntos más.
%% Un caso es peligroso si es una toma de rehenes, un secuestro de alguien importante (testigo o famoso)
%% o hay un criminal que pertenece a los más buscados.
%% Actualmente los más buscados son Norman, Hans y Villanelle.

puntos(Detective,Puntos):-
  detective(Detective),
  findall(PuntosCaso, puntosPorCaso(Detective, _, PuntosCaso), ListaPuntos),
  sumlist(ListaPuntos,Puntos).

% Este predicado debería ser inversible mínimamente para la tercer aridad para que funcione
% el predicado puntos/2. Sin embargo es una abstracción interesante, vale la pena hacerlo inversible.

puntosPorCaso(Detective,Caso,PuntosCaso):-
  caso(_,Caso,Detectives),
  member(Detective,Detectives),
  puntosCompania(Detectives,PuntosPorCompania),
  puntosPeligrosidad(Caso,PuntosPorPeligrosidad),
  PuntosCaso is 5 + PuntosPorCompania + PuntosPorPeligrosidad.

% No es necesario que sea inversible para el uso que pensamos darle,
% y no es una abstracción que posiblemente querramos consultar fuera de este contexto
% que amerite hacerlo inversible, a diferencia de puntosPorCaso/3.
puntosCompania([_],10).
puntosCompania([_,_],5).
puntosCompania(Detectives,0):-
  length(Detectives,Cant),
  Cant>2.

% Tampoco lo hicimos inversible, por los mismos motivos que puntosCompania/2.
% Si se quisiera hacer inversible, alcanza con consultar el predicado caso/3 en ambas reglas.
puntosPeligrosidad(Caso,20):-
  peligroso(Caso).

puntosPeligrosidad(Caso,0):-
  not(peligroso(Caso)).

% Idem, no vamos a pretender preguntar cuáles casos son peligrosos, podemos no hacerlo inversible.
peligroso(tomaRehenes(_)).

peligroso(secuestro(_,Secuestrado)):-
  importante(Secuestrado).

peligroso(Caso):-
  criminales(Caso,Criminales),
  member(Criminal,Criminales),
  masBuscado(Criminal).

importante(Alguien):- famoso(Alguien).
importante(Alguien):- testigo(Alguien).

masBuscado(norman).
masBuscado(hans).
masBuscado(villanelle).

criminales(secuestro(Criminales,_),Criminales).
criminales(robo(Criminales, _), Criminales).
criminales(estafa(Criminales), Criminales).
criminales(homicidio(Criminales, _), Criminales).
criminales(tomaRehenes(Criminales), Criminales).

criminales(tirarBasura(Criminal),[Criminal]).
%% El crimen de tirar basura lo agregamos en el momento para mostrar un ejemplo para el cual el crimen
%% no tenga una lista de criminales en su forma. Armamos la lista para que sea consistente
%% con el uso que queremos darle.

%% Si hubiera un tipo de crimen distinto para el cual no hubieran criminales en absoluto,
%% se podría decidir si relacionar a ese tipo de crimen con la lista vacía, o si no definir
%% una cláusula para criminales/2 para ese tipo de crimen, de modo que consultar quiénes fueron
%% los criminales del mismo responda falso.
