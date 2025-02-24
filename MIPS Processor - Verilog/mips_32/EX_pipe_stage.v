`timescale 1ns / 1ps

module EX_pipe_stage(
    input [31:0] id_ex_instr,
    input [31:0] reg1, reg2,
    input [31:0] id_ex_imm_value,
    input [31:0] ex_mem_alu_result,
    input [31:0] mem_wb_write_back_result,
    input id_ex_alu_src,
    input [1:0] id_ex_alu_op,
    input [1:0] Forward_A, Forward_B,
    output [31:0] alu_in2_out,
    output [31:0] alu_result
    );
    
    wire [3:0] alu_control_signal;
    wire [31:0] register1_mux_output;
    wire [31:0] alu_input2_mux_output;
    
    //determining ALU_Control signals
    ALUControl alu_control
    (   .ALUOp(id_ex_alu_op),
        .Function(id_ex_instr[5:0]),
        .ALU_Control(alu_control_signal)
    );
    
    //mux before ALU
    mux4 #(.mux_width(32)) id_ex_reg1_mux
	(  .a(reg1),
	   .b(mem_wb_write_back_result),
	   .c(ex_mem_alu_result),
	   .d(32'b0),
	   .sel(Forward_A),
	   .y(register1_mux_output)
	);
	
	mux4 #(.mux_width(32)) id_ex_reg2_mux
	(  .a(reg2),
	   .b(mem_wb_write_back_result),
	   .c(ex_mem_alu_result),
	   .d(32'b0),
	   .sel(Forward_B),
	   .y(alu_in2_out)
	);
	
	mux2 #(.mux_width(32)) alu_input2_mux
	(  .a(alu_in2_out),
	   .b(id_ex_imm_value),
	   .sel(id_ex_alu_src),
	   .y(alu_input2_mux_output)
	);
	
	ALU alu
	(   .a(register1_mux_output),  
        .b(alu_input2_mux_output), 
        .alu_control(alu_control_signal),
        .alu_result(alu_result) 
    );
    
endmodule
