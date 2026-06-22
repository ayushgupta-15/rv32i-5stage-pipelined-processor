`timescale 1ns / 1ps

module alu_control_tb;

    reg [1:0] alu_op;
    reg [2:0] funct3;
    reg       funct7_b5;
    wire [3:0] alu_control_out;

    integer errors;

    alu_control uut (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7_b5(funct7_b5),
        .alu_control_out(alu_control_out)
    );

    initial begin
        errors = 0;
        
        $display("Starting ALU Control Tests...");
        
        // ALUOp = 00 (LW/SW) -> ADD (0010)
        alu_op = 2'b00; funct3 = 3'b000; funct7_b5 = 0; #10;
        if (alu_control_out !== 4'b0010) begin $display("FAIL: ALUOp 00"); errors = errors + 1; end
        else $display("PASS: ALUOp 00 (LW/SW -> ADD)");

        // ALUOp = 01 (Branch) -> SUB (0011)
        alu_op = 2'b01; funct3 = 3'b000; funct7_b5 = 0; #10;
        if (alu_control_out !== 4'b0011) begin $display("FAIL: ALUOp 01"); errors = errors + 1; end
        else $display("PASS: ALUOp 01 (Branch -> SUB)");

        // ALUOp = 10, funct3 = 000, funct7_b5 = 0 -> ADD (0010)
        alu_op = 2'b10; funct3 = 3'b000; funct7_b5 = 0; #10;
        if (alu_control_out !== 4'b0010) begin $display("FAIL: ALUOp 10, ADD"); errors = errors + 1; end
        else $display("PASS: ALUOp 10, f3=000, f7=0 (ADD)");

        // ALUOp = 10, funct3 = 000, funct7_b5 = 1 -> SUB (0011)
        alu_op = 2'b10; funct3 = 3'b000; funct7_b5 = 1; #10;
        if (alu_control_out !== 4'b0011) begin $display("FAIL: ALUOp 10, SUB"); errors = errors + 1; end
        else $display("PASS: ALUOp 10, f3=000, f7=1 (SUB)");

        // ALUOp = 10, funct3 = 111 -> AND (0000)
        alu_op = 2'b10; funct3 = 3'b111; funct7_b5 = 0; #10;
        if (alu_control_out !== 4'b0000) begin $display("FAIL: ALUOp 10, AND"); errors = errors + 1; end
        else $display("PASS: ALUOp 10, f3=111 (AND)");

        // ALUOp = 10, funct3 = 110 -> OR (0001)
        alu_op = 2'b10; funct3 = 3'b110; funct7_b5 = 1; #10;
        if (alu_control_out !== 4'b0001) begin $display("FAIL: ALUOp 10, OR"); errors = errors + 1; end
        else $display("PASS: ALUOp 10, f3=110 (OR)");

        // ALUOp = 10, funct3 = 100 -> XOR (0100)
        alu_op = 2'b10; funct3 = 3'b100; funct7_b5 = 0; #10;
        if (alu_control_out !== 4'b0100) begin $display("FAIL: ALUOp 10, XOR"); errors = errors + 1; end
        else $display("PASS: ALUOp 10, f3=100 (XOR)");

        // ALUOp = 10, funct3 = 010 -> SLT (0101)
        alu_op = 2'b10; funct3 = 3'b010; funct7_b5 = 0; #10;
        if (alu_control_out !== 4'b0101) begin $display("FAIL: ALUOp 10, SLT"); errors = errors + 1; end
        else $display("PASS: ALUOp 10, f3=010 (SLT)");

        // ALUOp = 10, funct3 = 011 -> SLTU (0110)
        alu_op = 2'b10; funct3 = 3'b011; funct7_b5 = 1; #10;
        if (alu_control_out !== 4'b0110) begin $display("FAIL: ALUOp 10, SLTU"); errors = errors + 1; end
        else $display("PASS: ALUOp 10, f3=011 (SLTU)");

        $display("---------------------------------");
        if (errors == 0) $display("ALL TESTS PASSED!");
        else $display("%d TESTS FAILED.", errors);
        $display("---------------------------------");
        $finish;
    end
endmodule
