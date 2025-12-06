class Main inherits IO {
    main() : Object {
        -- Este comentario tiene un tab dentro -> \t <- ¿debe ser warning?
        -- Depende de tu regla de estilo. Si solo detectas tabs en INITIAL,
        -- esto NO debe dar warning.

        out_string("Hola\tMundo\n"); -- tab dentro del string (NO debería contar)

        out_int(5);   -- tab prohibido real

        out_string("Linea\tcon\ttabs\n");  -- tabs válidos (string)
    };
};
