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

// This is a structure that may be used to contain the semantic
// information such as the inheritance graph.  You may use it or not as
// you like: it is only here to provide a container for the supplied
// methods.

class ClassTable {
private:
  int semant_errors;
  void install_basic_classes();
  ostream& error_stream;
  std::map<Symbol, Class_> class_map;
  //map to save attributers and methods of each class
  std::map<Symbol, std::vector<Feature> > class_methods_map;
    std::map<Symbol, std::vector<Feature> > class_attrs_map;
  //symbol table to store attributes of current class during ast walk
  std::map<Symbol, std::vector<Symbol> > inheritance_graph; 

public:
  ClassTable(Classes);
  int errors() { return semant_errors; }

  void create_class_map( Classes classes);
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
  bool walk_attr(Feature f);
  bool walk_expression(Expression expr);
  bool walk_formals(Formals formals); 
  bool walk_method(Feature f);
  bool walk_ast_starting_with_classes();
  bool walk_ast_starting_with_class(Class_ c);
  ostream& semant_error();
  ostream& semant_error(Class_ c);
  ostream& semant_error(Symbol filename, tree_node *t);
};


#endif

