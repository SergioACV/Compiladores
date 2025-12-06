class C {
  good() : String { "Esta línea está bien." };

  bad() : String { "Pero esta línea sí que va a ser extremadamente larga porque la estamos haciendo deliberadamente más extensa que cien caracteres para provocar un error." };

  also_good() : Int { 42 };
};
