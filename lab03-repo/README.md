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


## Constructor `build_inheritance_graph`

### Objetivo

- Construir un grafo de herencia de clases en COOL.
- Validar las relaciones de herencia entre las clases.
- Detectar ciclos en la herencia y relaciones inválidas entre clases.

## Explicación de la Función

### 1. Iteración sobre las clases definidas

La función comienza iterando sobre todas las clases que están registradas en el mapa `class_lookup`. Este mapa contiene el nombre de cada clase (como clave) y la definición de la clase correspondiente (como valor).

```cpp
for (it = this->class_lookup.begin(); it != this->class_lookup.end(); ++it)
{
    Symbol class_name = it->first;
    Class_ class_definition = it->second;
}
```

### 2. Comprobación de la clase Object
La clase Object es la raíz de la jerarquía de herencia en COOL, y no tiene un padre. Por lo tanto, no es necesario procesarla en este paso.

```cpp
Copiar código
if (class_name == Object)
    continue;
```

### 3. Obtención y almacenamiento del padre de la clase
Para cada clase, se obtiene el nombre de la clase padre y se almacena en el mapa parent_type_of. Este mapa permite realizar consultas rápidas sobre el tipo del padre de cada clase.

```cpp
Copiar código
Symbol class_parent_name = class_definition->get_parent_name();
parent_type_of[class_name] = class_parent_name;
```

### 4. Validación de relaciones de herencia

-  Restricciones de herencia inválida
Se verifica si una clase intenta heredar de clases no permitidas, como Str, Int, Bool o SELF_TYPE. Estas clases son fundamentales y no pueden ser heredadas.

```cpp
Copiar código
if (class_parent_name == Str || class_parent_name == Int || class_parent_name == Bool || class_parent_name == SELF_TYPE)
{
    this->semant_error(class_definition)
        << "Class " << class_definition->get_name()
        << " cannot inherit class " << class_parent_name << ".\n";
    return false;
}
```

- Verificación de clases inexistentes
Se comprueba que la clase padre realmente exista en el sistema. Si no es así, se genera un error.

```cpp
Copiar código
if (this->class_lookup.find(class_parent_name) == this->class_lookup.end())
{
    this->semant_error(class_definition)
        << "Class " << class_name
        << " inherits from an undefined class " << class_parent_name << ".\n";
    return false;
}
```

### 5. Creación de la entrada para el padre en el grafo
Si la clase padre aún no tiene una entrada en el grafo de herencia, se crea una nueva entrada con un vector vacío.

```cpp
Copiar código
if (this->inheritance_graph.find(class_parent_name) == this->inheritance_graph.end())
{
    this->inheritance_graph[class_parent_name] = std::vector<Symbol>();
}
```

### 6. Agregando la clase actual al grafo
Una vez que la clase padre es verificada, la clase actual se agrega a la lista de hijos de esa clase en el grafo de herencia.

```cpp
Copiar código
this->inheritance_graph[class_parent_name].push_back(class_name);
```

## 1. `inheritance_dfs(Symbol symbol)`

Esta función realiza una **búsqueda en profundidad (DFS)** sobre el grafo de herencia para detectar ciclos. Utiliza un esquema de **colores** para marcar el estado de cada nodo (clase) durante la exploración del grafo. 

- **Estados posibles**:
  - `gray`: Nodo en proceso de ser visitado.
  - `black`: Nodo completamente visitado.
  - `white`: Nodo no visitado.

**Algoritmo**:
1. Se marca el nodo actual como `gray`.
2. Se itera sobre los hijos del nodo actual (es decir, las clases hijas).
3. Si se encuentra un hijo que ya está marcado como `gray`, significa que se ha detectado un ciclo de herencia.
4. Si no se detecta un ciclo, se marca el nodo como `black`.

**Código**:

```cpp
bool ClassTable::inheritance_dfs(Symbol symbol) {
    color_of[symbol] = gray;

    std::vector<Symbol> &vec = inheritance_graph[symbol];
    std::vector<Symbol>::iterator it;

    for (it = vec.begin(); it != vec.end(); ++it)
    {
        Symbol x = *it;

        if (color_of[x] == gray) // Ciclo detectado
        {
            semant_error() << "There exists an (in) direct circular dependency between: ";
            symbol->print(semant_error());
            semant_error() << " and ";
            x->print(semant_error());
            return false;
        }
        else
        {
            if (!inheritance_dfs(x)) // Llamada recursiva
                return false;
        }
    }

    color_of[symbol] = black; // Nodo procesado completamente
    return true;
}```

2. is_inheritance_graph_acyclic()
Esta función verifica si el grafo de herencia es acíclico. Realiza un DFS desde cada clase para asegurarse de que no haya ciclos. Si se detecta un ciclo, la función retorna false. Si no se detectan ciclos, retorna true.

Código:

```cpp
Copiar código
bool ClassTable::is_inheritance_graph_acyclic() {
    color_of.clear(); // Limpiar los colores antes de comenzar

    // Inicializar colores a "white"
    std::map<Symbol, Class_>::iterator it;
    for (it = class_lookup.begin(); it != class_lookup.end(); ++it) {
        color_of[it->first] = white;
    }

    // DFS desde nodos blancos
    for (it = class_lookup.begin(); it != class_lookup.end(); ++it) {
        Symbol sym = it->first;

        if (color_of[sym] == white) {
            if (!this->inheritance_dfs(sym)) // Llamada recursiva al DFS
                return false;
        }
    }

    return true; // El grafo de herencia es acíclico
}
```

### 3. is_class_table_valid()
Esta función verifica la validez de la tabla de clases en su totalidad. Realiza dos comprobaciones clave:
Verifica que el grafo de herencia no tenga ciclos mediante is_inheritance_graph_acyclic().
Verifica que la clase Main esté definida, ya que es obligatoria para la ejecución del programa COOL.

Código:

```cpp
Copiar código
bool ClassTable::is_class_table_valid() {
    if (!this->is_inheritance_graph_acyclic()) // Verifica que el grafo de herencia no tenga ciclos
        return false;

    if (!this->is_type_defined(Main)) { // Verifica que la clase Main esté definida
        semant_error() << "Class Main is not defined.\n";
        return false;
    }

    return true; // La tabla de clases es válida
}
```

## Conclusión

El archivo `cool-tree.h` define las clases y constructores fundamentales para representar un programa COOL en un compilador. Estas clases se organizan en diferentes "phylum" o categorías, que incluyen programas, clases, características, expresiones y casos. Los métodos definidos en cada clase permiten copiar y mostrar las estructuras de datos correspondientes, mientras que las extensiones en `cool-tree.handcode.h` añaden funciones para manipular y verificar los tipos de las expresiones.

Esta estructura es esencial para la implementación de un compilador para el lenguaje COOL, proporcionando una base para construir y analizar árboles sintácticos abstractos (AST).
