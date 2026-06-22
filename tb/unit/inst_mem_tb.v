`timescale 1ns / 1ps

module inst_mem_tb;

    reg  [31:0] pc;
    wire [31:0] instruction;
    
    integer errors;

    inst_mem uut (
        .pc(pc),
        .instruction(instruction)
    );

    initial begin
        errors = 0;
        #10;
        $display("Starting Instruction Memory Tests...");

        // Test PC = 0
        pc = 32'd0; #10;
        if (instruction !== 32'h00500093) begin
            $display("FAIL: PC=0. Expected: 00500093, Got: %h", instruction);
            errors = errors + 1;
        end else $display("PASS: PC=0 (ADDI x1, x0, 5)");

        // Test PC = 4
        pc = 32'd4; #10;
        if (instruction !== 32'h00300113) begin
            $display("FAIL: PC=4. Expected: 00300113, Got: %h", instruction);
            errors = errors + 1;
        end else $display("PASS: PC=4 (ADDI x2, x0, 3)");

        // Test PC = 8
        pc = 32'd8; #10;
        if (instruction !== 32'h002081b3) begin
            $display("FAIL: PC=8. Expected: 002081b3, Got: %h", instruction);
            errors = errors + 1;
        end else $display("PASS: PC=8 (ADD x3, x1, x2)");

        $display("---------------------------------");
        if (errors == 0) $display("ALL TESTS PASSED!");
        else $display("%d TESTS FAILED.", errors);
        $display("---------------------------------");
        $finish;
    end
endmodule
