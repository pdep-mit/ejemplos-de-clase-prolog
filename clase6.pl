%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  DUSTBUSTERS!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Partimos de la siguiente base de conocimientos

%herramientasRequeridas(Tarea, Herramientas).
%herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradora, cera, aspiradora(300)]).

%% Modificación del punto 6
herramientasRequeridas(ordenarCuarto, [[escoba, aspiradora(100)], trapeador, plumero]).

%tareaPedida(tarea, cliente, metrosCuadrados).
tareaPedida(ordenarCuarto, dana, 20).
tareaPedida(cortarPasto, walter, 50).
tareaPedida(limpiarTecho, walter, 70).
tareaPedida(limpiarBanio, louis, 15).

%precio(tarea, precioPorMetroCuadrado).
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%1
% Tenemos que decidir cómo representar la información. Surgen estas alternativas:
% tiene(Persona, Herramienta).
% persona(Persona, listaDeHerramientas).
% Elegimos trabajar con varios hechos en vez de listas porque simplifica
% las consultas y no hay un buen motivo para usar listas

tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(peter, trapeador).
tiene(winston, varitaDeNeutrones).


%2 - Este punto no requería que fuera inversible para la herramienta
satisfaceNecesidad(Persona, Herramienta):-
	tiene(Persona, Herramienta).

/*
satisfaceNecesidad(Persona, aspiradora(PotenciaRequerida)):-
	tiene(Persona, aspiradora(Potencia)),
	Potencia >= PotenciaRequerida.  %% no inversible
*/

satisfaceNecesidad(Persona, aspiradora(PotenciaRequerida)):-
	tiene(Persona, aspiradora(Potencia)),
	between(0, Potencia, PotenciaRequerida). %% inversible

satisfaceNecesidad(Persona, ListaRemplazables):-
	member(Herramienta, ListaRemplazables),
	satisfaceNecesidad(Persona, Herramienta).
/*
Para el punto 6 agregamos una definición de satisfaceNecesidad
que contemplara la posibilidad de listas de herramientas remplazables
aprovechando el predicado para hacer uso de polimorfismo, y evitando
tener que modificar el resto de la solución ya planteada para
contemplar este nuevo caso. Mayor explicación al final.
*/

%3
puedeHacerTarea(Persona, Tarea):-
	herramientasRequeridas(Tarea, _),
	tiene(Persona, varitaDeNeutrones).

/*
Primera solución que surgió:

puedeHacerTarea(Persona, Tarea):-
	tiene(Persona, _),
	herramientasRequeridas(Tarea, _),
	forall((herramientasRequeridas(Tarea, ListaDeHerramientas),
			member(Herramienta, ListaDeHerramientas)),
		satisfaceNecesidad(Persona, Herramienta)).

Segunda solución:

Acá ligamos la lista de herramientas antes del forall para simplificar el antecedente
del forall. En base al dominio original, la relación entre tareas y listas de herramientas
es 1 a 1, o sea que da lo mismo si está adentro del forall que antes.
Si la relación no fuera 1 a 1, el comportamiento sería distinto,
que es algo que tuvimos que analizar en el punto 6 para una de las posibles soluciones.

puedeHacerTarea(Persona, Tarea):-
	tiene(Persona, _),
	herramientasRequeridas(Tarea, ListaDeHerramientas),
	forall(member(Herramienta, ListaDeHerramientas)),
		satisfaceNecesidad(Persona, Herramienta)).

Tercera solución:

Acá pudimos abstraer el concepto de que una tarea requiera
una herramienta, y reemplazamos el member dentro del forall
por ese nuevo predicado.
Desde un punto de vista de funcionalidad es 100% equivalente a la primer solución,
pero es mejor porque nos permite desentender del conjunto de herramientas requeridas
que no hacían al problema.
*/

puedeHacerTarea(Persona, Tarea):-
	tiene(Persona, _),
	requiereHerramienta(Tarea, _),
	forall(requiereHerramienta(Tarea, Herramienta),
		satisfaceNecesidad(Persona, Herramienta)).

requiereHerramienta(Tarea, Herramienta):-
	herramientasRequeridas(Tarea, ListaDeHerramientas),
	member(Herramienta, ListaDeHerramientas).


%4
precioACobrar(Cliente, PrecioACobrar):-
	tareaPedida(Cliente, _, _),
	findall(Precio, precioPorTareaPedida(Cliente, _, Precio),
		ListaPrecios),
	sumlist(ListaPrecios, PrecioACobrar).

% Recordemos que precioACobrar es para saber la suma del precio de
% todas las tareas que solicitó un cliente

% Si bien no era necesario para lo que teníamos que hacer en este punto
% relacionar a la tarea además de al cliente y el precio (abiertamente la ignoramos en el findall),
% la abstracción cobra más sentido si es de aridad 3, podemos usarla en otros contextos,
% por ejemplo para saber cuánto se debe cobrar a un cliente por una tarea en particular.

precioPorTareaPedida(Cliente, Tarea, Precio):-
	tareaPedida(Cliente, Tarea, Metros),
	precio(Tarea, PrecioPorMetro),
	Precio is PrecioPorMetro * Metros.

