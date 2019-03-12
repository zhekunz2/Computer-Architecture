module alu1_test;
    // exhaustively test your 1-bit ALU implementation by adapting mux4_tb.v
    reg A = 0;
    always #1 A = !A;
    reg B = 0;
    always #2 B = !B;
    reg C = 0;
    always #4 C = !C;

    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu1.vcd");
        $dumpvars(0, alu1_test);

        # 16 control = 3'h1;
        # 16 control = 3'h2;
        # 16 control = 3'h3;
        # 16 control = 3'h4;
        # 16 control = 3'h5;
        # 16 control = 3'h6;
        # 16 control = 3'h7;
        # 16 $finish;
    end

    wire out;
    alu1 al1(out, carryout, A, B, C, control);

    /*initial begin
        #display("A B C control out");
        $monitor("%d %d %d %d %d (at time %t)", A, B, C, control, carryout, $time);
    */
endmodule
