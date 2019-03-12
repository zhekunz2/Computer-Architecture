// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;
    wire [31:0] PC;
    wire [31:0] next_PC;
    wire [31:0] rs_data;
    wire [31:0] rt_data;
    wire [31:0] rd_data;
    wire [31:0] B;
    wire [31:0] imm;
    wire [15:0] temp;
    wire [4:0] rdest;
    wire [2:0] alu_op;
    wire writeenable, rd_src, alu_src2, except, overflow, zero, negative, pc_overflow, pc_zero, pc_negative;


    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC[31:0], next_PC[31:0], clock, 1'b1, reset);
    alu32 a0(next_PC[31:0], pc_overflow, pc_zero, pc_negative, PC[31:0], 32'h00000004, 3'b010);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst[31:0], PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    mux2v #(5) m0 (rdest[4:0], inst[15:11], inst[20:16], rd_src);
    regfile rf (rs_data[31:0], rt_data[31:0], inst[25:21], inst[20:16], rdest, rd_data[31:0], writeenable, clock, reset);

    /* add other modules */
    assign temp[15:0] = {16{inst[15]}};
    assign imm[31:0] = {temp, inst[15:0]};
    mux2v m1 (B[31:0], rt_data[31:0], imm[31:0], alu_src2);

    mips_decode decoder(alu_op[2:0], writeenable, rd_src, alu_src2, except, inst[31:26], inst[5:0]);
    alu32 a1(rd_data[31:0], overflow, zero, negative, rs_data[31:0], B[31:0], alu_op[2:0]);
endmodule // arith_machine
