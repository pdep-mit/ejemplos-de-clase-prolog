%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fantasma Blitz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

objeto(fantasma, blanco).
objeto(sillon, rojo).
objeto(raton, gris).
objeto(libro, azul).
objeto(botella, verde).

/*
Necesitamos representar la siguiente información en la base de conocimientos:
- La carta 1 tiene la figura de un fantasma azul y la de un sillón verde.
- La carta 2 tiene la figura de un fantasma blanco y la de una botella roja.
- La carta 3 tiene la figura de un ratón azul y la de una botella blanca.

Pensamos cual era la aridad mas adecuada para el predicado carta.
La conclusion fue que definirlo de aridad 3 era mas apropiado que de aridad 5 (que
había sido la idea inicial), y para eso necesitabamos introducir la idea de
individuo compuesto para representar a las figuras que se componen
por una forma y un color.
*/

% carta(Numero,Figura1,Figura2).
carta(1, figura(fantasma,azul), figura(sillon,verde)).
carta(2, figura(fantasma,blanco), figura(botella,rojo)).
carta(3, figura(raton,azul), figura(botella,blanco)).

/*
Las figuras son FUNCTORES, son un tipo de individuo más. No son predicados,
pero sintácticamente hay una similitud importante. Lo que determina si Prolog interpreta
algo como una consulta a un predicado o como un functor es el contexto en el que se usa.
En el encabezado de las reglas y en los hechos no se hacen consultas => se interpreta como individuo.
*/

/*
Desarrollamos solucionCarta/2 que permite resolver el problema principal del juego,
relaciona un número de carta con una figura que efectivamente exista como un objeto del juego.

La solución puede o bien ser una de las 2 figuras que se muestran en la carta,
siempre y cuando esa figura de la carta exista como un objeto de la mesa...
*/
solucionCarta(Numero,Figura):-
 perteneceACarta(Numero,Figura),
 existeComoObjeto(Figura).
/*
... o si ninguna de las 2 figuras de la carta existen, la solución debería ser
una figura que sí exista como un objeto de la mesa y que no sea similar a ninguna
de las dos figuras que se muestran en la carta (es similar si coincide en color
pero no en forma, o si coincide en forma pero no en color respecto a la otra
figura en cuestión).
*/
solucionCarta(Numero,Figura):-
  carta(Numero,_,_),
  existeComoObjeto(Figura),
  forall(perteneceACarta(Numero,FiguraCarta),
         not(esSimilar(Figura,FiguraCarta))).

%% Abstracciones copadas que surgieron durante la resolución

/*
perteneceACarta/2 nos permite usar cómodamente la información de la carta, sin
tener que preocuparnos por cuál de las dos figuras estamos consultado cuando
esto es indistinto. Este predicado es inversible.
*/
perteneceACarta(Numero,Figura):-
 carta(Numero,Figura,_).
perteneceACarta(Numero,Figura):-
  carta(Numero,_,Figura).

/*
existeComoObjeto/1 nos permite abstraernos sobre la forma de la figura en solucionCarta/2
cuando no es relevante. Además es inversible, con lo cual podemos usarlo como generador
de figuras que efectivamente existan como objetos de la mesa, lo cual se aprovecha en
la segunda cláusula de solucionCarta/2.
*/
existeComoObjeto(figura(Forma,Color)):-
 objeto(Forma,Color).

/*
esSimilar/2 verifica si dos figuras son similares de acuerdo a lo que se planteaba
en el enunciado. Este predicado no es inversible, sin embargo para el uso que
se le va a dar en solucionCarta/2, donde la consulta es individual respecto a
ambas figuras, no hace falta que sea inversible.
*/
esSimilar(figura(Forma,Color1),figura(Forma,Color2)):-
  Color1\=Color2.

esSimilar(figura(Forma1,Color),figura(Forma2,Color)):-
   Forma1\=Forma2.

/*
Si quisiéramos hacer inversible el predicado esSimilar/2 se podría, dado que
las formas y colores válidos para este juego son limitados.
Siempre podemos decidir si vale la pena desde un punto de vista de uso hacer que
un predicado sea inversible. Si no es particularmente complejo de lograr que
sea inversible y eso no compromete la funcionalidad buscada, no está de más.
*/
esSimilarV2(figura(Forma,Color1),figura(Forma,Color2)):-
 forma(Forma),
 color(Color1),
 color(Color2),
 Color1\=Color2.

esSimilarV2(figura(Forma1,Color),figura(Forma2,Color)):-
  color(Color),
  forma(Forma1),
  forma(Forma2),
  Forma1\=Forma2.

color(Color):-
  objeto(_,Color).
forma(Forma):-
  objeto(Forma,_).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% La copa de las casas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Nos dan la siguiente información sobre los alumnos de Hogwarts y lo que hacen
%% a lo largo del año, para saber cómo impactan sus acciones en los puntos que
%% luego se consideran para la copa de las casas.

casa(hermione, gryffindor).
casa(ron, gryffindor).
casa(harry, gryffindor).
casa(draco, slytherin).
casa(luna, ravenclaw).

