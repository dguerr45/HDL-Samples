`timescale 1ns / 1ps


module mips_32(
    input clk, reset,  
    output[31:0] result
    );
    
// define all the wires here. You need to define more wires than the ones you did in Lab2
    wire [9:0] branch_address;
    wire [9:0] jump_address;
    wire [9:0] pc_plus4;
    wire [31:0] instr;
    wire [9:0] if_id_pc_plus4;
    wire [9:0] id_ex_pc_plus4;
    wire [31:0] if_id_instr_mem;
    wire [4:0] if_id_rs, if_id_rt;
    wire [31:0] sign_extend_out;
    wire reg_dst, mem_to_reg, id_ex_mem_to_reg;
    wire ex_mem_mem_to_reg, mem_wb_mem_to_reg;
    wire [1:0] alu_op;
    wire mem_read, mem_write, alu_src, reg_write, branch_taken, jump;
    wire [31:0] write_back_data;
    wire data_hazard, IF_Flush;
    wire [31:0] reg_read_data1, reg_read_data2;
    wire [31:0] id_ex_sign_extend;
    wire [31:0] id_ex_reg_data1, id_ex_reg_data2;
    wire id_ex_alu_src;
    wire [1:0] id_ex_alu_op;
    wire [31:0] id_ex_instr_mem;
    wire id_ex_mem_read;
    wire id_ex_reg_write;
    wire [31:0] write_back_result;
    wire [1:0] forward_a, forward_b;
    wire [31:0] alu_result;
    wire [31:0] ex_mem_alu_result;
    wire [31:0] alu_in2_out;
    wire [31:0] ex_mem_instr_mem;
    wire [31:0] mem_read_data;
    wire [31:0] writeback_mux_output;
    wire alu_zero;
    wire [4:0] destination_reg, id_ex_destination_reg;
    wire [4:0] ex_mem_destination_reg, mem_wb_destination_reg;
    wire [31:0] ex_mem_alu_in2_out;
    wire [31:0] mem_wb_alu_result, mem_wb_mem_read_data;


// Build the pipeline as indicated in the lab manual

///////////////////////////// Instruction Fetch    
    //IF pipe stage
    IF_pipe_stage IF_pipe_stage
    (   .clk(clk),
        .reset(reset),
        .en(data_hazard),
        .branch_address(branch_address),
        .jump_address(jump_address),
        .branch_taken(branch_taken),
        .jump(jump),
        .pc_plus4(pc_plus4),
        .instr(instr)
        );
    
///////////////////////////// IF/ID registers
    //address register: holds "pc_plus4"
    pipe_reg_en #(.WIDTH(10)) if_id_address_register
    (   .clk(clk),
        .reset(reset),
        .en(data_hazard),
        .flush(IF_Flush),
        .d(pc_plus4),
        .q(if_id_pc_plus4)
        );
    
    //instruction fetch register: holds "instr"
    pipe_reg_en #(.WIDTH(32)) if_id_instr_mem_register
    (   .clk(clk),
        .reset(reset),
        .en(data_hazard),
        .flush(IF_Flush),
        .d(instr),
        .q(if_id_instr_mem)
        );

///////////////////////////// Instruction Decode 
	//ID pipe stage
	ID_pipe_stage ID_pipe_stage
	(  .clk(clk),
	   .reset(reset),
	   .pc_plus4(if_id_pc_plus4),
	   .instr(if_id_instr_mem),
	   .mem_wb_reg_write(mem_wb_reg_write),
	   .mem_wb_write_reg_addr(mem_wb_destination_reg),
	   .mem_wb_write_back_data(write_back_data),
	   .Data_Hazard(data_hazard),
	   .Control_Hazard(IF_Flush),
	   .reg1(reg_read_data1),
	   .reg2(reg_read_data2),
	   .imm_value(sign_extend_out),
	   .branch_address(branch_address),
	   .jump_address(jump_address),
	   .branch_taken(branch_taken),
	   .destination_reg(destination_reg),
	   .mem_to_reg(mem_to_reg),
	   .alu_op(alu_op),
	   .mem_read(mem_read),
	   .mem_write(mem_write),
	   .alu_src(alu_src),
	   .reg_write(reg_write),
	   .jump(jump)
	   );
             
///////////////////////////// ID/EX registers 
    //instruction memory register: holds "id_ex_instr_mem"
    pipe_reg #(.WIDTH(32)) id_ex_instr_mem_register
    (   .clk(clk),
        .reset(reset),
        .d(if_id_instr_mem),
        .q(id_ex_instr_mem)
        );
        
    //sign extend register: holds "sign extend"
    pipe_reg #(.WIDTH(32)) id_ex_sign_extend_register
    (   .clk(clk),
        .reset(reset),
        .d(sign_extend_out),
        .q(id_ex_sign_extend)
        );
        
    //register data 1 register: holds "reg_read_data1"
    pipe_reg #(.WIDTH(32)) id_ex_reg_data1_register
    (   .clk(clk),
        .reset(reset),
        .d(reg_read_data1),
        .q(id_ex_reg_data1)
        );
    
    //regsiter data 2 register: holds "reg_read_data2"
    pipe_reg #(.WIDTH(32)) id_ex_reg_data2_register
    (   .clk(clk),
        .reset(reset),
        .d(reg_read_data2),
        .q(id_ex_reg_data2)
        );
        
    //alu source register: holds "alu_src"
    pipe_reg #(.WIDTH(1)) id_ex_alu_src_register
    (   .clk(clk),
        .reset(reset),
        .d(alu_src),
        .q(id_ex_alu_src)
        );
        
    //alu op code register: holds "alu_op"
    pipe_reg #(.WIDTH(2)) id_ex_alu_op_register
    (   .clk(clk),
        .reset(reset),
        .d(alu_op),
        .q(id_ex_alu_op)
        );
        
    //memory read register: holds "mem_read"
    pipe_reg #(.WIDTH(1)) id_ex_mem_read_register
    (   .clk(clk),
        .reset(reset),
        .d(mem_read),
        .q(id_ex_mem_read)
        );
        
    //register write register: holds "reg_write"
    pipe_reg #(.WIDTH(1)) id_ex_reg_write_register
    (   .clk(clk),
        .reset(reset),
        .d(reg_write),
        .q(id_ex_reg_write)
        );
        
    //memory write register: holds "mem_write"
    pipe_reg #(.WIDTH(1)) id_ex_mem_write_register
    (   .clk(clk),
        .reset(reset),
        .d(mem_write),
        .q(id_ex_mem_write)
        );
        
    //memory to reg register: holds "mem_to_reg"
    pipe_reg #(.WIDTH(1)) id_ex_mem_to_reg_register
    (   .clk(clk),
        .reset(reset),
        .d(mem_to_reg),
        .q(id_ex_mem_to_reg)
        );
        
    //destination reg register: holds "destination_reg"
    pipe_reg #(.WIDTH(5)) id_ex_destination_reg_register
    (   .clk(clk),
        .reset(reset),
        .d(destination_reg),
        .q(id_ex_destination_reg)
        );
        

///////////////////////////// Hazard_detection unit
	//hazard detection unit
	Hazard_detection hazard_detection
	(  .id_ex_mem_read(id_ex_mem_read),
	   .id_ex_destination_reg(id_ex_destination_reg),
	   .if_id_rs(if_id_instr_mem[25:21]),
	   .if_id_rt(if_id_instr_mem[20:16]),
	   .branch_taken(branch_taken),
	   .jump(jump),
	   .Data_Hazard(data_hazard),
	   .IF_Flush(IF_Flush)
	); 
           
///////////////////////////// Execution    
	//EX pipe stage
	EX_pipe_stage EX_pipe_stage
	(  .id_ex_instr(id_ex_instr_mem),
	   .reg1(id_ex_reg_data1),
	   .reg2(id_ex_reg_data2),
	   .id_ex_imm_value(id_ex_sign_extend),
	   .ex_mem_alu_result(ex_mem_alu_result),
	   .mem_wb_write_back_result(write_back_data),
	   .id_ex_alu_src(id_ex_alu_src),
	   .id_ex_alu_op(id_ex_alu_op),
	   .Forward_A(forward_a),
	   .Forward_B(forward_b),
	   .alu_in2_out(alu_in2_out),
	   .alu_result(alu_result)
	);
        
///////////////////////////// Forwarding unit
	//forwarding unit
	EX_Forwarding_unit EX_Forwarding_unit
	(  .ex_mem_reg_write(ex_mem_reg_write),
	   .ex_mem_write_reg_addr(ex_mem_destination_reg),
	   .id_ex_instr_rs(id_ex_instr_mem[25:21]),
	   .id_ex_instr_rt(id_ex_instr_mem[20:16]),
	   .mem_wb_reg_write(mem_wb_reg_write),
	   .mem_wb_write_reg_addr(mem_wb_destination_reg),
	   .Forward_A(forward_a),
	   .Forward_B(forward_b)
	);

     
///////////////////////////// EX/MEM registers
	//instruction memory register: holds "id_ex_instr_mem"
	pipe_reg #(.WIDTH(32)) ex_mem_instr_mem_register
    (   .clk(clk),
        .reset(reset),
        .d(id_ex_instr_mem),
        .q(ex_mem_instr_mem)
        );
        
    //memory write register: holds "mem_write"
    pipe_reg #(.WIDTH(1)) ex_mem_mem_write_register
    (   .clk(clk),
        .reset(reset),
        .d(id_ex_mem_write),
        .q(ex_mem_mem_write)
        );

    //memory read register: holds "mem_read"
    pipe_reg #(.WIDTH(1)) ex_mem_mem_read_register
    (   .clk(clk),
        .reset(reset),
        .d(id_ex_mem_read),
        .q(ex_mem_mem_read)
        );
        
    //memory to reg register: holds "mem_to_reg"
    pipe_reg #(.WIDTH(1)) ex_mem_mem_to_reg_register
    (   .clk(clk),
        .reset(reset),
        .d(id_ex_mem_to_reg),
        .q(ex_mem_mem_to_reg)
        );
        
    //reg write register: holds "reg_write"
    pipe_reg #(.WIDTH(1)) ex_mem_reg_write_register
    (   .clk(clk),
        .reset(reset),
        .d(id_ex_reg_write),
        .q(ex_mem_reg_write)
        );
        
    //destination reg register: holds "destination_reg"
    pipe_reg #(.WIDTH(5)) ex_mem_destination_reg_register
    (   .clk(clk),
        .reset(reset),
        .d(id_ex_destination_reg),
        .q(ex_mem_destination_reg)
        );
        
    //destination reg register: holds "alu_result"
    pipe_reg #(.WIDTH(32)) ex_mem_alu_result_register
    (   .clk(clk),
        .reset(reset),
        .d(alu_result),
        .q(ex_mem_alu_result)
        );
        
    //destination reg register: holds "alu_in2_out"
    pipe_reg #(.WIDTH(32)) ex_mem_alu_in2_out_register
    (   .clk(clk),
        .reset(reset),
        .d(alu_in2_out),
        .q(ex_mem_alu_in2_out)
        );
    
///////////////////////////// memory    
	//memory pipe stage
	data_memory data_memory
	(  .clk(clk),
	   .mem_access_addr(ex_mem_alu_result),
	   .mem_write_data(ex_mem_alu_in2_out),
	   .mem_write_en(ex_mem_mem_write),
	   .mem_read_en(ex_mem_mem_read),
	   .mem_read_data(mem_read_data)
	);
     

///////////////////////////// MEM/WB registers  
	//memory to reg register: holds "mem_to_reg"
	pipe_reg #(.WIDTH(1)) mem_wb_mem_to_reg_register
    (   .clk(clk),
        .reset(reset),
        .d(ex_mem_mem_to_reg),
        .q(mem_wb_mem_to_reg)
        );
    
    //memory data register: holds "mem_read_data"
	pipe_reg #(.WIDTH(1)) mem_wb_mem_read_data_register
    (   .clk(clk),
        .reset(reset),
        .d(mem_read_data),
        .q(mem_wb_mem_read_data)
        );
        
    //alu result register: holds "alu_result"
	pipe_reg #(.WIDTH(32)) mem_wb_alu_result_register
    (   .clk(clk),
        .reset(reset),
        .d(ex_mem_alu_result),
        .q(mem_wb_alu_result)
        );
        
    //reg write register: holds "reg_write"
	pipe_reg #(.WIDTH(1)) mem_wb_reg_write_register
    (   .clk(clk),
        .reset(reset),
        .d(ex_mem_reg_write),
        .q(mem_wb_reg_write)
        );
    
    //destination reg register: holds "destination_reg"
	pipe_reg #(.WIDTH(5)) mem_wb_destination_reg_register
    (   .clk(clk),
        .reset(reset),
        .d(ex_mem_destination_reg),
        .q(mem_wb_destination_reg)
        );

///////////////////////////// writeback    
	//writeback pipe stage
	mux2 #(.mux_width(32)) writeback_mux
	(  .a(mem_wb_alu_result),
	   .b(mem_wb_mem_read_data),
	   .sel(mem_wb_mem_to_reg),
	   .y(write_back_data)
	);
    
    assign result = write_back_data;
    
endmodule
