# Proyecto Compilador COOL - Análisis Léxico

Este proyecto implementa un compilador para el lenguaje de programación COOL (Classroom Object-Oriented Language). En esta sección, se describe cómo se ha estructurado el análisis léxico utilizando Flex, destacando sus componentes clave: declaraciones, definiciones, reglas y subrutinas de usuario.

## Estructura del Analizador Léxico

El analizador léxico de Flex se divide en cuatro partes principales:

### 1. **Declaraciones (`%{ ... %}`)**

La primera parte del archivo de especificaciones de Flex contiene declaraciones que se incluyen directamente en el código C generado por Flex. Estas declaraciones se utilizan para importar bibliotecas, definir variables globales, y configurar parámetros para el funcionamiento del analizador léxico.

En el caso del proyecto COOL, la sección de declaraciones incluye lo siguiente:

```
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/* Add Your own definitions here */
int comment_level = 0; /* to track nested comments */

/* Function to check if the string length exceeds max length */
bool isLong();

/* Function to print error if maximum length is exceeded */
int maxlen_error(); 
%}

```

# Definiciones de Estados y Expresiones Regulares
Este documento detalla las definiciones utilizadas en el analizador léxico del compilador COOL, que es responsable de identificar tokens a partir del código fuente. Estas definiciones se dividen en dos secciones principales: Definición de Estados y Definición de Expresiones Regulares.

1. Definición de Estados (%x)
En esta sección se definen los estados que el analizador léxico puede tener durante la ejecución. Los estados permiten al analizador controlar el flujo de procesamiento de diferentes tipos de tokens y manejar situaciones especiales como cadenas de texto y comentarios.

## Estados Definidos

```
%x STRING: Este estado se utiliza para procesar cadenas de texto en el lenguaje COOL. Cuando el analizador entra en este estado, se asegura de que está dentro de una cadena de caracteres y procesará los caracteres hasta que encuentre el delimitador de cierre de la cadena.

%x COMMENT: Este estado se usa para manejar comentarios en el código COOL. Los comentarios pueden ser de una sola línea o anidados, y cuando el analizador entra en este estado, ignora el contenido de los comentarios hasta que se cierra el bloque de comentario correspondiente.

%x INVALID_STRING: Este estado maneja los errores dentro de una cadena de texto, como cadenas que contienen un carácter nulo \0 o cadenas que exceden la longitud máxima permitida. Al detectar un error, el analizador puede realizar una acción adecuada, como emitir un mensaje de error.
```

2. Definición de Expresiones Regulares
Las expresiones regulares son patrones que el analizador léxico utiliza para identificar diferentes tipos de tokens en el código fuente de COOL. A continuación se detallan las expresiones regulares para los operadores, palabras clave, constantes y otros elementos importantes del lenguaje COOL.

## Operadores y Símbolos Especiales
```
DARROW: Representa el operador => utilizado en COOL.

LE: Representa el operador "menor o igual" <=.

ASSIGN: Representa el operador de asignación <-.
```

Numerales
```
DIGIT: [0-9] Coincide con un solo dígito del 0 al 9.

DIGITS: [0-9]+ Coincide con uno o más dígitos consecutivos.
```

Letras
```
LETTER: [a-zA-Z] Coincide con cualquier letra mayúscula o minúscula del alfabeto inglés.
```

Palabras Clave (Keywords)
Las palabras clave en COOL son identificadas por las siguientes expresiones regulares, que son case-insensitive (no distinguen entre mayúsculas y minúsculas):

```
CLASS: [cC][lL][aA][sS][sS]

ELSE: [eE][lL][sS][eE]

FI: [fF][iI]

IF: [iI][fF]

IN: [iI][nN]

INHERITS: [iI][nN][hH][eE][rR][iI][tT][sS]

LET: [lL][eE][tT]

LOOP: [lL][oO][oO][pP]

POOL: [pP][oO][lL][lL]

THEN: [tT][hH][eE][nN]

WHILE: [wW][hH][iI][lL][eE]

CASE: [cC][aA][sS][eE]

ESAC: [eE][sS][aA][cC]

OF: [oO][fF]

NEW: [nN][eE][wW]

ISVOID: [iI][sS][vV][oO][iI][dD]
```

