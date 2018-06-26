%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% La familia Simpson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Repaso de la clase anterior
%% Arrancamos con esta base de conocimiento

padre(abraham, herbert).
padre(abraham, homero).
padre(mona, homero).
padre(clancy, marge).
padre(jacqueline, marge).
padre(clancy, patty).
padre(jacqueline, patty).
padre(clancy, selma).
padre(jacqueline, selma).
padre(homero, bart).
padre(marge, bart).
padre(homero, lisa).
padre(marge, lisa).
padre(homero, maggie).
padre(marge, maggie).
padre(selma, ling).

edad(homero, 36).
edad(homero, 34).
edad(patty, 45).
edad(selma, 45).
edad(lisa, 8).
edad(bart, 10).
edad(maggie, 1).

%% Definir los siguientes predicados:

% hermanos/2: dos personas que tienen el mismo padre
% mellizos/2: hermanos de la misma edad


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% hijoUnico/1: alguien que no tiene hermanos
% abueloCompleto/1: todos sus hijos tienen hijos
% tieneCanasVerdes/1: todos sus hijos tienen menos de 15 años
% esHijoMenor/1: personas que, sin ser hijos únicos, sólo tienen hermanos mayores
