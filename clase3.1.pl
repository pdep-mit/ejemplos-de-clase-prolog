%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejercicio: bienUbicado/1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

viveEn(mariano, avellaneda).
viveEn(fede, avellaneda).
viveEn(victoria, versalles).
viveEn(rodrigo, villaBallester).
viveEn(tomas, nuniez).

quedaEn(utn, almagro).
quedaEn(utn, villaLugano).
quedaEn(exactas, nuniez).
quedaEn(river, nuniez).
quedaEn(racing, avellaneda).
quedaEn(montoto, palermo).
quedaEn(montoto, nuniez).
quedaEn(montoto, avellaneda).

tieneAuto(tomas).
tieneAuto(fede).

llegaFacil(batman, _).
llegaFacil(Persona, _) :-
 tieneAuto(Persona).
llegaFacil(Persona, Destino) :-
  viveEn(Persona, Zona),
  quedaEn(Destino, Zona).

destinosProximos(Destino, OtroDestino) :-
   quedaEn(Destino, Zona),
   quedaEn(OtroDestino, Zona).

sonVecinos(UnaPersona, OtraPersona) :-
    UnaPersona \= OtraPersona,
    viveEn(UnaPersona, Zona),
    viveEn(OtraPersona, Zona).

loLleva(UnaPersona, OtraPersona) :-
    tieneAuto(UnaPersona),
    not(tieneAuto(OtraPersona)),
    sonVecinos(UnaPersona, OtraPersona).

quiereIr(fede, racing).
quiereIr(fede, montoto).
quiereIr(victoria, montoto).
quiereIr(tomas, montoto).
quiereIr(tomas, utn).

% La consigna es resolver bienUbicado/1 con una solución basada en existencia / no existencia
% Con para todo nos quedaría algo así:
% bienUbicado(Persona) :- viveEn(Persona, Zona),
%                         forall(quiereIr(Persona, Lugar), quedaEn(Lugar, Zona)).

bienUbicado(Persona) :-
  viveEn(Persona, Zona),
  not((
    quiereIr(Persona, Lugar),
    not(quedaEn(Lugar, Zona))
  )).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejercicio granCompanieroDeViaje/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

destino(pepe, alejandria).
destino(pepe, jartum).
destino(pepe, roma).
destino(juancho, roma).
destino(lucy, roma).
destino(lucy, belgrado).

idioma(alejandria,arabe).
idioma(jartum, arabe).
idioma(belgrado, serbio).
idioma(roma, italiano).

habla(pepe, bulgaro).
habla(pepe, italiano).
habla(juancho, arabe).
habla(lucy, griego).

mismoDestino(UnaPersona, OtraPersona) :-
  destino(UnaPersona, Ciudad),
  destino(OtraPersona, Ciudad),
  UnaPersona \= OtraPersona.

hablaIdiomaDe(Persona, Ciudad) :-
  idioma(Ciudad, Lenguaje),
  habla(Persona, Lenguaje).

fueSinSaberHablar(Persona, Ciudad) :-
  destino(Persona, Ciudad),
  not(hablaIdiomaDe(Persona, Ciudad)).

granCompanieroDeViaje(UnaPersona, OtraPersona) :-
  mismoDestino(UnaPersona, OtraPersona),
  forall(fueSinSaberHablar(UnaPersona, Ciudad),
         hablaIdiomaDe(OtraPersona, Ciudad)).