Constantes Enteras (Int Constants)
```
INT_CONST: (DIGITS)+ Coincide con una o más repeticiones de dígitos. Esto captura números enteros.

Operadores Lógicos
NOT: [nN][oO][tT] Coincide con la palabra not, sin importar la capitalización de las letras.

Espacios en Blanco
WHITESPACE: [\t ]* Coincide con espacios en blanco y tabuladores. El asterisco * indica que puede haber cero o más espacios o tabuladores.

Identificadores
TYPEID: [A-Z]([a-zA-Z0-9_])* Coincide con identificadores que comienzan con una letra mayúscula y pueden ser seguidos por letras, números o guiones bajos.

OBJECTID: [a-z]([a-zA-Z0-9_])* Coincide con identificadores que comienzan con una letra minúscula y pueden ser seguidos por letras, números o guiones bajos.
```
Nueva Línea
```
NEWLINE: \r?\n Coincide con una nueva línea, ya sea solo con \n (salto de línea) o una combinación de \r\n (retorno de carro y salto de línea).
```
Comentarios
```
SINGLECOMMENT: --(.)* Coincide con los comentarios de una sola línea que comienzan con --. Todo lo que sigue a -- hasta el final de la línea se considera parte del comentario y se ignora durante el análisis léxico.
```
Valores Booleanos
```
TRUE: t[rR][uU][eE] Coincide con la palabra true en cualquier combinación de mayúsculas y minúsculas.

FALSE: f[aA][lL][sS][eE] Coincide con la palabra false, sin importar la capitalización de las letras.
```

Resumen
En esta sección se han definido los estados y expresiones regulares que el analizador léxico utiliza para identificar diferentes tokens en el código COOL. Esto incluye operadores, palabras clave, constantes enteras, identificadores, comentarios y otros elementos del lenguaje.

Cada expresión regular se asigna a un tipo de token específico, que es devuelto por el scanner cuando ese patrón se encuentra en el código fuente. Esto permite que el código COOL sea correctamente tokenizado y procesado por el analizador sintáctico posterior.

# Reglas del Analizador Léxico
Este documento detalla las reglas del analizador léxico del compilador COOL. Cada regla en Flex está formada por un patrón y una acción que se ejecuta cuando el patrón es detectado en el código fuente. Las reglas aquí definidas permiten al analizador léxico procesar los diferentes componentes del lenguaje COOL, como operadores, identificadores, palabras clave, comentarios, y más.

1. Manejo de Nuevas Líneas

```
{NEWLINE} {
  curr_lineno++;
}
```
Explicación:
Patrón: Se detecta un salto de línea (NEWLINE).

Acción: Se incrementa el contador de líneas (curr_lineno). Esto es útil para llevar un registro de la ubicación en el código, lo que es esencial para reportar errores de manera precisa.

2. Ignorar Espacios en Blanco

```
{WHITESPACE} { }
```

Explicación:
Patrón: Se detecta un espacio en blanco o un tabulador (WHITESPACE).

Acción: No se realiza ninguna acción, ya que los espacios en blanco no afectan el análisis léxico y se descartan.

3. Comentarios de Una Sola Línea (Ignorarlos)

```
{SINGLECOMMENT} { }
```

Explicación:
Patrón: Se detecta un comentario de una sola línea, que comienza con --.

Acción: El comentario es ignorado, no se realiza ninguna acción adicional.

