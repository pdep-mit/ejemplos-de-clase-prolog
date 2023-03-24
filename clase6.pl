%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Se ha formado una pareja - Ej. 9.5 de Mumuki 
%%%%% Consignas: https://github.com/pdep-utn/mumuki-guia-logico-practica-functores-pdep-utn/blob/master/00502_Se%20ha%20formado%20una%20pareja/description.md
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
Predicados disponibles:
- preferencia(Persona, Preferencia, OtraPersona)
- parejaPosible(Persona, Pareja)
  - pareja/3
- mejorPareja(Persona, MejorPareja).
- mayorCompatibilidad(UnaPareja, MejorPareja)
- seVanAPelear(Pareja1, Pareja2)
*/

% Ana prefiere a Luis antes que a Juan y a Juan antes que a Pedro.
preferencia(ana, 1,luis).
preferencia(ana, 2, juan).
preferencia(ana, 3, pedro).
preferencia(nora, 3,luis).
preferencia(nora, 1, juan).
preferencia(nora, 2, pedro).
preferencia(marta, 2,luis).
preferencia(marta, 3, juan).
preferencia(marta, 1, pedro).
preferencia(luis, 1, ana).
preferencia(luis, 2, nora).
preferencia(luis, 3, marta).
preferencia(juan, 1, marta).
preferencia(juan, 2, ana).
preferencia(juan, 3, nora).
preferencia(pedro, 3, nora).
preferencia(pedro, 2, marta).
preferencia(pedro, 1, ana).
preferencia(milhouse, 1, ana).
preferencia(milhouse, 2, marta).
preferencia(milhouse, 3, nora).

/*
parejaPosible/2
Relaciona a una persona con un functor pareja/3 compuesto por las dos personas de la pareja y el grado de compatibilidad entre ambas, el cual se calcula como 6 - el nivel de preferencia de cada persona por la otra.

Si una de las dos personas no está interesada en la otra, no será una pareja posible.

Por ejemplo, las parejas posibles para Ana serían los functores pareja(ana, luis, 4), pareja(ana, juan, 2) y pareja(ana, pedro, 2).
*/

parejaPosible(Persona, pareja(Persona, OtraPersona, Compatibilidad)):-
  preferencia(Persona, Preferencia1, OtraPersona),
  preferencia(OtraPersona, Preferencia2, Persona),
  Compatibilidad is 6 - Preferencia1 -Preferencia2.

/*
mejorPareja/2
Relaciona a una persona con una pareja posible, de modo que se maximice el grado de compatibilidad. Podría haber más de una, en le caso de que el grado de compatibilidad sea el mismo.
*/

mejorPareja(Persona, MejorPareja):-
  parejaPosible(Persona, MejorPareja),
  not(( parejaPosible(Persona, UnaPareja),
        mayorCompatibilidad(UnaPareja, MejorPareja) )).

mayorCompatibilidad(pareja(_,_,CompatibilidadMayor), pareja(_,_,CompatibilidadMenor)):-
   CompatibilidadMayor > CompatibilidadMenor.


/*
seVanAPelear/2
Relaciona dos parejas posibles compuestas por personas distintas si una de las personas de la primer pareja quiere dejar a la otra por una persona de la otra pareja.

Una persona A quiere dejar a otra B si existe una tercera C tal que:
- A prefiere a C antes que a B, y
- C prefiere a A antes que a su pareja (la que tiene asignada en el contexto).

Ejemplo: entre las parejas Ana-Pedro y Nora-Luis, hay problemas dado que Ana prefiere a Luis antes que a Pedro, y Luis prefiere a Ana antes que a Nora.

Además también será cierto si sólo uno de los integrantes de la primer pareja también integra la segunda, por ejemplo Ana-Pedro y Luis-Ana.
*/

seVanAPelear(Pareja1, Pareja2):-
  parejaPosible(_, Pareja1),
  parejaPosible(_, Pareja2),
  integrantesDistintos(Pareja1, Pareja2),
  seDejarian(Pareja1, Pareja2).

/*
seVanAPelear(Pareja1, Pareja2):-
  parejaPosible(_, Pareja1),
  parejaPosible(_, Pareja2),
  integrante(Pareja1, PersonaQueEngania),
  integrante(Pareja2, PersonaQueEngania),
  not(( integrante(Pareja2, Otra),
        Otra \= PersonaQueEngania,
        integrante(Pareja1, Otra) )).
*/

