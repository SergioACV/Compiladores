# Documentación del Proyecto COOL - Estructuras y Clases

Este proyecto contiene la implementación de las clases necesarias para representar las construcciones del lenguaje de programación **COOL** (un lenguaje diseñado para la enseñanza de compiladores). Las clases y constructores definidos en los archivos `cool-tree.h` y `cool-tree.handcode.h` son fundamentales para la representación de programas COOL en el compilador, en forma de árboles sintácticos abstractos (AST).

## Estructura del Proyecto

### Archivos Principales

1. **`cool-tree.h`**: 
   Define las clases y estructuras que representan las entidades del lenguaje COOL, como programas, clases, métodos, atributos, expresiones, y casos.

2. **`cool-tree.handcode.h`**: 
   Contiene funciones adicionales para manipular las clases definidas en `cool-tree.h`, como la serialización (impresión de la estructura en un flujo de salida), copias de objetos, y verificación de tipos.

---

## Clases Definidas en `cool-tree.h`

### 1. **`Program_class`**

- **Descripción**: Representa un programa en COOL, que consiste en un conjunto de clases.
- **Métodos**:
  - `copy_Program()`: Método virtual para copiar el programa.
  - `copy()`: Llama a `copy_Program()` para crear una copia de la instancia.

### 2. **`Class__class`**

- **Descripción**: Representa una clase en COOL. Cada clase tiene un nombre, un tipo de clase base, y un conjunto de características (métodos y atributos).
- **Métodos**:
  - `copy_Class_()`: Método virtual para copiar la clase.
  - `copy()`: Llama a `copy_Class_()` para crear una copia de la instancia.

### 3. **`Feature_class`**

- **Descripción**: Representa una característica (atributo o método) de una clase.
- **Métodos**:
  - `copy_Feature()`: Método virtual para copiar la característica.
  - `copy()`: Llama a `copy_Feature()`.

### 4. **`Formal_class`**

- **Descripción**: Representa un parámetro formal de un método.
- **Métodos**:
  - `copy_Formal()`: Método virtual para copiar el parámetro formal.
  - `copy()`: Llama a `copy_Formal()`.

### 5. **`Expression_class`**

- **Descripción**: Representa una expresión en COOL, que puede ser una operación, un valor constante, o una asignación.
- **Métodos**:
  - `copy_Expression()`: Método virtual para copiar la expresión.
  - `copy()`: Llama a `copy_Expression()`.

### 6. **`Case_class`**

- **Descripción**: Representa un caso dentro de una expresión `typcase`, que se utiliza para realizar pruebas de tipo en tiempo de ejecución.
- **Métodos**:
  - `copy_Case()`: Método virtual para copiar el caso.
  - `copy()`: Llama a `copy_Case()`.

---

## Clases de Constructores

### 1. **`program_class`**

- **Descripción**: Representa un programa COOL. El constructor toma una lista de clases y las almacena en el atributo `classes`.
- **Métodos**:
  - `copy_Program()`: Copia el programa.
  - `dump()`: Imprime el programa.

### 2. **`class__class`**

- **Descripción**: Representa una clase en COOL, que contiene un nombre, un tipo de clase base (padre), una lista de características (métodos y atributos), y el nombre del archivo.
- **Métodos**:
  - `copy_Class_()`: Copia la clase.
  - `dump()`: Imprime la clase.

### 3. **`method_class`**

- **Descripción**: Representa un método en una clase. Cada método tiene un nombre, una lista de parámetros formales, un tipo de retorno, y una expresión que define el cuerpo del método.
- **Métodos**:
  - `copy_Feature()`: Copia el método.
  - `dump()`: Imprime el método.

### 4. **`attr_class`**

- **Descripción**: Representa un atributo de una clase. Un atributo tiene un nombre, un tipo declarado, y una expresión de inicialización.
- **Métodos**:
  - `copy_Feature()`: Copia el atributo.
  - `dump()`: Imprime el atributo.

### 5. **`formal_class`**

- **Descripción**: Representa un parámetro formal de un método.
- **Métodos**:
  - `copy_Formal()`: Copia el parámetro formal.
  - `dump()`: Imprime el parámetro formal.

### 6. **`branch_class`**

- **Descripción**: Representa una rama dentro de una expresión `typcase`. Cada rama tiene un nombre, un tipo declarado y una expresión asociada.
- **Métodos**:
  - `copy_Case()`: Copia la rama.
  - `dump()`: Imprime la rama.

---

## Clases de Expresiones

### 1. **`assign_class`**

- **Descripción**: Representa una asignación de un valor a una variable.
- **Métodos**:
  - `copy_Expression()`: Copia la asignación.
  - `dump()`: Imprime la asignación.

### 2. **`static_dispatch_class`**