4. Manejo de Comentarios Mal Cerrados
```
"*)" {
  cool_yylval.error_msg = "Unmatched *)";
  return ERROR;
}
```
Explicación:
Patrón: Se encuentra un *) sin un (* de apertura correspondiente.

Acción: Se asigna un mensaje de error a cool_yylval.error_msg que indica "Unmatched *)" (Comentario mal cerrado) y se retorna el token ERROR.

5. Manejo de Comentarios Anidados
Entrada en un Comentario
```

"(*" { 
  BEGIN(COMMENT); 
  comment_level = 1;
}
```

Explicación:
Patrón: Se encuentra un (*, indicando el inicio de un comentario.

Acción: Cambia al estado COMMENT y establece comment_level = 1 para rastrear el nivel de anidamiento de comentarios.

Manejo de Comentarios Anidados

```
<COMMENT>"(*" { comment_level++; }
<COMMENT>\n { curr_lineno++; }
<COMMENT>. { }
```

Explicación:
Patrón: Si se encuentra otro (* dentro de un comentario, se incrementa el nivel de comentarios (comment_level++).

Acción: Si se encuentra un salto de línea (\n), se incrementa curr_lineno. Los demás caracteres dentro del comentario se ignoran.

Salida de un Comentario

```
<COMMENT>"*)" { 
  comment_level--; 
  if (comment_level == 0) {
    BEGIN(INITIAL);
  }
}
```
Explicación:
Patrón: Se encuentra un *) en el estado COMMENT.

Acción: Se decrementa comment_level. Si el nivel de comentarios llega a 0, se regresa al estado inicial (BEGIN(INITIAL)), indicando que el comentario ha terminado.

6. Operadores y Delimitadores

```
"." { return '.';}
"@" { return '@';}
"~" { return '~';}
"*" { return '*';}
"/" { return '/';}
"+" { return '+';}
"-" { return '-';}
"<" { return '<';}
"=" { return '=';}
"," { return ',';}
"{" { return '{';}
"}" { return '}';}
"(" { return '(';}
")" { return ')';}
":" { return ':';}
";" { return ';';}
```

Explicación:
Patrón: Cada uno de estos patrones corresponde a un operador o delimitador en el lenguaje COOL.

Acción: Cuando se detecta el operador o delimitador, se retorna el token correspondiente. Por ejemplo, un + se convierte en el token +.

7. Palabras Clave (Keywords)

```
{CLASS} { return CLASS; }
{IF}    { return IF; }
{FI}    { return FI; }
```

Explicación:
Patrón: Las palabras clave como CLASS, IF, FI, etc., se definen en el código utilizando expresiones regulares que coinciden con su variante en mayúsculas o minúsculas.

Acción: Se devuelve el token correspondiente a la palabra clave. Por ejemplo, si se encuentra CLASS, se devuelve el token CLASS.

8. Valores Booleanos (TRUE y FALSE)

```
{TRUE} { cool_yylval.boolean = true; return BOOL_CONST; }
{FALSE} { cool_yylval.boolean = false; return BOOL_CONST; }
```

Explicación:
Patrón: Coincide con los valores booleanos TRUE y FALSE, independientemente de la capitalización.

Acción: Se asigna el valor true o false a cool_yylval.boolean y se retorna el token BOOL_CONST.

9. Identificadores (TYPEID y OBJECTID)

```
{TYPEID} {
  cool_yylval.symbol = inttable.add_string(yytext);
  return TYPEID;
}
```

Explicación:
Patrón: Coincide con identificadores de tipo (TYPEID) y objetos (OBJECTID).

Acción: Se agrega el identificador a la tabla de símbolos (inttable) y se retorna el token TYPEID o OBJECTID.

10. Constantes Enteras (INT_CONST)

```
{DIGITS} {
  cool_yylval.symbol = inttable.add_string(yytext);
  return INT_CONST;
}
```
Explicación:
Patrón: Coincide con constantes enteras formadas por dígitos (DIGITS).

Acción: La constante entera se agrega a la tabla de símbolos y se retorna el token INT_CONST.

11. Cadenas de Texto
Inicio de una Cadena

```
\" {
  string_buf_ptr = string_buf;
  BEGIN(STRING);
}
```

Explicación:
Patrón: Cuando se encuentra una comilla doble (\"), se inicia una cadena.

Acción: Se inicia el buffer de cadena y se cambia al estado STRING.

Fin de la Cadena

```
<STRING>\" {
  if (isLong()) { return maxlen_error(); }
  *string_buf_ptr = '\\0'; /* null terminate the string */
  cool_yylval.symbol = stringtable.add_string(string_buf);
  BEGIN(INITIAL);
  return STR_CONST;
}
```

Explicación:
Patrón: Cuando se encuentra una comilla doble (\") dentro del estado STRING, se termina la cadena.

Acción: Se verifica si la cadena es válida (no demasiado larga) y se agrega a la tabla de cadenas. Luego, se retorna el token STR_CONST.

Error de Cadena No Terminada

```
<STRING>\n {
  if (isLong()) { return maxlen_error(); }
  curr_lineno++;
  cool_yylval.error_msg = "Unterminated string constant";
  BEGIN(INITIAL);
  return ERROR;
}
```
Explicación:
Patrón: Si se encuentra un salto de línea dentro de una cadena no terminada.

Acción: Se incrementa el número de línea y se retorna un error, indicando que la cadena no se cerró correctamente.

12. Manejo de Cadenas Inválidas
Cuando se detecta un error dentro de una cadena (por ejemplo, un carácter nulo \0), el scanner cambia al estado INVALID_STRING y genera un error.

13. Manejo de Errores Generales

```
. {
  cool_yylval.error_msg = strdup(yytext);
  return ERROR;
}
```

Explicación:
Patrón: Si se encuentra un carácter que no coincide con ninguna de las expresiones regulares anteriores, se genera un error.

Acción: Se guarda el texto en cool_yylval.error_msg y se retorna el token ERROR.

Resumen
En esta sección se han definido las reglas del analizador léxico, que determinan cómo se procesan los diferentes tokens del lenguaje COOL. Cada regla tiene un patrón (expresión regular) y una acción que se ejecuta cuando el patrón es detectado. Las reglas incluyen el manejo de comentarios, operadores, identificadores, constantes, cadenas de texto y manejo de errores.

# Proyecto Compilador COOL - Subrutinas de Usuario

Esta sección detalla las subrutinas de usuario utilizadas en el analizador léxico del compilador COOL. Estas funciones ayudan a manejar situaciones especiales durante el análisis léxico, como la verificación de la longitud de las cadenas y el manejo de errores relacionados con las cadenas.

## Comentarios y Funciones de Ayuda en el Estado STRING

Cuando el analizador léxico está procesando cadenas de texto en el estado `STRING`, se utilizan ciertas funciones para garantizar que las cadenas se manejen correctamente y para detectar errores si la longitud de una cadena excede el límite permitido.

### 1. Función `isLong()`

```
/*function to check the length of the string*/
bool isLong() {
    /* String length = ending pointer position of string - starting pointer position of string +1
         = string_buf_ptr - string_buf + 1
    
    if string length > MAX_STR_CONST -> return TRUE
    if string length < MAX_STR_CONST -> return FALSE
    */
    return (string_buf_ptr - string_buf + 1 > MAX_STR_CONST);
}
```

Explicación:
Objetivo: La función isLong() tiene como propósito verificar si la longitud de una cadena es mayor que el valor máximo permitido, que en este caso es MAX_STR_CONST.

Cómo funciona:

La diferencia entre string_buf_ptr y string_buf calcula el número de caracteres que han sido agregados hasta el momento en la cadena.

La suma de +1 es para incluir el primer carácter de la cadena.

La expresión string_buf_ptr - string_buf + 1 calcula la longitud de la cadena procesada en el buffer string_buf.

Comparación:

Si la longitud de la cadena es mayor que MAX_STR_CONST, la función devuelve true.

Si la longitud de la cadena es menor o igual a MAX_STR_CONST, la función devuelve false.

¿Por qué se usa?: Esta función es importante para verificar si la cadena excede el tamaño máximo permitido. Si la cadena es demasiado larga, se maneja como un error para evitar desbordamientos de memoria o comportamientos inesperados.

2. Función maxlen_error()
```
Copiar código
/*function to print error if maximum length is exceeded*/
int maxlen_error() {
    BEGIN(INVALID_STRING); // should continue reading the string
    cool_yylval.error_msg = "String constant too long";
    
    return ERROR;
}
Explicación:
Objetivo: La función maxlen_error() maneja el error que ocurre cuando una cadena de texto supera el límite de longitud permitido (es decir, cuando isLong() devuelve true).

Acción:
BEGIN(INVALID_STRING): Cambia el estado del scanner a INVALID_STRING, lo que indica que la cadena ha excedido la longitud máxima y ahora se encuentra en un estado de error. Esto ayuda a que el scanner continúe procesando la entrada sin confundirla con cadenas válidas.

cool_yylval.error_msg = "String constant too long";: Se asigna un mensaje de error a la variable cool_yylval.error_msg. Este mensaje se usará para informar que la cadena es demasiado larga para ser válida en COOL.

return ERROR;: La función retorna un token ERROR, lo que indica que algo salió mal (en este caso, que la cadena es demasiado larga). Esto informa al analizador sintáctico (parser) de que un error ha ocurrido y se debe manejar.

¿Por qué se usa?: Esta función es crucial para detectar cadenas de texto que exceden el tamaño máximo permitido y notificar el error de manera clara para que el parser pueda manejarlo adecuadamente.