// 00 -> AND, 01 -> OR, 10 -> NOR, 11 -> XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
    wire w1, w2, w3, w4;

    and a1(w1, A, B);
    or a2(w2, A, B);
    nor a3(w3, A, B);
    xor a4(w4, A, B);
    mux4 m1(out, w1, w2, w3, w4, control);
endmodule // logicunit
