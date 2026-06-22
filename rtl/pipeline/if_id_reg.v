module if_id_reg (
    input wire clk,
    input wire reset,
    input wire write_enable,
    input wire flush,
    
    // Inputs from IF
    input wire [31:0] if_pc,
    input wire [31:0] if_instruction,
    
    // Outputs to ID
    output reg [31:0] id_pc,
    output reg [31:0] id_instruction
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            id_pc <= 32'd0;
            id_instruction <= 32'h00000013; // NOP (ADDI x0, x0, 0)
        end else if (flush) begin
            id_pc <= 32'd0;
            id_instruction <= 32'h00000013; // NOP
        end else if (write_enable) begin
            id_pc <= if_pc;
            id_instruction <= if_instruction;
        end
    end

endmodule
