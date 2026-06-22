module mem_wb_reg (
    input wire clk,
    input wire reset,

    // Inputs from MEM
    input wire [31:0] mem_read_data,
    input wire [31:0] mem_alu_result,
    input wire [4:0]  mem_rd,
    input wire [31:0] mem_pc_plus_4,

    // Control Signals from MEM
    input wire        mem_reg_write,
    input wire        mem_mem_to_reg,
    input wire        mem_jump,

    // Outputs to WB
    output reg [31:0] wb_read_data,
    output reg [31:0] wb_alu_result,
    output reg [4:0]  wb_rd_out,
    output reg [31:0] wb_pc_plus_4,

    // Control Signals to WB
    output reg        wb_reg_write_out,
    output reg        wb_mem_to_reg_out,
    output reg        wb_jump_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wb_read_data <= 0;
            wb_alu_result <= 0;
            wb_rd_out <= 0;
            wb_pc_plus_4 <= 0;

            wb_reg_write_out <= 0;
            wb_mem_to_reg_out <= 0;
            wb_jump_out <= 0;
        end else begin
            wb_read_data <= mem_read_data;
            wb_alu_result <= mem_alu_result;
            wb_rd_out <= mem_rd;
            wb_pc_plus_4 <= mem_pc_plus_4;

            wb_reg_write_out <= mem_reg_write;
            wb_mem_to_reg_out <= mem_mem_to_reg;
            wb_jump_out <= mem_jump;
        end
    end

endmodule
