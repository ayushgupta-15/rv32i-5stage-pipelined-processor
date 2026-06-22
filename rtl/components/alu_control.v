module alu_control (
    input  wire [1:0] alu_op,
    input  wire [2:0] funct3,
    input  wire       funct7_b5,
    output reg  [3:0] alu_control_out
);

    always @(*) begin
        case (alu_op)
            2'b00: alu_control_out = 4'b0010; // ADD (for LW/SW)
            2'b01: alu_control_out = 4'b0011; // SUB (for Branch)
            2'b10: begin
                case (funct3)
                    3'b000: begin
                        if (funct7_b5) alu_control_out = 4'b0011; // SUB
                        else           alu_control_out = 4'b0010; // ADD
                    end
                    3'b111: alu_control_out = 4'b0000; // AND
                    3'b110: alu_control_out = 4'b0001; // OR
                    3'b100: alu_control_out = 4'b0100; // XOR
                    3'b010: alu_control_out = 4'b0101; // SLT
                    3'b011: alu_control_out = 4'b0110; // SLTU
                    default: alu_control_out = 4'b0000; // Default
                endcase
            end
            default: alu_control_out = 4'b0000;
        endcase
    end

endmodule
