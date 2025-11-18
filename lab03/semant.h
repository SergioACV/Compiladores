// semant.h

#ifndef SEMANT_H_
#define SEMANT_H_

#include <assert.h>
#include <iostream>
#include "cool-tree.h"
#include "stringtab.h"
#include "symtab.h"
#include "list.h"

#include <vector>
#include <map>

#define TRUE 1
#define FALSE 0

class ClassTable;
typedef ClassTable *ClassTableP;

class ClassTable {
private:
    int semant_errors;
    void install_basic_classes();
    ostream& error_stream;
    std::map<Symbol, Class_> class_map;
    // Corregir la declaración de los mapas
    std::map<Symbol, std::vector<Feature> > class_methods_map;
    std::map<Symbol, std::vector<Feature> > class_attrs_map;
    std::map<Symbol, Symbol> parent_type_of;
    std::map<Symbol, std::vector<Symbol> > inheritance_graph; 

public:
    ClassTable(Classes classes);
    int errors() { return semant_errors; }

    void create_class_map(Classes classes);
    bool is_main_class_defined();
    bool check_inheritance_exists();
    bool build_inheritance_graph();
    bool isCyclicUtil(
        std::map<Symbol, std::vector<Symbol> >& adj,
        Symbol v,
        std::map<Symbol, bool>& visited,
        std::map<Symbol, bool>& recStack
    );
    bool detect_cycles();
    bool walk_expression(Expression expr);
    bool walk_formals(Formals formals); 
    bool walk_method(Feature f);
    bool walk_ast_to_register_methods_and_attributes();
    void register_class_and_its_methods(Class_ class_definition);
    std::map<Symbol, method_class*> get_class_methods(Class_ class_definition);
    std::map<Symbol, attr_class*> get_class_attributes(Class_ class_definition);

    ostream& semant_error();
    ostream& semant_error(Class_ c);
    ostream& semant_error(Symbol filename, tree_node *t);
};

#endif