lugarProhibido(bosque,50).
lugarProhibido(seccionRestringida,10).
lugarProhibido(tercerPiso,75).

hizo(harry, fueraDeCama).
hizo(hermione, irA(tercerPiso)).
hizo(harry, irA(bosque)).
hizo(draco, irA(mazmorras)).
hizo(ron, buenaAccion(ganarAlAjedrezMagico, 50)).
hizo(hermione, buenaAccion(inteligenciaBajoPresion, 50)).
hizo(harry, buenaAccion(ganarleAVoldemort, 60)).

%% En el punto 3 se agrega esta nueva información a la base de conocimientos:
hizo(hermione, responder(dondeSeEncuentraUnBezoar, 15, snape)).
hizo(harry, responder(dondeSeEncuentraUnBezoar, 15, snape)).
hizo(hermione, responder(wingardiumLeviosa, 25, flitwick)).
hizo(luna, responder(accio, 15, flitwick)).

%% Y en el punto 4 se agrega lo siguiente para soportar el cambio de requerimiento final:
alumnoFavorito(flitwick, hermione).
alumnoFavorito(snape, draco).
alumnoOdiado(snape, harry).

/*
obtenerPuntos/4: relaciona a un mago con su casa y los puntos que obtuvo por cada
acción que hizo, considerando que las distintas acciones dan puntos de forma distinta,
y algunas incluso podrían no impactar en el puntaje en absoluto.
*/

obtenerPuntos(Casa,Mago,Accion,Puntos):-
  casa(Mago,Casa),
  hizo(Mago,Accion),
  puntosPorAccion(Mago, Accion, Puntos).

/*
Delegamos el problema para determinar cuántos puntos da cada acción a otro predicado
(puntosPorAccion) el cual trabaja POLIMÓRFICAMENTE con las distintas acciones.
Esto nos resuelve los problemas en los cuales nos importan los detalles puntuales
de cada tipo de acción de modo que desde obtenerPuntos/4 podamos desentendernos
de eso y tratar a todas las acciones como cosas similares, a pesar de que
tengan distintas formas.

Esto facilitó el punto 3 del ejercicio en el cual aparecieron las respuestas en clase,
que eran acciones que tenían otra forma distinta y otra lógica para determinar cuál era
el puntaje que otorga. Sólo hubo que agregar lo necesario a puntosPorAccion, y los
predicados que lo usaban no se vieron impactados en absoluto.

Inicialmente hicimos puntosPorAccion/2, para relacionar la acción con los puntos que otorga.
Hacia el final del ejercicio, luego de que se indicara que para las respuestas en clase el puntaje
no necesariamente era el mismo siempre, sino que dependía también de quién fue el mago
que respondió esa pregunta, modificamos las definiciones anteriores de puntosPorAccion/2
para que fueran de aridad 3. De esa forma podríamos mantener el polimorfismo deseado.

Conclusión: puntosPorAccion/3 relaciona un mago con una acción y el puntaje que le da esa
acción. Este predicado sólo es inversible para su tercer aridad (los puntos), no necesitamos
que lo sea para el mago y la acción. De hecho si tratáramos de hacerlo inversible usando el
predicado hizo/2 para generar al mago que hizo eso y la acción, eso limitaría los usos que
podría tener sentido querer soportar, por ejemplo:
?- puntosPorAccion(luna, buenaAccion(serFeliz, 25), Puntos).
Puntos = 25
*/
puntosPorAccion(_, fueraDeCama,-50).
puntosPorAccion(_, irA(Lugar),Puntos):-
  lugarProhibido(Lugar,Puntaje),
  Puntos is  Puntaje * -1.
puntosPorAccion(_, buenaAccion(_,Puntos),Puntos).
puntosPorAccion(Alumno, responder(_, Puntos, Profesor), Puntos):-
  not(alumnoOdiado(Profesor,Alumno)),
  not(alumnoFavorito(Profesor,Alumno)).
puntosPorAccion(Alumno, responder(_, Dificultad, Profesor), Puntos):-
  alumnoFavorito(Profesor, Alumno),
  Puntos is Dificultad*2.

/*
buenAlumno/1 se cumple si hizo alguna acción y ninguna de las cosas que hizo
se considera una mala acción (que son aquellas que provocan un puntaje negativo).

Dado que ya hicimos puntosPorAccion, podemos volver a usarlo, sin embrago está
bueno abstraer qué se considera una mala acción en base al puntaje, para poder
expresar la solución para buenAlumno/1 en términos de malaAccion/2.

Inicialmente malaAccion era de aridad 1, al final del ejercicio le agregamos el mago
como parámetro para consultar correctamente puntosPorAccion/3 que lo necesitaba.
*/
buenAlumno(Mago):-
  hizo(Mago,_),
  forall(hizo(Mago,Accion),not(malaAccion(Mago, Accion))).

malaAccion(Alumno, Accion):-
  puntosPorAccion(Alumno, Accion, Puntos),
  Puntos < 0.