seVanAPelear(Pareja1, Pareja2):-
  parejaPosible(_, Pareja1),
  parejaPosible(_, Pareja2),
  integranteEnComun(Pareja1, Pareja2, PersonaQueEngania),
  not((integranteEnComun(Pareja1, Pareja2, Otra), Otra \= PersonaQueEngania)).

integrante(pareja(Persona, _,_), Persona).
integrante(pareja(_, Persona,_), Persona).

integranteEnComun(Pareja1, Pareja2, Persona):-
  integrante(Pareja1, Persona),
  integrante(Pareja2, Persona).

integrantesDistintos(Pareja1, Pareja2):-
  not(integranteEnComun(Pareja1, Pareja2, _)).

/*
integrantesDistintos(Pareja1, Pareja2):-
  integrante(Pareja1, Integrante1),
  integrante(Pareja1, Integrante2),
  integrante(Pareja2, Integrante3),
  integrante(Pareja2, Integrante4),
  Integrante1 \= Integrante3,
  Integrante1 \= Integrante4,
  Integrante2 \= Integrante3,
  Integrante2 \= Integrante4.
*/

/*
Una persona A quiere dejar a otra B si existe una tercera C tal que:
- A prefiere a C antes que a B, y
- C prefiere a A antes que a su pareja (la que tiene asignada en el contexto).
*/

% Fe de erratas: en la solución hecha en clase se estaba consultando al revés integrante/2
seDejarian(Pareja1, Pareja2):-
  integrante(Pareja1, PersonaA),
  integrante(Pareja1, PersonaB),
  integrante(Pareja2, PersonaC),
  integrante(Pareja2, PersonaD),
  prefiereAntesQue(PersonaA, PersonaC, PersonaB),
  prefiereAntesQue(PersonaC, PersonaA, PersonaD).

prefiereAntesQue(Persona, Preferida, OtraPersona):-
  preferencia(Persona, PreferenciaMejor, Preferida),
  preferencia(Persona, OtraPreferencia, OtraPersona),
  PreferenciaMejor < OtraPreferencia.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Viajes - Ej. 11.10 de Mumuki
%%%%% Consignas: https://github.com/pdep-utn/mumuki-guia-logico-practica-listas/blob/master/00004_viajes/description.md
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
Predicados disponibles:
- vuelo(Codigo de vuelo, capacidad en toneladas, [lista de destinos] ), compuestos por functores:
  - escala(ciudad, tiempo de espera)
  - tramo(tiempo en vuelo)

- tiempoTotalVuelo(Vuelo, TiempoTotal)
- duracion(Destino, Tiempo)
- destino(Vuelo, Destino)

- escalaAburrida(Vuelo, Escala)
- escalaDeVuelo(Vuelo, Escala)

- vueloLargo(Vuelo)
- tramoDeVuelo(Vuelo, Destino)

- conectados(Vuelo1, Vuelo2)
- pasaPorCiudad(Vuelo, Ciudad)
- ciudad(Destino, Ciudad)
*/
vuelo(arg845, 30, [escala(rosario,0), tramo(2), escala(buenosAires,0)]).
vuelo(mh101, 95, [escala(kualaLumpur,0), tramo(9), escala(capeTown,2), tramo(15), escala(buenosAires,0)]).
vuelo(dlh470, 60, [escala(berlin,0), tramo(9), escala(washington,2), tramo(2), escala(nuevaYork,0)]).
vuelo(aal1803, 250, [escala(nuevaYork,0), tramo(1), escala(washington,2),tramo(3), escala(ottawa,3), tramo(15), escala(londres,4), tramo(1), escala(paris,0)]).
vuelo(ble849, 175, [escala(paris,0), tramo(2), escala(berlin,1), tramo(3), escala(kiev,2), tramo(2), escala(moscu,4), tramo(5), escala(seul,2), tramo(3), escala(tokyo,0)]).
vuelo(npo556, 150, [escala(kiev,0), tramo(1), escala(moscu,3), tramo(5), escala(nuevaDelhi,6), tramo(2), escala(hongKong,4), tramo(2),escala(shanghai,5), tramo(3), escala(tokyo,0)]).
vuelo(dsm3450, 75, [escala(santiagoDeChile,0), tramo(1), escala(buenosAires,2), tramo(7), escala(washington,4), tramo(15), escala(berlin,3), tramo(15), escala(tokyo,0)]).
/*
Siempre se comienza de una ciudad (escala) y se termina en otra (no puede terminar en el aire al vuelo), con tiempo de vuelo entre medio de las ciudades. Considerar que los viajes son de ida y de vuelta por la misma ruta.

Definir los siguientes predicados; en todos vamos a identificar cada vuelo por su código:
*/

