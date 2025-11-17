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
