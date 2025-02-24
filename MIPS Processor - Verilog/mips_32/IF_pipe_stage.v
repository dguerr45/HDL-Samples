`timescale 1ns / 1ps


module IF_pipe_stage(
    input clk, reset,
    input en,
    input [9:0] branch_address,
    input [9:0] jump_address,
    input branch_taken,
    input jump,
    output [9:0] pc_plus4,
    output [31:0] instr
    );
    
    reg [9:0] pc;
    wire [9:0] pc_mux1_output, pc_mux2_output;
    
// write your code here
    //pc counter on clock high
    always @(posedge clk or posedge reset)  
    begin   
        if(reset)   
            pc <= 10'b0000000000;  
        else if(en)
            pc <= pc_mux2_output;
    end
    
    //pc + 4 component
    assign pc_plus4 = pc + 10'b0000000100;
    
    //deciding next_pc
    mux2 #(.mux_width(10)) pc_mux1
    (   .a(pc_plus4),
        .b(branch_address),
        .sel(branch_taken),
        .y(pc_mux1_output)
        );
    
    mux2 #(.mux_width(10)) pc_mux2
    (   .a(pc_mux1_output),
        .b(jump_address),
        .sel(jump),
        .y(pc_mux2_output)
        );
    
    //Instruction Memory
    instruction_mem inst_mem
    (   .read_addr(pc),
        .data(instr)
        );
           
endmodule