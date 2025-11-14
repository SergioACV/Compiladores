

#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include "semant.h"
#include "utilities.h"
#include <symtab.h>
#include <vector>
#include <map>


extern int semant_debug;
extern char *curr_filename;

SymbolTable<Symbol,Symbol> *objects_table;

//////////////////////////////////////////////////////////////////////
//
// Symbols
//
// For convenience, a large number of symbols are predefined here.
// These symbols include the primitive type and method names, as well
// as fixed names used by the runtime system.
//
//////////////////////////////////////////////////////////////////////
static Symbol 
    arg,
    arg2,
    Bool,
    concat,
    cool_abort,
    copy,
    Int,
    in_int,
    in_string,
    IO,
    length,
    Main,
    main_meth,
    No_class,
    No_type,
    Object,
    out_int,
    out_string,
    prim_slot,
    self,
    SELF_TYPE,
    Str,
    str_field,
    substr,
    type_name,
    val;
//
// Initializing the predefined symbols.
//
static void initialize_constants(void)
{
    arg         = idtable.add_string("arg");
    arg2        = idtable.add_string("arg2");
    Bool        = idtable.add_string("Bool");
    concat      = idtable.add_string("concat");
    cool_abort  = idtable.add_string("abort");
    copy        = idtable.add_string("copy");
    Int         = idtable.add_string("Int");
    in_int      = idtable.add_string("in_int");
    in_string   = idtable.add_string("in_string");
    IO          = idtable.add_string("IO");
    length      = idtable.add_string("length");
    Main        = idtable.add_string("Main");
    main_meth   = idtable.add_string("main");
    //   _no_class is a symbol that can't be the name of any 
    //   user-defined class.
    No_class    = idtable.add_string("_no_class");
    No_type     = idtable.add_string("_no_type");
    Object      = idtable.add_string("Object");
    out_int     = idtable.add_string("out_int");
    out_string  = idtable.add_string("out_string");
    prim_slot   = idtable.add_string("_prim_slot");
    self        = idtable.add_string("self");
    SELF_TYPE   = idtable.add_string("SELF_TYPE");
    Str         = idtable.add_string("String");
    str_field   = idtable.add_string("_str_field");
    substr      = idtable.add_string("substr");
    type_name   = idtable.add_string("type_name");
    val         = idtable.add_string("_val");
}



ClassTable::ClassTable(Classes classes) : semant_errors(0) , error_stream(cerr) {
    this->install_basic_classes();
    /* Fill this in */

}

void ClassTable::install_basic_classes() {

    // The tree package uses these globals to annotate the classes built below.
   // curr_lineno  = 0;
    Symbol filename = stringtable.add_string("<basic class>");
    
    // The following demonstrates how to create dummy parse trees to
    // refer to basic Cool classes.  There's no need for method
    // bodies -- these are already built into the runtime system.
    
    // IMPORTANT: The results of the following expressions are
    // stored in local variables.  You will want to do something
    // with those variables at the end of this method to make this
    // code meaningful.

    // 
    // The Object class has no parent class. Its methods are
    //        abort() : Object    aborts the program
    //        type_name() : Str   returns a string representation of class name
    //        copy() : SELF_TYPE  returns a copy of the object
    //
    // There is no need for method bodies in the basic classes---these
    // are already built in to the runtime system.

    Class_ Object_class =
	class_(Object, 
	       No_class,
	       append_Features(
			       append_Features(
					       single_Features(method(cool_abort, nil_Formals(), Object, no_expr())),
					       single_Features(method(type_name, nil_Formals(), Str, no_expr()))),
			       single_Features(method(copy, nil_Formals(), SELF_TYPE, no_expr()))),
	       filename);

    // 
    // The IO class inherits from Object. Its methods are
    //        out_string(Str) : SELF_TYPE       writes a string to the output
    //        out_int(Int) : SELF_TYPE            "    an int    "  "     "
    //        in_string() : Str                 reads a string from the input
    //        in_int() : Int                      "   an int     "  "     "
    //
    Class_ IO_class = 
	class_(IO, 
	       Object,
	       append_Features(
			       append_Features(
					       append_Features(
							       single_Features(method(out_string, single_Formals(formal(arg, Str)),
										      SELF_TYPE, no_expr())),
							       single_Features(method(out_int, single_Formals(formal(arg, Int)),
										      SELF_TYPE, no_expr()))),
					       single_Features(method(in_string, nil_Formals(), Str, no_expr()))),
			       single_Features(method(in_int, nil_Formals(), Int, no_expr()))),
	       filename);  

    //
    // The Int class has no methods and only a single attribute, the
    // "val" for the integer. 
    //
    Class_ Int_class =
	class_(Int, 
	       Object,
	       single_Features(attr(val, prim_slot, no_expr())),
	       filename);

    //
    // Bool also has only the "val" slot.
    //
    Class_ Bool_class =
	class_(Bool, Object, single_Features(attr(val, prim_slot, no_expr())),filename);

    //
    // The class Str has a number of slots and operations:
    //       val                                  the length of the string
    //       str_field                            the string itself
    //       length() : Int                       returns length of the string
    //       concat(arg: Str) : Str               performs string concatenation
    //       substr(arg: Int, arg2: Int): Str     substring selection
    //       
    Class_ Str_class =
	class_(Str, 
	       Object,
	       append_Features(
			       append_Features(
					       append_Features(
							       append_Features(
									       single_Features(attr(val, Int, no_expr())),
									       single_Features(attr(str_field, prim_slot, no_expr()))),
							       single_Features(method(length, nil_Formals(), Int, no_expr()))),
					       single_Features(method(concat, 
								      single_Formals(formal(arg, Str)),
								      Str, 
								      no_expr()))),
			       single_Features(method(substr, 
						      append_Formals(single_Formals(formal(arg, Int)), 
								     single_Formals(formal(arg2, Int))),
						      Str, 
						      no_expr()))),
	       filename);
    
    //add basic classes to class map
    class_map[Object] = Object_class;
    class_map[IO] = IO_class;
    class_map[Int] = Int_class;
    class_map[Bool] = Bool_class;
    class_map[Str] = Str_class;

}

