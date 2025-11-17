# Analizador Semántico de COOL

Este es un analizador semántico para el lenguaje de programación COOL (Classroom Object-Oriented Language). Su propósito es verificar la corrección semántica de los programas escritos en COOL, asegurando que las clases, los métodos, y las expresiones estén bien definidos y sean consistentes.

## Descripción general

El analizador semántico realiza dos tareas principales:

1. Verificar que el programa sea semánticamente correcto.
2. Decorar el árbol de sintaxis abstracta (AST) con la información de tipo, ajustando el campo `type` de cada nodo de expresión.

## `create_class_map`: Explicación del método

### Propósito

El método `create_class_map` es responsable de construir un mapa interno de las clases definidas en el programa COOL. Este mapa se utiliza para realizar un seguimiento de todas las clases y sus relaciones de herencia, lo que es esencial para el análisis semántico posterior.

### Funcionamiento

Este método recibe como entrada la lista de clases definidas en el programa y crea un mapa que vincula los nombres de las clases con sus respectivas representaciones. El mapa resultante (`class_map`) permite al analizador semántico acceder rápidamente a la información de cada clase, facilitando la verificación de la existencia de herencias, la validación de métodos y el control de los errores semánticos.

El proceso de creación del mapa de clases incluye las siguientes etapas:

1. **Inicialización de clases**: El método recorre todas las clases definidas en el programa y las agrega a una estructura de datos interna.
2. **Relaciones de herencia**: Durante este proceso, también se verifican las relaciones de herencia entre clases, asegurándose de que las clases base existan en el mapa y que no haya ciclos en la jerarquía de herencia.
3. **Verificación de errores**: Si alguna clase no se puede agregar correctamente al mapa (por ejemplo, si intenta heredar de una clase no definida), se genera un error semántico que detiene la compilación.

### Ejemplo de uso

El método `create_class_map` se invoca dentro del método `program_class::semant()`, que es el punto de entrada principal para el análisis semántico. Aquí se muestra cómo se utiliza:


# Método `build_inheritance_graph`

Este documento describe el funcionamiento del método `build_inheritance_graph()` dentro de la estructura `ClassTable` del analizador semántico de COOL.  
Su responsabilidad principal es construir el **grafo de herencia** del programa y verificar que la jerarquía de clases sea **válida y bien formada**.

---

## Objetivo del método `build_inheritance_graph()`

El método `build_inheritance_graph()` construye el grafo de herencia de un programa COOL, donde se representan las relaciones jerárquicas entre las clases y sus clases base.  
Además, realiza verificaciones semánticas para asegurar que:

- Todas las clases hereden de clases **definidas**.
- No se herede de clases **prohibidas** (como `Int`, `Bool`, `String`, `SELF_TYPE`, según las reglas de COOL).
- No existan **ciclos de herencia**.
- La jerarquía sea **consistente** y utilizable en etapas posteriores del análisis semántico (tipos, métodos, etc.).

---

## Proceso general del método

De forma simplificada, `build_inheritance_graph()` sigue estos pasos:

1. **Recorrido de las clases**

   Recorre todas las clases definidas en el programa utilizando una estructura como `class_lookup`, que mapea:

   ```cpp
   Symbol  ->  Class_ (definición de la clase)
Obtención de la clase base

Para cada clase se obtiene el nombre de su clase padre (base), normalmente algo como:

cpp
Copiar código
Symbol parent_name = cls->get_parent();
Verificación de herencia válida

Para cada clase se comprueba:

Que la clase base existe en la tabla de clases.

Que la clase base no es una clase de herencia prohibida (por ejemplo, Int, Bool, String, SELF_TYPE, dependiendo de la implementación).

Si alguna de estas condiciones falla, se registra un error semántico.

Construcción del grafo de herencia

Se construye una estructura tipo:

cpp
Copiar código
std::map<Symbol, std::vector<Symbol>> inheritance_graph;
donde:

La clave es el nombre de la clase base.

El valor es un vector con los nombres de las clases que heredan de esa base.

Ejemplo conceptual:

text
Copiar código
inheritance_graph["Object"] = ["IO", "Int", "Bool", "String"];
Registro de errores

Durante el proceso pueden detectarse errores como:

Herencia de una clase no definida.

Herencia de una clase no permitida.

Ciclos en la jerarquía de herencia.

En estos casos, el método registra el error (por ejemplo con semant_error()) y la compilación se puede detener más adelante con algo como:

cpp
Copiar código
if (class_table->errors())
    raise_error();
Estructura del grafo de herencia
El grafo de herencia se almacena típicamente en un mapa llamado, por ejemplo, inheritance_graph:

cpp
Copiar código
std::map<Symbol, std::vector<Symbol>> inheritance_graph;
Clave: nombre de la clase padre.

Valor: vector de nombres de clases hijas que heredan directamente de esa clase.

Adicionalmente, suele existir otra estructura auxiliar, como:

cpp
Copiar código
std::map<Symbol, Symbol> parent_type_of;
que guarda, para cada clase, su clase padre:

cpp
Copiar código
parent_type_of["IO"]     = "Object";
parent_type_of["Int"]    = "Object";
parent_type_of["Bool"]   = "Object";
parent_type_of["String"] = "Object";
Con estas dos estructuras (inheritance_graph y parent_type_of) se puede:

Recorrer la jerarquía hacia arriba (hacia los ancestros).

Recorrer la jerarquía hacia abajo (hacia las subclases).

Ejemplo práctico
Código COOL de ejemplo
cool
Copiar código
class Object {
    abort(): Object;
    type_name(): String;
    copy(): SELF_TYPE;
};

class IO inherits Object {
    out_string(s: String): SELF_TYPE;
    out_int(i: Int): SELF_TYPE;
};

class Int inherits Object {
    val: Int;
};

class Bool inherits Object {
    val: Bool;
};

class String inherits Object {
    val: Int;
    str_field: String;
    length(): Int;
    concat(s: String): String;
    substr(i: Int, j: Int): String;
};
Clases presentes:

Object: clase base raíz de la jerarquía.

IO, Int, Bool, String: heredan directamente de Object.

Paso a paso de build_inheritance_graph() en el ejemplo
1. Clase Object
Clase base: no tiene (es la raíz).

No se registra como hija de nadie en inheritance_graph.

2. Clase IO
Clase base: Object.

Se registra la relación:

cpp
Copiar código
parent_type_of["IO"] = "Object";
inheritance_graph["Object"].push_back("IO");
Estado del grafo:

text
Copiar código
inheritance_graph = {
    "Object" => ["IO"]
};
3. Clase Int
Clase base: Object.

cpp
Copiar código
parent_type_of["Int"] = "Object";
inheritance_graph["Object"].push_back("Int");
Estado del grafo:

text
Copiar código
inheritance_graph = {
    "Object" => ["IO", "Int"]
};
4. Clase Bool
Clase base: Object.

cpp
Copiar código
parent_type_of["Bool"] = "Object";
inheritance_graph["Object"].push_back("Bool");
Estado del grafo:

text
Copiar código
inheritance_graph = {
    "Object" => ["IO", "Int", "Bool"]
};
5. Clase String
Clase base: Object.

cpp
Copiar código
parent_type_of["String"] = "Object";
inheritance_graph["Object"].push_back("String");
Estado final del grafo:

text
Copiar código
inheritance_graph = {
    "Object" => ["IO", "Int", "Bool", "String"]
};
Resultado final
Al finalizar la ejecución de build_inheritance_graph(), el grafo de herencia refleja que:

Object es la clase raíz.

IO, Int, Bool y String son clases que heredan directamente de Object.

Este grafo se utilizará después para:

Comprobar tipos y compatibilidad en asignaciones y llamadas a métodos.

Recorrer la jerarquía de clases durante el análisis semántico.

Detectar errores relacionados con herencia y tipos.

Copiar código