- **Descripción**: Representa una llamada a un método estático.
- **Métodos**:
  - `copy_Expression()`: Copia la llamada estática.
  - `dump()`: Imprime la llamada estática.

### 3. **`dispatch_class`**

- **Descripción**: Representa una llamada a un método en un objeto.
- **Métodos**:
  - `copy_Expression()`: Copia la llamada a método.
  - `dump()`: Imprime la llamada al método.

### 4. **`cond_class`**

- **Descripción**: Representa una expresión condicional (similar a un `if` en otros lenguajes).
- **Métodos**:
  - `copy_Expression()`: Copia la expresión condicional.
  - `dump()`: Imprime la expresión condicional.

### 5. **`loop_class`**

- **Descripción**: Representa un bucle (similar a un `while` en otros lenguajes).
- **Métodos**:
  - `copy_Expression()`: Copia el bucle.
  - `dump()`: Imprime el bucle.

### 6. **`typcase_class`**

- **Descripción**: Representa una expresión de tipo `typcase`, que se utiliza para realizar comprobaciones de tipo dinámicas.
- **Métodos**:
  - `copy_Expression()`: Copia la expresión `typcase`.
  - `dump()`: Imprime la expresión `typcase`.

### 7. **`block_class`**

- **Descripción**: Representa un bloque de expresiones que se ejecutan secuencialmente.
- **Métodos**:
  - `copy_Expression()`: Copia el bloque de expresiones.
  - `dump()`: Imprime el bloque de expresiones.

### 8. **`let_class`**

- **Descripción**: Representa una expresión `let` que declara una variable y le asigna un valor.
- **Métodos**:
  - `copy_Expression()`: Copia la expresión `let`.
  - `dump()`: Imprime la expresión `let`.

### 9. **`plus_class`, `sub_class`, `mul_class`, `divide_class`**

- **Descripción**: Representan operaciones aritméticas (suma, resta, multiplicación y división).
- **Métodos**:
  - `copy_Expression()`: Copia la operación aritmética.
  - `dump()`: Imprime la operación aritmética.

### 10. **`neg_class`**

- **Descripción**: Representa la operación de negación lógica.
- **Métodos**:
  - `copy_Expression()`: Copia la negación lógica.
  - `dump()`: Imprime la negación lógica.

### 11. **`lt_class`, `eq_class`, `leq_class`**

- **Descripción**: Representan las operaciones de comparación (menor que, igual a, menor o igual que).
- **Métodos**:
  - `copy_Expression()`: Copia la operación de comparación.
  - `dump()`: Imprime la operación de comparación.

### 12. **`comp_class`**

- **Descripción**: Representa la operación de negación lógica (como un `not`).
- **Métodos**:
  - `copy_Expression()`: Copia la negación lógica.
  - `dump()`: Imprime la negación lógica.

### 13. **`int_const_class`, `bool_const_class`, `string_const_class`**

- **Descripción**: Representan constantes enteras, booleanas y de cadena.
- **Métodos**:
  - `copy_Expression()`: Copia la constante.
  - `dump()`: Imprime la constante.

### 14. **`new__class`**

- **Descripción**: Representa una operación de creación de un nuevo objeto.
- **Métodos**:
  - `copy_Expression()`: Copia la operación de creación de un objeto.
  - `dump()`: Imprime la operación de creación.

### 15. **`isvoid_class`**

- **Descripción**: Representa la operación `isvoid`, que verifica si un valor es de tipo `void`.
- **Métodos**:
  - `copy_Expression()`: Copia la expresión `isvoid`.
  - `dump()`: Imprime la expresión `isvoid`.

### 16. **`no_expr_class`**

- **Descripción**: Representa una expresión vacía o nula.
- **Métodos**:
  - `copy_Expression()`: Copia la expresión vacía.
  - `dump()`: Imprime la expresión vacía.

### 17. **`object_class`**

- **Descripción**: Representa un objeto en COOL.
- **Métodos**:
  - `copy_Expression()`: Copia el objeto.
  - `dump()`: Imprime el objeto.

### Aclaracion 
- neg_class	not o negación lógica	Invierte un valor booleano: true se convierte en false y false en true.
- comp_class	isvoid o comprobación de tipo void	Verifica si una expresión es de tipo void (devuelve true si es void, de lo contrario false).
---

## Funciones de Interfaz

En el archivo `cool-tree.handcode.h`, se definen varias funciones de interfaz para manipular las listas de clases, características, parámetros formales, expresiones y casos. Estas funciones son esenciales para manejar la creación, modificación y conexión de las diferentes entidades que forman un programa COOL.

---
# Documentación del Proyecto - Analizador Semántico

