module id_ex_reg (
    input wire clk,
    input wire reset,

    // Inputs from ID
    input wire [31:0] id_pc,
    input wire [31:0] id_rs1_data,
    input wire [31:0] id_rs2_data,
    input wire [31:0] id_imm_out,
    input wire [4:0]  id_rs1,
    input wire [4:0]  id_rs2,
    input wire [4:0]  id_rd,
    input wire [2:0]  id_funct3,
    input wire        id_funct7_b5,

    // Control Signals from ID
    input wire        id_reg_write,
    input wire        id_alu_src,
    input wire        id_mem_read,
    input wire        id_mem_write,
    input wire        id_mem_to_reg,
    input wire        id_branch,
    input wire        id_jump,
    input wire [1:0]  id_alu_op,

    // Outputs to EX
    output reg [31:0] ex_pc,
    output reg [31:0] ex_rs1_data,
    output reg [31:0] ex_rs2_data,
    output reg [31:0] ex_imm_out,
    output reg [4:0]  ex_rs1,
    output reg [4:0]  ex_rs2,
    output reg [4:0]  ex_rd,
    output reg [2:0]  ex_funct3,
    output reg        ex_funct7_b5,

    // Control Signals to EX
    output reg        ex_reg_write,
    output reg        ex_alu_src,
    output reg        ex_mem_read,
    output reg        ex_mem_write,
    output reg        ex_mem_to_reg,
    output reg        ex_branch,
    output reg        ex_jump,
    output reg [1:0]  ex_alu_op
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ex_pc <= 0;
            ex_rs1_data <= 0;
            ex_rs2_data <= 0;
            ex_imm_out <= 0;
            ex_rs1 <= 0;
            ex_rs2 <= 0;
            ex_rd <= 0;
            ex_funct3 <= 0;
            ex_funct7_b5 <= 0;

            ex_reg_write <= 0;
            ex_alu_src <= 0;
            ex_mem_read <= 0;
            ex_mem_write <= 0;
            ex_mem_to_reg <= 0;
            ex_branch <= 0;
            ex_jump <= 0;
            ex_alu_op <= 0;
        end else begin
            ex_pc <= id_pc;
            ex_rs1_data <= id_rs1_data;
            ex_rs2_data <= id_rs2_data;
            ex_imm_out <= id_imm_out;
            ex_rs1 <= id_rs1;
            ex_rs2 <= id_rs2;
            ex_rd <= id_rd;
            ex_funct3 <= id_funct3;
            ex_funct7_b5 <= id_funct7_b5;

            ex_reg_write <= id_reg_write;
            ex_alu_src <= id_alu_src;
            ex_mem_read <= id_mem_read;
            ex_mem_write <= id_mem_write;
            ex_mem_to_reg <= id_mem_to_reg;
            ex_branch <= id_branch;
            ex_jump <= id_jump;
            ex_alu_op <= id_alu_op;
        end
    end

endmodule
