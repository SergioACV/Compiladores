class C {
  nestedMethod() : Int {
    {
      let x : Int <- 1 in x;
      {
        let y : Int <- 2 in y;
        let z : Int <- 3 in z;
      };
      x + 1;
    };
  };
};
