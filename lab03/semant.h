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
  std::map<Symbol, std::vector<Symbol> > inheritance_graph; 

public:
  ClassTable(Classes);
  int errors() { return semant_errors; }

  void create_class_map( Classes classes);
  bool build_inheritance_graph();
  bool isCyclicUtil(
      std::map<Symbol, std::vector<Symbol> >& adj,
      Symbol v,
      std::map<Symbol, bool>& visited,
      std::map<Symbol, bool>& recStack
);

  bool detect_cycles();
  ostream& semant_error();
  ostream& semant_error(Class_ c);
  ostream& semant_error(Symbol filename, tree_node *t);
};


#endif