void ClassTable::create_class_map(Classes classes) {
    //TO DO: create class map from class name to class_


    for ( int i = classes->first(); classes->more(i); i = classes->next(i) ) {
        Class_ c = classes->nth(i);
        class_map[c->get_name()] = c;


        
    }
}

bool ClassTable::is_main_class_defined() {
    //TO DO: check if Main class is defined
    if (class_map.find(Main) == class_map.end()) {
        semant_error() << "Main class is not defined." << endl;
        return false;
    }
    return true;
}

//check if all classes hereda from an existing class
bool ClassTable::check_inheritance_exists() {
    
    //iterate over class map
    for (std::map<Symbol, Class_>::iterator it = class_map.begin(); it != class_map.end(); ++it) {
        Symbol parent_name = it->second->get_parent();
        //check if parent exists in class map
        if (parent_name != No_class && class_map.find(parent_name) == class_map.end()) {
            semant_error(it->second) << "Class " << it->first << " inherits from an undefined class " << parent_name << endl;
            return false;   
        }

    }
    cout << "All classes inherit from existing classes." << endl;
    return true;
}

bool ClassTable::build_inheritance_graph() {
    //TO DO: build inheritance graph using map and vector
    
    for (std::map<Symbol, Class_>::iterator it = class_map.begin(); it != class_map.end(); ++it) {
        Symbol class_name = it->first;
        Class_ c = it->second;
        Symbol parent_name = c->get_parent();

        if (parent_name == No_class) continue;

        inheritance_graph[parent_name].push_back(class_name);

        //cannot inherit from itself
        if (parent_name == class_name) {
            semant_error(c) << "Class " << class_name << " cannot inherit from itself." << endl;
            return false;
        }

        //cout << "Class " << class_name << " inherits from " << parent_name << endl;
    }

    return true;
}

bool ClassTable::isCyclicUtil(
      std::map<Symbol, std::vector<Symbol> >& adj,
      Symbol v,
      std::map<Symbol, bool>& visited,
      std::map<Symbol, bool>& recStack
) {
    if (recStack[v]) return true;
    if (visited[v]) return false;

    visited[v] = true;
    recStack[v] = true;

    // Usar C++98 iterador
    for (std::vector<Symbol>::iterator it = adj[v].begin(); it != adj[v].end(); ++it) {
        if (isCyclicUtil(adj, *it, visited, recStack)) {
            return true;
        }
    }

    recStack[v] = false;
    return false;
}

bool ClassTable::detect_cycles() {
    //get nuymber of classes
    int num_classes = class_map.size();
    //create visisted vector
    std::map<Symbol, bool> visited;
    std::map<Symbol, bool> recStack;
    //check for cycles in each component
    for (std::map<Symbol, Class_>::iterator it = class_map.begin(); it != class_map.end(); ++it) {
        Symbol class_name = it->first;
        if (!visited[class_name]) {
            if (isCyclicUtil(inheritance_graph, class_name, visited, recStack)) {
                semant_error(it->second) << "Inheritance cycle detected involving class " << class_name << endl;
                return true;
            }
        }
    }
    cout << "No cycles detected in inheritance graph." << endl;
    return false;
}