/*
tiempoTotalVuelo/2: que relaciona un vuelo con el tiempo que lleva en total, contando las esperas en las escalas (y eventualmente en el origen y/o destino) más el tiempo de vuelo.
*/

tiempoTotalVuelo(Vuelo, TiempoTotal):-
  vuelo(Vuelo, _, _),
  findall(Duracion, (destino(Vuelo, Destino), duracion(Destino, Duracion)), Tiempos),
  sum_list(Tiempos, TiempoTotal).

duracion(escala(_, TiempoDeEspera), TiempoDeEspera).
duracion(tramo(TiempoEnVuelo), TiempoEnVuelo).

destino(Vuelo, Destino):-
  vuelo(Vuelo, _, Destinos),
  member(Destino, Destinos).


/*
escalaAburrida/2: Relaciona un vuelo con cada una de sus escalas aburridas; una escala es aburrida si hay que esperar mas de 3 horas.
*/

escalaAburrida(Vuelo, Escala):-
  escalaDeVuelo(Vuelo, Escala),
  duracion(Escala, Duracion),
  Duracion > 3.

escalaDeVuelo(Vuelo, escala(Ciudad, Duracion)):-
  destino(Vuelo, escala(Ciudad, Duracion)).


/*
vueloLargo/1: Si un vuelo pasa 10 o más horas en el aire, entonces es un vuelo largo. OJO que dice "en el aire", en este punto no hay que contar las esperas en tierra.
*/

tramoDeVuelo(Vuelo, tramo(Duracion)):-
  destino(Vuelo, tramo(Duracion)).

vueloLargo(Vuelo):-
  vuelo(Vuelo, _, _),
  findall(Duracion, (tramoDeVuelo(Vuelo, Destino), duracion(Destino, Duracion)), Tiempos),
  sum_list(Tiempos, TiempoEnElAire),
  TiempoEnElAire > 10.

/*
vueloLento/1: Un vuelo es lento si no es largo, y además cada escala es aburrida.
*/

vueloLento(Vuelo):-
  vuelo(Vuelo, _,_),
  not(vueloLargo(Vuelo)),
  forall(escalaDeVuelo(Vuelo, Escala), escalaAburrida(Vuelo, Escala)).

/*
conectados/2: Relaciona 2 vuelos si tienen al menos una ciudad en común.
*/

conectados(Vuelo1, Vuelo2):-
  pasaPorCiudad(Vuelo1, Ciudad),
  pasaPorCiudad(Vuelo2, Ciudad),
  Vuelo1 \= Vuelo2.

pasaPorCiudad(Vuelo, Ciudad):-
  destino(Vuelo, Destino),
  ciudad(Destino, Ciudad).

ciudad(escala(Ciudad, _), Ciudad).

/*
bandaDeTres/3: relaciona 3 vuelos si están conectados, el primero con el segundo, y el segundo con el tercero.
*/

bandaDeTres(Vuelo1, Vuelo2, Vuelo3):-
  conectados(Vuelo1, Vuelo2),
  conectados(Vuelo2, Vuelo3),
  Vuelo1 \= Vuelo3.

/*
distanciaEnEscalas/3: relaciona dos ciudades que son escalas del mismo vuelo y la cantidad de escalas entre las mismas; si no hay escalas intermedias la distancia es 1. No importa de qué vuelo, lo que tiene que pasar es que haya algún vuelo que tenga como escalas a ambas ciudades. Por ejemplo:
- París y Berlín están a distancia 1 (por el vuelo BLE849)
- Berlín y Seúl están a distancia 3 (por el mismo vuelo).
*/

distanciaEnEscalas(Ciudad1, Ciudad2, Distancia):-
  vuelo(_, _, Destinos),
  nth1(M, Destinos, escala(Ciudad1, _)),
  nth1(N, Destinos, escala(Ciudad2, _)),
  findall(CiudadIntermedia,
    (nth1(X, Destinos, escala(CiudadIntermedia, _)),
    entre(M, N, X)),
    CiudadesIntermedias),
  length(CiudadesIntermedias, CantCiudadesIntermedias),
  Distancia is 1 + CantCiudadesIntermedias.

