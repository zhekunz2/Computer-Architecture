// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// lui          (output) - the instruction is a lui
// slt          (output) - the instruction is an slt
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, lui, slt, addm;
    input  [5:0] opcode, funct;
    input        zero;

    wire my_add, my_sub, my_and, my_or, my_nor, my_xor, addi, andi, ori, xori, bne, beq, j, jr, lw, lbu, sw, sb;

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

    assign bne = (opcode == `OP_BNE);
    assign beq = (opcode == `OP_BEQ);
    assign j = (opcode == `OP_J);
    assign jr = (opcode == `OP_OTHER0) & (funct == `OP0_JR);
    assign lui = (opcode == `OP_LUI);
    assign slt = (opcode == `OP_OTHER0) & (funct == `OP0_SLT);
    assign lw = (opcode == `OP_LW);
    assign lbu = (opcode == `OP_LBU);
    assign sw = (opcode == `OP_SW);
    assign sb = (opcode == `OP_SB);
    assign addm = (opcode == `OP_OTHER0) & (funct == `OP0_ADDM);

    assign control_type[1] = (j|jr);
    assign control_type[0] = jr|(beq&zero)|(bne&~zero);
    assign mem_read = lw|lbu;
    assign byte_load = lbu;
    assign word_we = sw;
    assign byte_we = sb;
    assign writeenable = my_or|my_add|my_and|my_sub|my_nor|my_xor|addi|andi|ori|xori|lui|slt|lw|lbu|addm;
    assign rd_src = addi|xori|ori|andi|lui|lw|lbu;
    assign alu_src2 = addi|xori|ori|andi|lw|lbu|sw|sb;
    assign except = ~(writeenable|sw|sb|beq|bne|j|jr);
    assign alu_op[0] = my_sub|my_or|my_xor|ori|xori|bne|beq|slt;
    assign alu_op[1] = my_add|addi|my_sub|my_nor|my_xor|xori|bne|beq|slt|addm|sw|sb|lw|lbu;
    assign alu_op[2] = my_and|my_or|my_nor|my_xor|andi|ori|xori;

endmodule // mips_decode
