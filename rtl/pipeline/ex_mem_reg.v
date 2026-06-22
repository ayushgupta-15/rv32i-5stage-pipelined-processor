module ex_mem_reg (
    input wire clk,
    input wire reset,

    // Inputs from EX
    input wire [31:0] ex_alu_result,
    input wire [31:0] ex_rs2_data,
    input wire [4:0]  ex_rd,
    input wire [31:0] ex_pc_plus_4,

    // Control Signals from EX
    input wire        ex_reg_write,
    input wire        ex_mem_read,
    input wire        ex_mem_write,
    input wire        ex_mem_to_reg,
    input wire        ex_jump,

    // Outputs to MEM
    output reg [31:0] mem_alu_result,
    output reg [31:0] mem_rs2_data,
    output reg [4:0]  mem_rd,
    output reg [31:0] mem_pc_plus_4,

    // Control Signals to MEM
    output reg        mem_reg_write,
    output reg        mem_mem_read,
    output reg        mem_mem_write,
    output reg        mem_mem_to_reg,
    output reg        mem_jump
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_alu_result <= 0;
            mem_rs2_data <= 0;
            mem_rd <= 0;
            mem_pc_plus_4 <= 0;

            mem_reg_write <= 0;
            mem_mem_read <= 0;
            mem_mem_write <= 0;
            mem_mem_to_reg <= 0;
            mem_jump <= 0;
        end else begin
            mem_alu_result <= ex_alu_result;
            mem_rs2_data <= ex_rs2_data;
            mem_rd <= ex_rd;
            mem_pc_plus_4 <= ex_pc_plus_4;

            mem_reg_write <= ex_reg_write;
            mem_mem_read <= ex_mem_read;
            mem_mem_write <= ex_mem_write;
            mem_mem_to_reg <= ex_mem_to_reg;
            mem_jump <= ex_jump;
        end
    end

endmodule