entre(Superior, Inferior, X):-
  Inferior < X, Superior > X.
entre(Inferior, Superior, X):-
  Inferior < X, Superior > X.

/*
distanciaEnEscalas(Ciudad1, Ciudad2, Distancia):-
  vuelo(_, _, Destinos),
  findall(Ciudad, member(escala(Ciudad, _), Destinos), Ciudades),
  nth1(M, Ciudades, Ciudad1),
  nth1(N, Ciudades, Ciudad2),
  Distancia is abs(N - M).
*/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% TESTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- begin_tests('se ha formado una pareja').

test(ana_y_luis_forman_pareja, nondet):-
	parejaPosible(ana, pareja(ana,luis, _)).

test(nadie_quiere_a_milhouse, fail):-
  parejaPosible(milhouse, _).

test(compatibilidad_ana_juan, [true(Compatibilidad == 2), nondet]):-
  parejaPosible(ana, pareja(ana, juan, Compatibilidad)).

test(parejas_posibles_de_ana, set(Pareja==[pareja(ana, luis, 4), pareja(ana, juan, 2), pareja(ana, pedro, 2)])):-
  parejaPosible(ana,Pareja).

test(pueden_ser_aparejados, set(Persona==[ana, luis, juan, pedro, nora, marta])):-
  parejaPosible(Persona, _).

test(mejor_pareja_de_ana, set(Pareja == [pareja(ana, luis, 4) ])):-
  mejorPareja(ana, Pareja).

test(mejor_pareja_de_ana, set(Pareja == [pareja(ana, luis, 4) ])):-
  mejorPareja(ana, Pareja).

test(juan_tiene_muchas_mejores_parejas, set(Pareja == [pareja(juan, marta, 2), pareja(juan, ana, 2), pareja(juan, nora, 2) ])):-
  mejorPareja(juan, Pareja).

test(se_pelean_por_enganio, nondet):-
  seVanAPelear(pareja(juan, marta, _), pareja(ana, juan, _)).

test(se_pelean_por_dejarse, nondet):-
  seVanAPelear(pareja(pedro, ana, _), pareja(nora, luis, _)).

:- end_tests('se ha formado una pareja').

:- begin_tests(viajes).
test('la consulta tiempoTotalVuelo(arg845, 2) es verdadera') :-
  tiempoTotalVuelo(arg845, 2).

test('la consulta escalaAburrida(ble849, escala(moscu, 4)) es verdadera', [nondet]) :-
  escalaAburrida(ble849, escala(moscu, 4)).

test('la consulta escalaAburrida(npo556, escala(nuevaDelhi, 6)) es verdadera', [nondet]) :-
  escalaAburrida(npo556, escala(nuevaDelhi, 6)).


test('la consulta escalaAburrida(npo556, escala(kiev,0)) es falsa', [fail]) :-
  escalaAburrida(npo556, escala(kiev,0)).

test('la consulta vueloLargo(dsm3450) es verdadera') :-
  vueloLargo(dsm3450).

test('la consulta conectados(ble849, npo556) es verdadera (porque tienen a moscu en común)', [nondet]) :-
  conectados(ble849, npo556).

test('la consulta conectados(arg845, dsm3450) es verdadera (porque tienen a buenosAires en común)', [nondet]) :-
  conectados(arg845, dsm3450).

test('la consulta conectados(dlh470, ble849) es verdadera (porque tienen a berlin en común)', [nondet]) :-
  conectados(dlh470, ble849).

test('la consulta bandaDeTres(arg845, dsm3450, ble849) es verdadera', [nondet]) :-
  bandaDeTres(arg845, dsm3450, ble849).

test('la distancia en escalas paris-berlin es 1'):-
  distanciaEnEscalas(paris, berlin, X),
  assertion( X =:= 1).

test('la distancia en escalas rosario-buenosAires es 1'):-
  distanciaEnEscalas(rosario, buenosAires, X),
  assertion( X =:= 1 ).

test('la consulta vueloLento(arg845) es falsa', fail):-
  vueloLento(arg845).
test('la consulta vueloLento(npo556) es falsa', fail):-
  vueloLento(npo556).
test('la consulta vueloLento(aal1803) es falsa', fail):-
  vueloLento(aal1803).

:- end_tests(viajes).
