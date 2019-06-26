%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bob Esponja
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Repaso de la clase anterior
%% Arrancamos con esta base de conocimiento
ciudadano(arenita).
ciudadano(calamardo).
ciudadano(patricio).
ciudadano(bob).

restaurante(crustaceoCascarudo).
restaurante(baldeDeCarnada).
restaurante(elegante).
restaurante(infantil).

comioEn(arenita,crustaceoCascarudo).
comioEn(calamardo,crustaceoCascarudo).
comioEn(patricio,crustaceoCascarudo).
comioEn(bob,crustaceoCascarudo).
comioEn(calamardo,elegante).
comioEn(bob, infantil).
comioEn(patricio, infantil).

area(ciencia).
area(musica).
area(pintura).
area(jellyfishing).

domina(arenita,ciencia).
domina(arenita,musica).
domina(arenita,pintura).
domina(arenita, jellyfishing).
domina(calamardo,musica).
domina(calamardo,pintura).
domina(bob,pintura).
domina(bob, jellyfishing).
domina(patricio, jellyfishing).

% sonColegas/2 es un predicado que cumple con ser simétrico porque para todo par A y B
% que cumpla sonColegas(A,B) también se cumple sonColegas(B, A).
% Al usar \= aseguramos que no sea reflexivo (o sea que nadie sea colega de sí mismo).
% Además como el predicado domina/2 es inversible, no vamos a tener problemas de inversibilidad
% en el predicado sonColegas/2, siempre que el \= esté después de consultar domina/2 para ambos.
sonColegas(Persona1, Persona2):-
  domina(Persona1, Actividad),
  domina(Persona2, Actividad),
  Persona1 \= Persona2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NOT
%%% Predicado de orden superior de aridad 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

persona(Persona) :-
  ciudadano(Persona).
persona(cangrejo).
persona(amigoBurbuja).

% Alguien es extranjero si no es ciudadano
extranjero(Persona):-
  persona(Persona), % generamos a la Persona para que extranjero/1 sea inversible
  not(ciudadano(Persona)).

% Un restaurante es un fracaso si nadie comió ahí
esUnFracaso(Restaurante):-
  restaurante(Restaurante),
  not(comioEn(_, Restaurante)).

% distintoPublico/2 si no existen personajes que hayan comido en ambos
distintoPublico(Resto1, Resto2):-
  restaurante(Resto1),
  restaurante(Resto2),
  Resto1 \= Resto2,
  not(comioEnAmbos(_, Resto1, Resto2)).

comioEnAmbos(Persona, Resto1, Resto2):-
    comioEn(Persona, Resto1),
    comioEn(Persona, Resto2),
    Resto2 \= Resto1.

% También se puede hacer de esta otra forma si no nos interesa la abstracción
% para saber si un personaje comió en ambos restaurantes.

distintoPublico2(Resto1, Resto2):-
  restaurante(Resto1),
  restaurante(Resto2),
  Resto1 \= Resto2,
  not((comioEn(Persona, Resto1), comioEn(Persona, Resto2))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% FORALL
%%% Predicado de orden superior de aridad 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Alguien es un genio si domina todas las áreas de conocimiento que existen
genio(Personaje):-
  persona(Personaje),  % generamos el personaje para que sea inversible
  forall(area(Area), domina(Personaje, Area)). % Para todo Area, ese personaje la domina

%% referente/2 un personaje es referente de un area si sólo él la domina
referente(Personaje, Area):-
  domina(Personaje, Area),
  not( (domina(Otro, Area), Otro \= Personaje) ).

% También puede resolverse usando forall/2 de esta forma que es equivalente
referente2(Personaje, Area):-
  domina(Personaje, Area),
  forall(domina(Otro, Area), Otro = Personaje).

%% todosSonCacahuates/1 se cumple para un restaurante si todos los que comieron ahi
%% no dominan la ciencia

% Esta versión se cumple para baldeDeCarnada, donde no comió nadie
todosSonCacahuates(Restaurante):-
  restaurante(Restaurante),
  forall(comioEn(Persona, Restaurante), not(domina(Persona, ciencia))).

% Esta versión NO se cumple para baldeDeCarnada, porque además pedimos que alguien haya comido ahí
todosSonCacahuates2(Restaurante):-
  comioEn(_, Restaurante),
  forall(comioEn(Persona, Restaurante), not(domina(Persona, ciencia))).

%% sidekick/2 se cumple si el primero y el segundo son inseparables y el segundo (el amigo copado)
%% es mas groso.
%% son inseparables si comen en los mismos restaurantes
%% alguien es mas groso que otro si domina algun area que el otro no domina, y a su vez
%% domina todas las areas que el otro personaje domina.

sidekick(Sidekick, Amigo):-
  sonInseparables(Sidekick, Amigo),
  esMasGroso(Amigo, Sidekick).

sonInseparables(Persona1, Persona2):-
  comioEnTodosLosLugaresDondeComio(Persona1, Persona2),
  comioEnTodosLosLugaresDondeComio(Persona2, Persona1),
  Persona1 \= Persona2.

comioEnTodosLosLugaresDondeComio(Persona1, Persona2):-
  comioEn(Persona1,_),
  comioEn(Persona2, _),
  forall(comioEn(Persona2, Restaurante), comioEn(Persona1, Restaurante)),
  Persona1 \= Persona2.

esMasGroso(Groso, NoTanGroso):-
    domina(Groso, AreaExclusiva),
    persona(NoTanGroso),
    not(domina(NoTanGroso, AreaExclusiva)),
    forall(domina(NoTanGroso, Area), domina(Groso, Area)).

%% sonInseparables también se podría resolver de esta otra forma
%% que también cumple con ser inversible y simétrico, si no nos interesa
%% la abstracción comioEnTodosLosLugaresDondeComio/2
sonInseparables2(Persona1, Persona2):-
    comioEn(Persona1,_),
    comioEn(Persona2, _),
    forall(comioEn(Persona2, Restaurante), comioEn(Persona1, Restaurante)),
    forall(comioEn(Persona1, Restaurante), comioEn(Persona2, Restaurante)),
    Persona1 \= Persona2.
