//implement a test bench for your 32-bit ALU
module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

             A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
        # 10 A = 2; B = 5; control = `ALU_SUB; // try subtracting 5 from 2
        // add more test cases here!
        # 10 A = 36; B = 32'h7ffffff0; control = `ALU_SUB;  //
        # 10 A = 15; B = 1144; control = `ALU_AND; // 15 & 1144 == 8
        # 10 A = 110909211; B = 239000238; control = `ALU_OR; // 247390143
        # 10 A = 123; B = 551; control = `ALU_XOR; // 604
        # 10 A = 891; B = 114; control = `ALU_NOR; // -892
        # 10 A = 32'b00001111; B = 32'b11110000; control = `ALU_AND;  //0
        //$display("overflow cases:\n");
        # 10 A = 2147483647; B = 4294967295; control = `ALU_ADD;// no overflow
        # 10 A = 2147483647; B = 2; control = `ALU_ADD; // overflow
        # 10 A = 4294967295; B = 2147483648; control = `ALU_ADD; // overflow
        # 10 A = 2147483647; B = 4294967295; control = `ALU_SUB; // overflow

        # 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);

    initial begin
        $monitor("A:%-4d\tB:%-4d\tCtrl:%-4d\tout:%-4d\noverflow:%-4d\tzero:%-4d\tneg:%-4d : at time %t\n", A, B, control, out, overflow, zero, negative, $time);
    end

endmodule // alu32_test
