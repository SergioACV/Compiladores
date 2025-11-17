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


Objetivo del Método build_inheritance_graph()

El método build_inheritance_graph() tiene como objetivo construir el grafo de herencia de un programa COOL. Este grafo representa las relaciones jerárquicas entre las clases y sus clases base. Además, el método realiza verificaciones para asegurar que las clases estén correctamente definidas y no haya herencias inválidas.

Proceso General

Recorrido de las clases: El método itera sobre todas las clases definidas en el programa utilizando un contenedor (class_lookup), que mapea los nombres de las clases a sus definiciones.

Comprobación de la clase base: Para cada clase, se obtiene el nombre de su clase base.

Verificación de herencia válida:

Se asegura de que la clase base esté definida en el programa.

Se verifica que la clase base no sea una clase predefinida (como Str, Int, Bool, SELF_TYPE), que no se permite heredar.

Construcción del grafo de herencia: El método crea un grafo donde cada clase base es una clave y las clases que heredan de ella son los valores (en un vector).

Registro de errores: Si se detecta alguna condición inválida (como herencia cíclica, herencia de una clase no definida, o herencia de clases no permitidas), el método lanza un error y detiene la ejecución.

Cómo Funciona el Grafo de Herencia

El grafo de herencia se almacena en un mapa (inheritance_graph), donde:

La clave es el nombre de la clase base.

El valor es un vector de las clases que heredan de esa clase base.

El método también verifica que no existan ciclos en el grafo de herencia y garantiza que todas las clases hereden de clases existentes.

Ejemplo Práctico

A continuación, se presenta un ejemplo de un programa COOL y cómo el método build_inheritance_graph() construiría el grafo de herencia.

Código COOL del Ejemplo:
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


En este programa, tenemos las siguientes clases:

Object: Clase base de todas las clases en COOL.

IO, Int, Bool, String: Clases que heredan de Object.

Proceso Paso a Paso en build_inheritance_graph():

Clase Object:

Clase base: No tiene clase base, es la raíz de la jerarquía.

No se agrega al grafo de herencia porque Object no tiene clase base.

Clase IO:

Clase base: Object.

Se registra en el mapa parent_type_of:

parent_type_of["IO"] = "Object";


Se agrega IO al grafo de herencia de Object:

inheritance_graph["Object"].push_back("IO");


El grafo de herencia ahora tiene:

inheritance_graph = {
    "Object" => ["IO"]
};


Clase Int:

Clase base: Object.

Se registra en el mapa parent_type_of:

parent_type_of["Int"] = "Object";


Se agrega Int al grafo de herencia de Object:

inheritance_graph["Object"].push_back("Int");


El grafo de herencia ahora tiene:

inheritance_graph = {
    "Object" => ["IO", "Int"]
};


Clase Bool:

Clase base: Object.

Se registra en el mapa parent_type_of:

parent_type_of["Bool"] = "Object";


Se agrega Bool al grafo de herencia de Object:

inheritance_graph["Object"].push_back("Bool");


El grafo de herencia ahora tiene:

inheritance_graph = {
    "Object" => ["IO", "Int", "Bool"]
};


Clase String:

Clase base: Object.

Se registra en el mapa parent_type_of:

parent_type_of["String"] = "Object";


Se agrega String al grafo de herencia de Object:

inheritance_graph["Object"].push_back("String");


El grafo de herencia ahora tiene:

inheritance_graph = {
    "Object" => ["IO", "Int", "Bool", "String"]
};

Resultado Final del Grafo de Herencia:

Al finalizar la ejecución del método build_inheritance_graph(), el grafo de herencia será el siguiente:

inheritance_graph = {
    "Object" => ["IO", "Int", "Bool", "String"]
};


Este grafo muestra que Object es la clase base de IO, Int, Bool y String. Estas clases heredan directamente de Object.