bool ClassTable::walk_ast_starting_with_classes() {
    //TO DO: walk the AST starting with class c
    //iterate over class map
    //cout << "Walking AST starting with classes..." << endl;
    for (std::map<Symbol, Class_>::iterator it = class_map.begin(); it != class_map.end(); ++it) {
        Class_ c = it->second;
        walk_ast_starting_with_class(c);

    }
    return true;
}

bool ClassTable::walk_formals(Formals formals) {
    //iterate over formals
    for ( int i = formals->first(); formals->more(i); i = formals->next(i) ) {
        Formal formal = formals->nth(i);
        //add formal to symbol table
        objects_table->addid(formal->get_name(), new Symbol(formal->get_type()));
    }
    return true;
}

bool ClassTable::walk_expression(Expression expr) {
    

    return true;
}


bool ClassTable::walk_method(Feature f) {
    method_class* method = dynamic_cast<method_class*>(f);
    
    //enter scope
    objects_table->enterscope();
    //add formals to symbol table
    Formals formals = method->get_formals();
    walk_formals(formals);
    //TO DO: process method body expression
    Expression body = method->get_body_expr();
    walk_expression(body);

    //exit scope
    objects_table->exitscope();


    return true;
    
}

bool ClassTable::walk_attr(Feature f) {

    attr_class* attr = dynamic_cast<attr_class*>(f);
    objects_table->addid(attr->get_name(), new Symbol(attr->get_type()));
    return true;
}

bool ClassTable::walk_ast_starting_with_class(Class_ c) {
    //enter scope
    objects_table = new SymbolTable<Symbol, Symbol>();

    objects_table->enterscope();
    //class has list of features 
    Features features = c->get_features();
    //iterate over features

    for ( int i = features->first(); features->more(i); i = features->next(i) ) {
        Feature f = features->nth(i);
        //add feature to class_featuers_map
        
        //if feature is attribute, add to symbol table
        if (f->is_attr()) {
            class_attrs_map[c->get_name()].push_back(f);
            walk_attr(f);
        } else if (f->is_method()) {
            class_methods_map[c->get_name()].push_back(f);
            walk_method(f);
        }

    
    }

    //exit scope
    objects_table->exitscope();
    return true;
}
////////////////////////////////////////////////////////////////////
//
// semant_error is an overloaded function for reporting errors
// during semantic analysis.  There are three versions:
//
//    ostream& ClassTable::semant_error()                
//
//    ostream& ClassTable::semant_error(Class_ c)
//       print line number and filename for `c'
//
//    ostream& ClassTable::semant_error(Symbol filename, tree_node *t)  
//       print a line number and filename
//
///////////////////////////////////////////////////////////////////

ostream& ClassTable::semant_error(Class_ c)
{                                                             
    return semant_error(c->get_filename(),c);
}    

ostream& ClassTable::semant_error(Symbol filename, tree_node *t)
{
    error_stream << filename << ":" << t->get_line_number() << ": ";
    return semant_error();
}

ostream& ClassTable::semant_error()                  
{                                                 
    semant_errors++;                            
    return error_stream;
} 



/*   This is the entry point to the semantic checker.

     Your checker should do the following two things:

     1) Check that the program is semantically correct
     2) Decorate the abstract syntax tree with type information
        by setting the `type' field in each Expression node.
        (see `tree.h')

     You are free to first do 1), make sure you catch all semantic
     errors. Part 2) can be done in a second stage, when you want
     to build mycoolc.
 */
void program_class::semant()
{
    initialize_constants();

    /* ClassTable constructor may do some semantic analysis */
    ClassTable *classtable = new ClassTable(classes);

    /* create class map*/
    classtable->create_class_map(classes);

    /* check if Main class is defined*/
    classtable->is_main_class_defined();

    /* check if inheritance exists*/
    classtable->check_inheritance_exists();

    /* create classes graph*/
    classtable->build_inheritance_graph();

    /* detect cycles*/
    classtable->detect_cycles();

    /* walk*/
    classtable->walk_ast_starting_with_classes();
    


    /* some semantic analysis code may go here */

    if (classtable->errors()) {
	cerr << "Compilation halted due to static semantic errors." << endl;
	exit(1);
    }
}


