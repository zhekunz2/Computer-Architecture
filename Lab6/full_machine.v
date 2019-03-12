// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;
    wire [31:0] PC;
    wire [31:0] next_PC;
    wire [31:0] rs_data;
    wire [31:0] rt_data, byte_load_out;
    wire [31:0] alu_out, data_out, lui_out, slt_out, branch_offset, branch_out, PC_Four;
    wire [31:0] B, addm_out;
    wire [31:0] imm, j_out, jr_out, mem_out, addr, addm_final, slt_in;
    wire [15:0] temp;
    wire [7:0] byte_out;
    wire [4:0] rdest;
    wire [2:0] alu_op;
    wire [1:0] control_type;
    wire writeenable, rd_src, alu_src2, except, overflow, zero, negative, pc_overflow, pc_zero, pc_negative, is_negative,
          mem_read, word_we, byte_we, byte_load, lui, slt, addm;


    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC[31:0], next_PC[31:0], clock, 1'b1, reset);
    alu32 a0(PC_Four[31:0], pc_overflow, pc_zero, pc_negative, PC[31:0], 32'h00000004, 3'b010);
    mips_decode decoder(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                       mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                       inst[31:26], inst[5:0], zero);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst[31:0], PC[31:2]);

    assign branch_offset = {imm[29:0],{2'b00}};//branch left_sift
    alu32 alu_branch(branch_out,,,,PC_Four,branch_offset,`ALU_ADD);

    // DO NOT comment out or rename this module
    // or the test bench will break
    mux2v #(5) m0 (rdest[4:0], inst[15:11], inst[20:16], rd_src);
    regfile rf (rs_data[31:0], rt_data[31:0], inst[25:21], inst[20:16], rdest, lui_out[31:0], writeenable, clock, reset);
    alu32 a1(alu_out[31:0], overflow, zero, negative, rs_data[31:0], B[31:0], alu_op[2:0]);

    /* add other modules */
    assign temp[15:0] = {16{inst[15]}};
    assign imm[31:0] = {temp, inst[15:0]};
    mux2v m1 (B[31:0], rt_data[31:0], imm[31:0], alu_src2);

    mux2v #(1) helper_slt(is_negative,negative,~negative,(slt&&overflow));
    assign slt_in = {{31{1'b0}},is_negative};
    mux2v m_slt (slt_out, alu_out, slt_in, slt);

    data_mem data_mem(data_out, addr, rt_data, word_we, byte_we, clock, reset);
    mux4v #(8) m_choose_byte(byte_out,data_out[7:0],data_out[15:8],data_out[23:16],data_out[31:24],alu_out[1:0]);
    mux2v m_byte_load(byte_load_out, data_out, {{24{1'b0}},byte_out}, byte_load);
    mux2v m_mem_read(mem_out, slt_out, byte_load_out, mem_read);
    mux2v m_lui(lui_out, addm_final, {inst[15:0],{16{1'b0}}}, lui);
    assign j_out = {PC[31:28],inst[27:0],{2'b00}};
    assign jr_out = rs_data;

    alu32 alu_addm(addm_out,,,,mem_out,rt_data,`ALU_ADD);
    mux2v m_addm(addr,alu_out,rs_data,addm);
    mux2v m_addMfianl(addm_final,mem_out,addm_out,addm);

    mux4v m_control_type(next_PC,PC_Four,branch_out,j_out,jr_out,control_type);//control_type

    /* add other modules */

endmodule // full_machine
