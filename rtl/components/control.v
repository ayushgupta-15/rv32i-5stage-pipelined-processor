module control (
    input  wire [6:0] opcode,
    output reg        reg_write,
    output reg        alu_src,
    output reg        mem_read,
    output reg        mem_write,
    output reg        mem_to_reg,
    output reg        branch,
    output reg        jump,
    output reg  [1:0] alu_op,
    output reg  [2:0] imm_sel
);

    always @(*) begin
        // Default values to prevent latches
        reg_write  = 0;
        alu_src    = 0;
        mem_read   = 0;
        mem_write  = 0;
        mem_to_reg = 0;
        branch     = 0;
        jump       = 0;
        alu_op     = 2'b00;
        imm_sel    = 3'b000;

        case (opcode)
            7'b0110011: begin // R-Type
                reg_write = 1;
                alu_op    = 2'b10;
            end
            7'b0010011: begin // I-Type (ADDI)
                reg_write = 1;
                alu_src   = 1;
                alu_op    = 2'b10;
                imm_sel   = 3'b000;
            end
            7'b0000011: begin // LW
                reg_write  = 1;
                alu_src    = 1;
                mem_read   = 1;
                mem_to_reg = 1;
                alu_op     = 2'b00;
                imm_sel    = 3'b000;
            end
            7'b0100011: begin // SW
                alu_src   = 1;
                mem_write = 1;
                alu_op    = 2'b00;
                imm_sel   = 3'b001;
            end
            7'b1100011: begin // Branch (BEQ/BNE)
                branch  = 1;
                alu_op  = 2'b01;
                imm_sel = 3'b010;
            end
            7'b1101111: begin // JAL
                reg_write = 1;
                jump      = 1;
                imm_sel   = 3'b100;
            end
            7'b0110111: begin // LUI
                reg_write = 1;
                alu_src   = 1;
                imm_sel   = 3'b011;
            end
            default: begin
                // Maintain defaults for unrecognized opcodes
            end
        endcase
    end
endmodule
