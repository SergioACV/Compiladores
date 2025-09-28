class Node {

    item: String;
    next: Node;

    init(i: String, n: Node): Node {

        {
            item<- i;
            next <- n;
            self;
        }

    };

    getNext(): Node {
        next
    };

    flatten(): String {
        if( isvoid next ) then
            item
        else
            item.concat(next.flatten())
        fi
    };

};

--Hola mundo \n

(*
  (*  *)
*)

class Main inherits IO {
  main(): Object  {
    
    let s: Stack <- (new Stack) in
        {

            s.push("A");
            s.push("B");
            s.push("C");
            out_string(s.tostring().concat("\n"));


            while ( not (s.getsize()= 0) ) loop
                {
                    out_string(s.tostring().concat("\n "));
                    s.pop();
                }
                    
            pool;
            s;

        }
    };
};