¿Qué es Bison?

GNU Bison es un generador de parsers (analizadores sintácticos) a partir de una gramática libre de contexto. A partir de un archivo .y (gramática + acciones), produce código C/C++ que:

Lee tokens del lexer (Flex u otro).

Reconoce la estructura del lenguaje (según la gramática).

Ejecuta acciones semánticas (construcción de AST, verificación, etc.).

Bison está optimizado para LR(1); por defecto usa LALR(1). También soporta IELR(1), LR(1) canónico y GLR.

Estructura de un archivo Bison (.y)

Un archivo típico tiene tres secciones y, dentro de ellas, los bloques que se listan:

%{
/* 1) Prólogo en C/C++: includes, prototipos, manejo de ubicaciones */
%}

/* 2) Declaraciones de Bison: tokens, tipos, precedencias, opciones */

%%
/* 3) Reglas gramaticales + acciones en C/C++ */
%%

/* 4) Código C/C++ adicional: funciones auxiliares, yyerror, etc. */


A continuación, el detalle de cada parte.