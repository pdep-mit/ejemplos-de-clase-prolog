%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Programadores 2.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% programaEn/2 relaciona una persona con un lenguaje

programaEn(nahuel, javascript).
programaEn(juan, haskell).
programaEn(juan, ruby).
programaEn(caro, haskell).
programaEn(caro, scala).
programaEn(caro, javascript).

% Primera versión, no inversible
% programaEn(_, c).

% Segunda versión, inversible
programaEn(Persona, c):-
  persona(Persona).

persona(nahuel).
persona(caro).
persona(juan).

% Sabemos que alguien es irremplazable si programa en un lenguaje en el cual nadie más programa.
% Es inversible porque programaEn/2 es inversible.
irremplazable(Persona):-
  programaEn(Persona, Lenguaje),
  not((programaEn(Alguien, Lenguaje),
          Alguien \= Persona)).

% No es inversible, porque llega Alguien sin ligar al \=/2
irremplazableRoto1(Persona):-
  programaEn(Persona, Lenguaje),
  not((Alguien \= Persona,
     programaEn(Alguien, Lenguaje))).

% No es inversible, porque llegan Lenguaje y Persona sin ligar al not/1
% Esto no anda bien ni para consultas individuales, porque no sabemos cuál es el Lenguaje
irremplazableRoto2(Persona):-
  not((programaEn(Alguien, Lenguaje),
          Alguien \= Persona)),
  programaEn(Persona, Lenguaje).

% Otro error común: consultar Alguien \= Persona después del not/1
% No tiene sentido porque not/1 no liga variables, y queda una contradicción
% al consultar que programaEn(Persona, Lenguaje) y luego negar que alguien programe en ese lenguaje.
irremplazableRoto3(Persona):-
  programaEn(Persona, Lenguaje),
  not(programaEn(Alguien, Lenguaje)),
  Alguien \= Persona.

irremplazableRoto4(Persona):-
  programaEn(Persona, Lenguaje), % <-- si Persona fuera nahuel (que programa en javascript)
  persona(Alguien),  % <-- puede ligarse con nahuel, caro y juan
  Alguien \= Persona, % <-- será cierto para caro y juan
  not(programaEn(Alguien, Lenguaje)). % <-- como juan no programa en javascript, es cierto

irremplazableRoto5(Persona):-
  programaEn(Persona, Lenguaje), % <-- si Persona fuera nahuel (que programa en javascript)
  not(programaEn(Alguien, Lenguaje)), % <-- como existe alguien que programa en javascript (ej. nahuel, es falso)
  not(Alguien \= Persona). % <-- nunca se llega a esto

%% not(A), not(B) no es lo mismo que not((A, B))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Lechuzas mafiosas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% lechuza(NombreLechuza, Sospechosidad, Nobleza).
lechuza(swi, 10, 60).
lechuza(duo, 25, 55).
lechuza(blathers, 60, 20).
lechuza(hedwig, 30, 80 ).

/*
1. ¿Qué tan violenta es una lechuza?
Se calcula como 5 * sospechosidad + 42 / nobleza.
*/

violencia(Lechuza, Violencia):-
  lechuza(Lechuza, Sospechosidad, Nobleza),
  Violencia is 5 * Sospechosidad + 42 / Nobleza.

/*
2. Si una lechuza es vengativa.
Lo es si su violencia es mayor a 100.
*/

vengativa(Lechuza):-
  violencia(Lechuza, Violencia),
  Violencia > 100.

/*
3. Si una lechuza es mafiosa, que se cumple si no es buena gente o su sospechosidad es al menos 75. Decimos que es buena gente si no es vengativa y su nobleza es mayor a 50.
*/
esBuenaGente(Lechuza):-
  lechuza(Lechuza, _, Nobleza),
  not(vengativa(Lechuza)),
  Nobleza > 50.

mafiosa(Lechuza):-
  lechuza(Lechuza, Sospechosidad, _),
  Sospechosidad >= 75.
mafiosa(Lechuza):-
  lechuza(Lechuza, _,_),
  not(esBuenaGente(Lechuza)).