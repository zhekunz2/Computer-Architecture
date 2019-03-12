// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, opcode, funct);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    input  [5:0] opcode, funct;

    wire my_add, my_sub, my_and, my_or, my_nor, my_xor, addi, andi, ori, xori;

    assign my_add = ((opcode == `OP_OTHER0) & (funct == `OP0_ADD));
    assign my_sub = ((opcode == `OP_OTHER0) & (funct == `OP0_SUB));
    assign my_and = ((opcode == `OP_OTHER0) & (funct == `OP0_AND));
    assign my_or  = ((opcode == `OP_OTHER0) & (funct == `OP0_OR));
    assign my_nor = ((opcode == `OP_OTHER0) & (funct == `OP0_NOR));
    assign my_xor = ((opcode == `OP_OTHER0) & (funct == `OP0_XOR));
    assign addi = (opcode == `OP_ADDI);
    assign andi = (opcode == `OP_ANDI);
    assign ori  = (opcode == `OP_ORI);
    assign xori = (opcode == `OP_XORI);

    assign writeenable = my_or|my_add|my_and|my_sub|my_nor|my_xor|addi|andi|ori|xori;
    assign rd_src = addi|xori|ori|andi;
    assign alu_src2 = rd_src;
    assign except = ~writeenable;
    assign alu_op[0] = my_sub|my_or|my_xor|ori|xori;
    assign alu_op[1] = my_add|addi|my_sub|my_nor|my_xor|xori;
    assign alu_op[2] = my_and|my_or|my_nor|my_xor|andi|ori|xori;
endmodule // mips_decode
