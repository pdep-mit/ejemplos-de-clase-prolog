%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pulp Fiction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Nota: pusimos +Param para indicar si es inversible y -Param si no lo es.

% personaje(+Personaje, +Actividad)
personaje(pumkin, ladron(estacionesDeServicio)).
personaje(pumkin, ladron(licorerias)).
personaje(honeyBunny, ladron(estacionesDeServicio)).
personaje(vincent, mafioso(maton)).
personaje(jules, mafioso(maton)).
personaje(marsellus, mafioso(capo)).
personaje(winston, mafioso(resuelveProblemas)).
personaje(mia, actriz(1, drama)).
personaje(mia, actriz(2, musical)).
personaje(marilyn, actriz(10, musical)).
personaje(butch, boxeador).

% pareja(+Personaje1, +Personaje2) no simetrico
pareja(marsellus, mia).
pareja(pumkin, honeyBunny).

% sonPareja(+Personaje1, +Personaje2) que sí es simetrico
sonPareja(Personaje1, Personaje2):-
  pareja(Personaje2, Personaje1).
sonPareja(Personaje1, Personaje2):-
  pareja(Personaje1, Personaje2).

% trabajaPara(+Empleador, +Empleado) no simetrico a proposito
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

% amigo(+Personaje1, +Personaje2) no simetrico
amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

% sonAmigos(+Personaje1, +Personaje2) que sí es simetrico
sonAmigos(Personaje1, Personaje2):-
  amigo(Personaje2, Personaje1).
sonAmigos(Personaje1, Personaje2):-
  amigo(Personaje1, Personaje2).

% esPeligroso(+Personaje)
esPeligroso(Personaje):-
  trabajaPara(Personaje, Empleado),
  esPeligroso(Empleado) .

esPeligroso(Personaje):-
  actividadPeligrosa(Actividad),
  personaje(Personaje, Actividad).

% actividadPeligrosa(+Actividad)
actividadPeligrosa(mafioso(maton)).
actividadPeligrosa(ladron(licorerias)).

% duoTemible(+Personaje1, +Personaje2) es simétrico porque sonDuo/2 lo es
duoTemible(Personaje1, Personaje2):-
  esPeligroso(Personaje1),
  esPeligroso(Personaje2),
  sonDuo(Personaje1, Personaje2).

% sonDuo(+Personaje1, +Personaje2) es simétrico porque sonAmigos/2 y sonPareja/2 lo son
sonDuo(Personaje1, Personaje2):-
  sonAmigos(Personaje1, Personaje2).
sonDuo(Personaje1, Personaje2):-
  sonPareja(Personaje1, Personaje2).

% esRespetablePersonaje(+Personaje)
esRespetablePersonaje(Personaje):-
  nivelDeRespeto(Personaje, Nivel),
  Nivel > 9.

% nivelDeRespeto(+Personaje, +NivelDeRespeto)
nivelDeRespeto(Personaje, 10):-
  personaje(Personaje, mafioso(resuelveProblemas)).
nivelDeRespeto(Personaje, 1):-
  personaje(Personaje, mafioso(maton)).
nivelDeRespeto(Personaje, 20):-
  personaje(Personaje, mafioso(capo)).

nivelDeRespeto(Personaje, NivelDeRespeto):-
  esActriz(Personaje),
  findall(PuntajeGenero, calculoDeCoeficiente(Personaje, PuntajeGenero), Numeros),
  sumlist(Numeros, NumeroParcial),
  NivelDeRespeto is NumeroParcial / 3.

esActriz(Personaje):-
  personaje(Personaje, actriz(_,_)).

% coeficienteRespeto(+Genero, +CoeficienteRespeto)
coeficienteRespeto(drama, 5).
coeficienteRespeto(musical, 2).

% calculoDeCoeficiente(+Personaje, +PuntajeGenero)
calculoDeCoeficiente(Personaje, PuntajeGenero):-
  personaje(Personaje, actriz(Cantidad, Genero)),
  coeficienteRespeto(Genero, Coeficiente),
  PuntajeGenero is Coeficiente * Cantidad.

% encargoA(+Solicitante, +Solicitado, +Encargo)
encargoA(marsellus, vincent, cuidar(mia)).
encargoA(marsellus, vincent, buscar(mia, discoteca)).
encargoA(marsellus, vincent, buscar(butch, losAngeles)).
encargoA(vincent, elVendedor, cuidar(mia)).
encargoA(marsellus, winston, ayudar(jules)).
encargoA(marsellus, winston, ayudar(vincent)).
encargoA(vincent, jules, ayudar(mia)).

% estaEnProblemas(+Personaje)
estaEnProblemas(Personaje):-
  trabajaPara(Jefe, Personaje),
  esPeligroso(Jefe),
  sonPareja(Jefe, Pareja),
  encargoA(Jefe, Personaje, cuidar(Pareja)).
estaEnProblemas(butch).
estaEnProblemas(Personaje):-
  encargoA(_, Personaje, buscar(Buscado, _)),
  personaje(Buscado, boxeador).

% sanCayetano(+Personaje)
sanCayetano(Personaje):-
  tieneCerca(Personaje, _),
  forall(tieneCerca(Personaje, Cercano), encargoA(Personaje, Cercano, _)).

% tieneCerca(+Personaje, +Cercano)
tieneCerca(Personaje, Cercano):-
  sonAmigos(Personaje, Cercano).
tieneCerca(Personaje, Cercano):-
  trabajaPara(Personaje, Cercano).

/*
Aclaracion: Como de elVendedor no sabemos cuál es su actividad,
el predicado personaje/2 no es tan buen generador como creíamos para estos puntos.
Al usar el predicado encargoA/3 como generador se consigue el resultado esperado.
*/
% masAtareado(+Personaje)
masAtareado(Personaje):-
  encargoA(_,Personaje, _),
  not(tieneMasEncargos(_, Personaje)).

/*
Variante para masAtareado/1 que también surgió en clase:

masAtareado(Personaje):-
  cantidadDeEncargos(Personaje, CantidadMayor),
  forall((cantidadDeEncargos(Otro, CantidadMenor), Otro \= Personaje),
         CantidadMenor < CantidadMayor).
*/

% tieneMasEncargos(+Atareado, +Personaje) no es reflexivo por el > y también a que
% cantidadDeEncargos/2 relaciona a cada personaje con una única cantidad de encargos.
tieneMasEncargos(Atareado, Personaje):-
  cantidadDeEncargos(Atareado, CantidadMayor),
  cantidadDeEncargos(Personaje, CantidadMenor),
  CantidadMayor > CantidadMenor.

% cantidadDeEncargos(+Personaje, +Cantidad)
cantidadDeEncargos(Personaje, Cantidad):-
  encargoA(_, Personaje, _),
  findall(Encargo, encargoA(_, Personaje, Encargo), Encargos),
  length(Encargos, Cantidad).

% hartoDe(+Harto, +Otro)
hartoDe(Harto, Otro):-
  encargoA(_, Harto, _),
  personaje(Otro, _),
  forall(encargoA(_, Harto, Tarea), requiereInteractuarCon(Tarea, Otro)).

% requiereInteractuarCon(-Tarea, +Persona)
% Dado que sólo planeamos consultarlo de forma individual respecto a la tarea,
% no lo hacemos totalmente inversible, porque no nos aporta nada.
requiereInteractuarCon(buscar(Persona, _), Persona).
requiereInteractuarCon(cuidar(Persona), Persona).
requiereInteractuarCon(ayudar(Persona), Persona).
