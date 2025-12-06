class A {
    foo(x : Int) : Int {
        let y : Int <- 5 in {
            y <- y + x;
            y;
        };
    };
};

class Main inherits IO {
    main() : Object {
        out_int((new A).foo(10));
    };
};