Este proyecto es parte de la implementación del compilador para el lenguaje **COOL** (Classroom Object Oriented Language). El propósito principal de este componente es realizar el **análisis semántico** de los programas escritos en COOL, asegurando que los programas sean **semánticamente correctos** antes de generar el código intermedio.

## Descripción del Proyecto

El **analizador semántico** es responsable de verificar la **validez semántica** de los programas en COOL. A través de una serie de comprobaciones, el analizador asegura que las clases, métodos, atributos, expresiones y tipos estén correctamente definidos y que el código cumpla con las reglas del lenguaje.

### Estructura Principal del Proyecto

El proyecto está compuesto por varios módulos que manejan las diferentes partes del análisis semántico:

- **`semant.h`**: Definiciones de la clase `ClassTable`, que gestiona la información de las clases y su herencia, así como las funciones para verificar tipos y errores semánticos.
- **`semant.cc`**: Implementación de las funciones del analizador semántico, que realizan la comprobación de la semántica, construyen el árbol de herencia, y verifican la validez de las clases y métodos definidos por el usuario.

## Función `initialize_constants()`

### Propósito

La función **`initialize_constants()`** se encarga de inicializar los **símbolos constantes** que serán utilizados a lo largo del compilador para hacer referencia a los tipos primitivos, métodos y nombres reservados en el lenguaje COOL. Estos símbolos son esenciales para realizar las verificaciones semánticas durante la fase de compilación.

### Detalles de la Implementación

La función **`initialize_constants()`** asigna símbolos a las siguientes entidades predefinidas en COOL:

- **Tipos primitivos**: `Int`, `Bool`, `Str`, `Object`, `SELF_TYPE`
- **Métodos reservados**: `cool_abort`, `copy`, `length`, `concat`, `substr`, `out_int`, etc.
- **Atributos especiales**: `self`, `val`, `str_field`, `type_name`

## Constructor `ClassTable::ClassTable(Classes classes)`

El constructor `ClassTable` es responsable de crear la tabla de clases (`class_lookup`) e inicializar las clases predeterminadas como `Object`, `IO`, `Int`, `Bool`, y `Str`. Estas clases son fundamentales para el funcionamiento del lenguaje COOL.

### Detalles de la Función `install_basic_classes`

El método `install_basic_classes` define las clases básicas del lenguaje COOL. A continuación se describen las clases y sus métodos principales:

### 1. **Clase `Object`**
   - **Descripción**: La clase base para todas las clases en COOL.
   - **Métodos**:
     - `abort()`: Aborta la ejecución del programa.
     - `type_name()`: Retorna una representación de cadena del nombre de la clase.
     - `copy()`: Crea una copia del objeto.

### 2. **Clase `IO`**
   - **Descripción**: Clase que hereda de `Object` y proporciona funcionalidades para la entrada/salida.
   - **Métodos**:
     - `out_string(Str)`: Imprime una cadena.
     - `out_int(Int)`: Imprime un número entero.
     - `in_string()`: Lee una cadena desde la entrada.
     - `in_int()`: Lee un número entero desde la entrada.

### 3. **Clase `Int`**
   - **Descripción**: Hereda de `Object` y representa los números enteros.
   - **Atributos**:
     - `val`: Un atributo que almacena el valor entero.

### 4. **Clase `Bool`**
   - **Descripción**: Hereda de `Object` y representa valores booleanos (`true` o `false`).
   - **Atributos**:
     - `val`: Un atributo que almacena el valor booleano.

### 5. **Clase `Str`**
   - **Descripción**: Hereda de `Object` y representa las cadenas de texto.
   - **Atributos**:
     - `val`: La longitud de la cadena.
     - `str_field`: El contenido de la cadena.
   - **Métodos**:
     - `length()`: Retorna la longitud de la cadena.
     - `concat(Str)`: Realiza la concatenación de dos cadenas.
     - `substr(Int, Int)`: Extrae un subconjunto de la cadena.

### Agregando las Clases a la Tabla `class_lookup`

Una vez que las clases básicas son definidas, se agregan a la tabla de clases `class_lookup` utilizando su nombre como clave y la definición de la clase como valor. Este paso asegura que las clases estén disponibles para su uso en cualquier parte del programa COOL.



## Conclusión

El archivo `cool-tree.h` define las clases y constructores fundamentales para representar un programa COOL en un compilador. Estas clases se organizan en diferentes "phylum" o categorías, que incluyen programas, clases, características, expresiones y casos. Los métodos definidos en cada clase permiten copiar y mostrar las estructuras de datos correspondientes, mientras que las extensiones en `cool-tree.handcode.h` añaden funciones para manipular y verificar los tipos de las expresiones.

Esta estructura es esencial para la implementación de un compilador para el lenguaje COOL, proporcionando una base para construir y analizar árboles sintácticos abstractos (AST).
