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


## Método `build_inheritance_graph`

El método `build_inheritance_graph()` se encarga de construir el **grafo de herencia** del programa COOL a partir de las clases registradas en `class_map`.  
Además, valida varias reglas de herencia y, en caso de violarse alguna, reporta errores semánticos y retorna `false`.

Objetivo
- Construir la estructura inheritance_graph que modela la jerarquía de clases.
- Registrar, en parent_type_of, el padre directo de cada clase.
- Validar que no se violen reglas básicas de herencia (heredar de clases prohibidas, heredar de clases no definidas, heredar de uno mismo).

Esta función devuelve:

- true si el grafo de herencia pudo construirse sin errores.
- false si se detecta alguna violación semántica (el llamador suele hacer if (!build_inheritance_graph()) raise_error();).

Estructuras utilizadas
class_map:

```cpp
std::map<Symbol, Class_> class_map;
Mapa que asocia el nombre de la clase (Symbol) con su nodo de definición (Class_).
```

inheritance_graph:

```cpp
std::map<Symbol, std::vector<Symbol>> inheritance_graph;
```
Representación del grafo de herencia:
- Clave: nombre de la clase padre.
- Valor: lista de clases hijas que heredan directamente de esa clase.
- parent_type_of:

```cpp
std::map<Symbol, Symbol> parent_type_of;
Para cada clase, guarda el nombre de su clase padre:
```

```cpp
parent_type_of["IO"]     = "Object";
parent_type_of["Int"]    = "Object";
parent_type_of["Bool"]   = "Object";
parent_type_of["String"] = "Object";
```

## Algoritmo paso a paso

### Recorrido de todas las clases

```cpp
for (std::map<Symbol, Class_>::iterator it = class_map.begin();
     it != class_map.end(); ++it) {
    Symbol class_name = it->first;
    ...
}
```

Se itera sobre todas las entradas de class_map. Cada iteración procesa una clase del programa

### Omisión de la clase Object

```cpp
Copiar código
if (class_name == Object)
    continue;
```

La clase Object es la raíz de la jerarquía; no tiene padre y no se registra como hija de nadie en el grafo.
Obtención de la definición de la clase y su padre

```cpp
Class_ class_definition = it->second;
Symbol parent_name = class_definition->get_parent();
```

class_definition: nodo del AST que representa a la clase.
parent_name: nombre de la clase padre declarada en el código COOL (por ejemplo, Object, IO, etc.).

### Clases sin padre explícito

```cpp
if (parent_name == No_class) continue;
Si la clase no tiene padre (o se representa como No_class), no se registra en el grafo (caso especial de raíz u otras decisiones de diseño).
```

### Registro de la relación hijo → padre

```cpp
parent_type_of[class_name] = parent_name;
Esto permite, más adelante, subir en la jerarquía desde cualquier clase hacia sus ancestros.
```

### Verificación de herencia de clases prohibidas

```cpp
if ( 
    parent_name == Str ||  
    parent_name == Int || 
    parent_name == Bool ||
    parent_name == SELF_TYPE
)
{
    this->semant_error(class_definition)
        << "Class "
        << class_definition->get_name()
        << " cannot inherit class "
        << parent_name
        << ".\n";
    return false;
}
```

COOL no permite heredar de ciertos tipos básicos (Int, Bool, String) ni de SELF_TYPE.
Si se intenta, se reporta un error semántico y se detiene la construcción del grafo.

### Verificación de que el padre exista

```cpp
if (this->class_map.find(parent_name) == this->class_map.end())
{
    semant_error(it->second) << "Class "
        << class_name 
        << " inherits from an undefined class "
        << parent_name
        << ".\n";
    return false;
}
```
Si el nombre de la clase padre no aparece en class_map, significa que el programa intenta heredar de una clase no definida.
Esto también se reporta como error semántico.

### Prevención de herencia de una clase sobre sí misma

```cpp
if (parent_name == class_name) {
    semant_error(class_name) << "Class " << class_name
                             << " cannot inherit from itself." << endl;
    return false;
}
```

Una clase no puede declararse como hija de sí misma. Este caso se detecta y se reporta.

### Inicialización de la lista de hijos del padre (si es necesario)

```cpp
if (this->inheritance_graph.find(parent_name) == this->inheritance_graph.end()) {
    this->inheritance_graph[parent_name] = std::vector<Symbol>();
}
```

Si el padre aún no tiene una entrada en inheritance_graph, se crea una lista vacía para sus hijos.

Registro de la arista padre → hijo en el grafo

```cpp
inheritance_graph[parent_name].push_back(class_name);
```

Se añade class_name a la lista de hijos de parent_name.
De esta manera se va construyendo la representación del grafo de herencia.

### Ejemplo conceptual del grafo resultante
Para un programa como:
\
```cool
Copiar código
class Object {
    abort(): Object;
    type_name(): String;
    copy(): SELF_TYPE;
};

class IO inherits Object { ... };

class Int inherits Object { ... };

class Bool inherits Object { ... };

class String inherits Object { ... };
```

El grafo de herencia construido quedaría, conceptualmente:

```text
Copiar código
inheritance_graph = {
    "Object" => ["IO", "Int", "Bool", "String"]
}
```

Y las relaciones en parent_type_of:

```cpp
parent_type_of["IO"]     = "Object";
parent_type_of["Int"]    = "Object";
parent_type_of["Bool"]   = "Object";
parent_type_of["String"] = "Object";
```

## Método walk_ast_to_register_methods_and_attributes

El método walk_ast_to_register_methods_and_attributes() recorre todas las clases del programa (las contenidas en class_map) y construye dos estructuras centrales para el análisis semántico:

- Un mapa de métodos por clase (class_methods).
- Un mapa de atributos por clase (class_attrs).

Con esto, el analizador semántico puede resolver, más adelante, qué métodos y atributos están disponibles en cada clase, verificar redefiniciones, herencias y tipos.

### Funcionamiento general


En program_class::semant() este método se invoca después de haber construido el grafo de herencia y detectado ciclos:

```cpp
void program_class::semant()
{
    initialize_constants();

    ClassTable *classtable = new ClassTable(classes);

    classtable->create_class_map(classes);
    classtable->check_inheritance_exists();
    classtable->is_main_class_defined();
    classtable->build_inheritance_graph();
    classtable->detect_cycles();

    /* Recorre el AST de clases para registrar métodos y atributos */
    classtable->walk_ast_to_register_methods_and_attributes();
}
```

La implementación básica es:

```cpp
bool ClassTable::walk_ast_to_register_methods_and_attributes() {
    for (std::map<Symbol, Class_>::iterator it = class_map.begin();
         it != class_map.end(); ++it) {
        Class_ c = it->second;
        register_class_and_its_methods(c);
    } 
    return true;
}
```


Para cada clase registrada en class_map, se llama a register_class_and_its_methods.

Registro de métodos y atributos por clase
Método register_class_and_its_methods

```cpp
void ClassTable::register_class_and_its_methods(Class_ class_definition) {
    class_methods[class_definition->get_name()] = get_class_methods(class_definition);
    class_attrs[class_definition->get_name()]   = get_class_attributes(class_definition);
}
```


Este método:

- Obtiene todos los métodos declarados en la clase mediante get_class_methods(...) y los almacena en class_methods[class_name].
- Obtiene todos los atributos declarados en la clase mediante get_class_attributes(...) y los almacena en class_attrs[class_name].

De esta forma, para cada nombre de clase se tiene acceso rápido a sus métodos y atributos propios (sin herencia todavía).

### Estructuras utilizadas

Conceptualmente, las estructuras manejadas por ClassTable son:

```cpp
// Métodos definidos en cada clase
std::map<Symbol, std::map<Symbol, method_class*> > class_methods;

// Atributos definidos en cada clase
std::map<Symbol, std::map<Symbol, attr_class*> > class_attrs;
```

- Clave externa: nombre de la clase.
- Clave interna: nombre del método o atributo.
- Valor: puntero al nodo correspondiente en el AST (method_class* o attr_class*).

```cpp
Obtención de métodos de una clase: get_class_methods
std::map<Symbol, method_class*> ClassTable::get_class_methods(Class_ class_definition) {
    std::map<Symbol, method_class*> class_methods;
    Features class_features = class_definition->get_features();

    for (int i = class_features->first(); class_features->more(i); i = class_features->next(i)) {
        Feature feature = class_features->nth(i);

        if (!feature->is_method())
            continue;

        method_class* method = static_cast<method_class*>(feature);
        Symbol method_name = method->get_name();

        // Comprobación de duplicados
        if (class_methods.find(method_name) != class_methods.end()) {
            semant_error(class_definition) 
                << "The method " << method_name << " has already been defined!\n";
        } else {
            class_methods[method_name] = method;
        }
    }

    return class_methods;
}
```


Pasos principales:

- Se obtienen las features de la clase (class_definition->get_features()).
- Se recorre cada Feature:
- Si no es un método (!feature->is_method()), se ignora.
- Si es un método, se castea a method_class* y se obtiene su nombre.
- Se verifica si el método ya fue declarado en la misma clase:
- Si ya existe un método con el mismo nombre, se reporta un error semántico por redefinición.
- Si no existe, se inserta en el mapa local class_methods.
- Al finalizar, se devuelve el mapa de métodos propios de esa clase.

Esto asegura que en una misma clase no se definan dos métodos con el mismo nombre.

Obtención de atributos de una clase: get_class_attributes
```cpp
std::map<Symbol, attr_class*> ClassTable::get_class_attributes(Class_ class_definition) {
    std::map<Symbol, attr_class*> class_attrs;
    Features class_features = class_definition->get_features();

    for (int i = class_features->first(); class_features->more(i); i = class_features->next(i)) {
        Feature feature = class_features->nth(i);

        if (!feature->is_attr())
            continue;

        attr_class* attr = static_cast<attr_class*>(feature);
        Symbol attr_name = attr->get_name();
        class_attrs[attr_name] = attr;
    }

    return class_attrs;
}
```


Pasos principales:

- Se recorren las features de la clase.
- Solo se procesan aquellas que son atributos (feature->is_attr()).
- Cada atributo se guarda en un mapa local class_attrs, indexado por su nombre.
- El mapa resultante se retorna y se asocia a la clase en register_class_and_its_methods.
- A diferencia de los métodos, en esta implementación base no se verifica aún si hay atributos duplicados en la misma clase; esa validación puede añadirse más adelante si se requiere.

### Resumen del rol de este paso en el análisis semántico

Una vez ejecutado walk_ast_to_register_methods_and_attributes():
- El compilador conoce, para cada clase, qué métodos y atributos están directamente declarados en ella.
- Esta información se utiliza en fases posteriores del análisis semántico para:
- Verificar redefiniciones válidas de métodos en subclases.
- Comprobar el acceso correcto a atributos.
- Construir entornos de símbolos (scopes) consistentes durante el chequeo de tipos de expresiones.
- En conjunto con create_class_map() y build_inheritance_graph(), este paso completa la estructura básica necesaria para un análisis semántico robusto del programa COOL.