%5

tareaCompleja(limpiarTecho).

tareaCompleja(Tarea):-
	herramientasRequeridas(Tarea, Herramientas),
	length(Herramientas, Cantidad),
	Cantidad > 2.

% Este predicado es inversible gracias a que puedeHacerPedido lo es.
aceptaPedido(Trabajador, Cliente):-
	puedeHacerPedido(Trabajador, Cliente),
	estaDispuestoAHacer(Trabajador, Cliente).

puedeHacerPedido(Trabajador, Cliente):-
	tareaPedida(Cliente, _, _),
	tiene(Trabajador, _),
	forall(tareaPedida(Cliente, Tarea, _),
		puedeHacerTarea(Trabajador, Tarea)).

% Este predicado no es inversible, y decidimos que no nos interesa que lo sea.
estaDispuestoAHacer(peter, _).

estaDispuestoAHacer(ray, Cliente):-
	not(tareaPedida(Cliente, limpiarTecho, _)).

estaDispuestoAHacer(winston, Cliente):-
	precioACobrar(Cliente, PrecioACobrar),
	PrecioACobrar >= 500.

estaDispuestoAHacer(egon, Cliente):-
	not((tareaPedida(Cliente, Tarea, _),
		tareaCompleja(Tarea))).
/*
estaDispuestoAHacer(egon, Cliente):-
	forall(tareaPedida(Cliente, Tarea, _),
		not(tareaCompleja(Tarea))).

Ambas propuestas para estaDispuestoAHacer son válidas
Decir "para todas las tareas que pidio un cliente, ninguna es compleja"
Equivale a decir "no existe una tarea que haya pedido un
cliente y que sea compleja".

En este caso no se cumple que la solución con forall sea más simple que la solución
por negación, debido a la negación de tareaCompleja.
*/

/*
6
Primer propuesta: agregar otro hecho para herramientasRequeridas.

Por qué para este punto no bastaba sólo con agregar un nuevo
hecho para herramientasRequeridas? Si hubiéramos tenido:

herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(ordenarCuarto, [escoba, trapeador, plumero]).

Con nuestra definición final de puedeHacerTarea verificábamos con un
forall que una persona posea todas las herramientas que requería
una tarea; pero sólo ligabamos la tarea. Entonces Prolog hubiera
matcheado con ambos hechos que encontraba, y nos hubiera relacionado
las herramientas requeridas presentes en ambos hechos.

Una posible solución era, dentro de puedeHacerTarea, también ligar
las herramientasRequeridas antes del forall (segunda solución del punto 3), y así asegurarnos que
el predicado matcheara con una única lista de herramientas a la vez.
Entonces una primer desventaja que vemos es que es fácil no darse cuenta de que no da lo mismo cómo
manejamos la lista de herramientas en ese punto.

Otra gran desventaja de esta solución es que para cada nueva herramienta remplazable
deberíamos contemplar todos los nuevos hechos a generar para que
esta solución siga funcionando como queremos.
Se puede hacer? En este caso sí, pero con el tiempo se volvería costosa.
Por ejemplo, si para la misma tarea pudiéramos reemplazar el trapeador o el plumero por otra cosa,
tendríamos que definir tantos hechos como combinaciones posibles haya de herramientas reemplazables.

Segunda propuesta: Ver los cambios a los predicados herramientasRequeridas y satisfaceNecesidad.

La alternativa que planteamos en esta solución es agrupar en una lista
las herramientas remplazables, y agregar una nueva definición a
satisfaceNecesidad, que era el predicado que usábamos para tratar
directamente con las herramientas, que trate polimórficamente tanto
a nuestros hechos sin herramientas reemplazables, como a aquellos que
sí las tienen. También se podría haber planteado con un functor en vez
de lista, pero hubiera sido más incómodo.

Cuál es la ventaja? Cada vez que aparezca una nueva herramienta
reemplazable, bastará sólo con agregarla a la lista de herramientas
reemplazables, y no deberá modificarse el resto de la solución.

Notas importantes y repaso:
I) Este enunciado pedía que todos los predicados fueran inversibles,
salvo que se indique lo contrario.
Recordemos que un predicado es inversible cuando
no necesitás pasar el parámetro resuelto (un individuo concreto),
sino que podés pasar una incógnita (variable sin unificar).
Así podemos hacer tanto consultas individuales como existenciales.

II) No siempre es conveniente trabajar con listas, no abusar de su uso.
	En general las listas son útiles sólo para contar o sumar muchas cosas
	que están juntas.
	También podemos tenerlas en cuenta como herramienta de modelado, como hicimos
	en la solución para el punto 6, pero para el punto 1 por ejemplo optamos por no usarlas.

III) Para usar findall es importante saber que está compuesto por 3 cosas:
		1. Qué quiero encontrar
		2. Qué predicado voy a usar para encontrarlo
		3. Donde voy a poner lo que encontré

IV) Todo lo que se hace con forall podría también hacerse usando not.

V) Aguante el polimorfismo.
*/
