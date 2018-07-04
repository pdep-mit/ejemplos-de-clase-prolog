personaje(pumkin, ladron(licorerias)).
personaje(honeyBunny, ladron(estacionesDeServicio)). 
personaje(vincent, mafioso(maton)). 
personaje(jules, mafioso(maton)). 
personaje(marsellus, mafioso(capo)). 
personaje(winston, mafioso(resuelveProblemas)). 
personaje(mia, actriz(1, drama)).
personaje(marilyn, actriz(10, musical)). 
personaje(butch, boxeador). 
 
pareja(marsellus, mia). 
pareja(pumkin, honeyBunny). 
 
%trabajaPara(Empleador, Empleado) 
trabajaPara(marsellus, vincent). 
trabajaPara(marsellus, jules). 
trabajaPara(marsellus, winston). 


amigo(vincent, jules). 
amigo(jules, jimmie). 
amigo(vincent, elVendedor). 

%encargo(Solicitante, Encargado, Tarea).  
%las tareas pueden ser cuidar(Protegido), 
%ayudar(Ayudado), buscar(Buscado, Lugar) 

encargo(marsellus, vincent,   cuidar(mia)). 
encargo(marsellus, vincent,   buscar(mia, discoteca)). 
encargo(vincent,  elVendedor, cuidar(mia)). 
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)). 
encargo(marsellus, vincent, buscar(butch, losAngeles)). 
encargo(marsellus, jules, ayudar(vincent)).

esPeligroso(Personaje):-
	realizaActividadPeligrosa(Personaje).

esPeligroso(Personaje):-
	tieneEmpleadosPeligrosos(Personaje).


realizaActividadPeligrosa(Personaje):-
	personaje(Personaje, mafioso(maton)).

realizaActividadPeligrosa(Personaje):-
	personaje(Personaje, ladron(licorerias)).

tieneEmpleadosPeligrosos(Personaje):-
	trabajaPara(Personaje, Empleado),
	esPeligroso(Empleado).

duoTemible(Personaje1, Personaje2):-
	esPeligroso(Personaje1),
	esPeligroso(Personaje2),
	duo(Personaje1, Personaje2).

sonAmigos(Personaje1, Personaje2):-
	amigo(Personaje1, Personaje2).

sonAmigos(Personaje1, Personaje2):-
	amigo(Personaje2, Personaje1).

sonPareja(Personaje1, Personaje2):-
	pareja(Personaje2, Personaje1).

sonPareja(Personaje1, Personaje2):-
	pareja(Personaje1, Personaje2).

duo(Personaje1, Personaje2):-
	sonAmigos(Personaje1, Personaje2).

duo(Personaje1, Personaje2):-
	sonPareja(Personaje1, Personaje2).

estaEnProblemas(Personaje):-
	trabajaPara(Empleador, Personaje),
	esPeligroso(Empleador),
	encargo(Empleador, Personaje, cuidar(Pareja)),
	sonPareja(Empleador, Pareja).

estaEnProblemas(butch).

estaEnProblemas(Personaje):-
	encargo(_, Personaje, buscar(Alguien,_)),
	personaje(Alguien, boxeador).


tieneCerca(Personaje1, Personaje2):-
	sonAmigos(Personaje1, Personaje2).

tieneCerca(Personaje1, Personaje2):-
	trabajaPara(Personaje1, Personaje2).

sanCayetano(Personaje):-
	tieneCerca(Personaje, _),
	forall(tieneCerca(Personaje, Alguien), 
		encargo(Personaje, Alguien, _)).

%versión polimorfica

hartoDe(Personaje1, Personaje2):-
	personaje(Personaje1, _),
	personaje(Personaje2, _),
	forall(encargo(_, Personaje1, Encargo), 
		requiereInteractuarCon(Personaje2, Encargo)).


requiereInteractuarCon(Personaje, cuidar(Personaje)).
%Esto es equivalente a hacer:
%requiereInteractuarCon(Alguien, cuidar(Personaje)):- Alguien = Personaje.


requiereInteractuarCon(Personaje, buscar(Personaje, _)).

requiereInteractuarCon(Personaje, ayudar(Personaje)).

%versión horrible

hartode2(Personaje1, Personaje2):-
	forall(encargo(_, Personaje1, cuidar(OtroPersonaje)), 
		OtroPersonaje = Personaje2),
	forall(encargo(_, Personaje1, ayudar(OtroPersonaje)), 
		OtroPersonaje = Personaje2),
	forall(encargo(_, Personaje1, buscar(OtroPersonaje, _)), 
		OtroPersonaje = Personaje2).


esRespetable(Personaje):-
	personaje(Personaje, Actividad),
	nivelDeRespeto(Actividad, Nivel),
	Nivel > 9.

nivelDeRespeto(mafioso(maton), 1).

nivelDeRespeto(mafioso(resuelveProblemas), 10).

nivelDeRespeto(mafioso(capo), 20).

nivelDeRespeto(actriz(Cantidad, Genero), Nivel):-
	indiceDeRespeto(Genero, Indice),
	Nivel is (Cantidad/ 10)*Indice.

indiceDeRespeto(drama, 5).
indiceDeRespeto(musical, 2).

	