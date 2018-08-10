
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


masBuscado(dimitri).
masBuscado(villanelle).

empleado(UnEmpleado):-
detective(UnEmpleado).
empleado(UnEmpleado):-
secretaria(UnEmpleado).
empleado(UnEmpleado):-
sargento(UnEmpleado).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cantidadEmpleados(Jefe,CantidadEmpleados):-
findall(Empleado,esJefeDe(Jefe,Empleado),Empleados),
length(Empleados,CantidadEmpleados).

esJefeDe(Jefe,Empleado):-
detective(Empleado),
sargento(Jefe).

esJefeDe(Jefe,Empleado):-
capitan(Jefe),
empleado(Empleado),
not(capitan(Empleado)).

mejorDetective(Detective):-
puntos(Detective,MasPuntos),
forall((puntos(OtroDetective,OtrosPuntos),Detective\=OtroDetective),MasPuntos>OtrosPuntos).

puntos(Detective,Puntos):-
detective(Detective),
findall(PuntosCaso,puntosPorCaso(Detective,Caso,PuntosCaso),ListaPuntos),
sumlist(ListaPuntos,Puntos).

puntosPorPeligrosidad(Caso,20):-
caso(_,Caso,_),
peligroso(Caso).

puntosPorPeligrosidad(Caso,0):-
caso(_,Caso,_),
not(peligroso(Caso)).

puntosPorCaso(Detective,Caso,PuntosCaso):-
caso(_,Caso,Detectives),
member(Detective,Detectives),
puntosCompania(Detectives,PuntosPorCompania),
puntosPorPeligrosidad(Caso,PuntosPeligrosidad),
PuntosCaso is 5+PuntosPorCompania+PuntosPeligrosidad.

peligroso(tomaRehenes(_)).

peligroso(secuestro(_,Secuestrado)):-
importante(Secuestrado).

importante(Alguien):-
famoso(Alguien).

importante(Alguien):-
testigo(Alguien).

peligroso(Caso):-
criminales(Caso,Criminales),
member(Criminal,Criminales),
masBuscado(Criminal).

criminales(secuestro(Criminales,_),Criminales).
criminales(tirarBasura(Criminal),[Criminal]).

puntosCompania([_],10).
puntosCompania([_,_],5).
puntosCompania(Detectives,0):-
length(Detectives,Cant),
Cant>2.



