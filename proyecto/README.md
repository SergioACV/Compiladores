# Modificación del Lexer de COOL para Implementación de Guía de Estilo

Este proyecto se enfoca en modificar el lexer del lenguaje de programación COOL (Classroom Object-Oriented Language) para implementar una guía de estilo. La guía tiene como objetivo estandarizar la escritura de código y mejorar su legibilidad, consistencia y facilidad de mantenimiento. 

> ⚠️ **Importante:**  
> En este proyecto no se busca explicar el funcionamiento del lexer de COOL. 
>
> **Recomendaciones:**
> - Si deseas comprender cómo funciona el lexer antes de revisar las modificaciones realizadas para implementar la guía de estilo, se recomienda leer el archivo `README.md` de la carpeta **Lab 1**, donde se detalla el funcionamiento original del lexer.



## 1. Definición de Guía de Estilo

Una **guía de estilo** es un conjunto de normas y recomendaciones que estandariza la escritura de código, buscando mejorar su legibilidad, consistencia y facilidad de mantenimiento. Define aspectos como la nomenclatura, la indentación y la estructura del código, asegurando que todos los colaboradores sigan un formato común.

## 2. Razones para Usarla

Usar una guía de estilo mejora la **legibilidad** y **coherencia** del código, previene errores comunes y facilita la **colaboración** entre desarrolladores. Además, asegura que el código cumpla con las **mejores prácticas** de programación, haciendo que sea más fácil de mantener y entender a lo largo del tiempo.

## 3. Criterios Afectados por la Guía de Estilo

Una guía de estilo afecta los siguientes criterios:

- **Nombres de variables y funciones**
- **Indentación y espaciado**
- **Uso de comentarios**
- **Longitud de las líneas**
- **Estructura del código y organización de archivos**

Estos criterios buscan garantizar un código claro, consistente y fácil de leer.

## 4. Implementación en el Lexer de COOL

Para nutrir el apartado sobre la implementación de la guía de estilo en el lexer de COOL, podemos desglosar las modificaciones en el código en cuatro secciones principales: Definiciones, Estados, Reglas y Subrutinas. A continuación, te proporciono un detalle de las adiciones y cambios que realizaste en cada sección:

### 1. Definiciones:
Se añadieron nuevas variables para controlar la longitud de las líneas y la longitud de los bloques de código. Estas variables permiten aplicar restricciones de longitud en cada línea y bloque de código, lo que es fundamental para la implementación de la guía de estilo.

```cpp
/* Variables for checking line length */
int line_length = 0;
int MAX_LINE_LENGTH = 100;

/* Variables for checking outer block length */
bool enBloqueExterno = false;  // si estamos dentro del bloque más externo
int brace_depth = 0;           // profundidad de llaves
int lineasBloque = 0;          // contador de líneas del bloque externo
int MAX_BLOCK_LINES = 10;      // máximo de líneas permitidas en bloque externo
```

### 2. Estados

Se agregaron nuevos estados para manejar las modificaciones en el lexer, como la detección de líneas largas y la gestión de espacios extras. También se definieron expresiones regulares adicionales para validar los espacios adicionales y los saltos de línea.

```cpp
/* Nombres y expresiones regulares */
EXTRA_SPACE     [ ]{2,}   
NOT             [nN][oO][tT]
WHITESPACE      [\f\r\v ]*
TYPEID          [A-Z]([a-zA-Z0-9_])*
OBJECTID        [a-z]([a-zA-Z0-9_])*
NEWLINE         (\r\n|\n|\r)
```

### 3. Reglas
En esta sección, se añadieron reglas específicas para manejar la longitud de las líneas y los bloques. Se implementaron restricciones que detectan líneas que superan el límite de longitud (MAX_LINE_LENGTH) y errores cuando se encuentran tabs no permitidos. Además, se introdujeron verificaciones para los bloques de código, como contar las líneas dentro de un bloque y evitar que los bloques excedan el número máximo de líneas (MAX_BLOCK_LINES).

```cpp
/* Verificación de longitud de línea */
if (line_length > MAX_LINE_LENGTH) {
    line_length = 0; 
    cool_yylval.error_msg = "Line exceeds maximum length";
    return ERROR;
}
line_length = 0;

/* Detectar espacio extra */
{EXTRA_SPACE} {
    line_length += yyleng;
    cout << "Warning: extra spaces at line " << curr_lineno << endl;
}

/* Detectar tab prohibido */
\\t {
    line_length += yyleng;
    cool_yylval.error_msg = "Tab character is not allowed";
    return ERROR;
}

/* Comprobación de saltos de línea */
{NEWLINE} {
    if (enBloqueExterno) {
        lineasBloque++;  // contamos solo dentro del bloque externo
    }
    if (line_length > MAX_LINE_LENGTH) {
        line_length = 0; 
        cool_yylval.error_msg = "Line exceeds maximum length";
        return ERROR;
    }
    line_length = 0;
    curr_lineno++;
}
```
# Referencias
## PEM 8
> https://peps.python.org/pep-0008/
## CS143 Compilers
> https://web.stanford.edu/class/cs143/
## Repositorio de referencia 
> https://github.com/gboduljak/stanford-compilers-coursework/tree/master
## Compiladores unal 2025-2
> https://siabog.unal.edu.co/academia/catalogo-programas/info-asignatura.sdo?plan=2933&asignatura=2027642

---

Este proyecto tiene como objetivo no solo mejorar la calidad del código, sino también proporcionar un marco de referencia para futuros desarrollos y colaboraciones en proyectos que utilicen el lenguaje COOL.
