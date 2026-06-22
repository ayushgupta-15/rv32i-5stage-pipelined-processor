module imm_gen (
    input  wire [31:0] instruction,
    input  wire [2:0]  imm_sel,
    output reg  [31:0] imm_out
);

    always @(*) begin
        case (imm_sel)
            3'b000: // I-Type
                imm_out = { {20{instruction[31]}}, instruction[31:20] };
            
            3'b001: // S-Type
                imm_out = { {20{instruction[31]}}, instruction[31:25], instruction[11:7] };
            
            3'b010: // B-Type
                imm_out = { {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0 };
            
            3'b011: // U-Type
                imm_out = { instruction[31:12], 12'b0 };
            
            3'b100: // J-Type
                imm_out = { {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0 };
                
            default: 
                imm_out = 32'd0;
        endcase
    end

endmodule
