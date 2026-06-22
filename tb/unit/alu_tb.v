`timescale 1ns / 1ps

module alu_tb;

    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0]  alu_control;

    // Outputs
    wire [31:0] result;
    wire        zero;

    // Instantiate the ALU
    alu uut (
        .a(a), 
        .b(b), 
        .alu_control(alu_control), 
        .result(result), 
        .zero(zero)
    );

    // Test Variables
    integer errors;

    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        alu_control = 0;
        errors = 0;

        // Wait 10 ns for global reset to finish
        #10;
        
        $display("Starting ALU Tests...");

        // ----------------------------------------------------
        // Test 1: ADD (alu_control = 4'b0010)
        // ----------------------------------------------------
        a = 32'd15; b = 32'd10; alu_control = 4'b0010; #10;
        if (result !== 32'd25 || zero !== 1'b0) begin
            $display("FAIL: ADD 15 + 10. Expected: 25, zero: 0. Got: %d, zero: %b", result, zero);
            errors = errors + 1;
        end else $display("PASS: ADD");

        // ----------------------------------------------------
        // Test 2: SUB (alu_control = 4'b0011)
        // ----------------------------------------------------
        a = 32'd15; b = 32'd10; alu_control = 4'b0011; #10;
        if (result !== 32'd5 || zero !== 1'b0) begin
            $display("FAIL: SUB 15 - 10. Expected: 5, zero: 0. Got: %d, zero: %b", result, zero);
            errors = errors + 1;
        end else $display("PASS: SUB");

        // ----------------------------------------------------
        // Test 3: ZERO Flag (SUB 15 - 15)
        // ----------------------------------------------------
        a = 32'd15; b = 32'd15; alu_control = 4'b0011; #10;
        if (result !== 32'd0 || zero !== 1'b1) begin
            $display("FAIL: SUB 15 - 15 (Zero flag). Expected: 0, zero: 1. Got: %d, zero: %b", result, zero);
            errors = errors + 1;
        end else $display("PASS: ZERO Flag");

        // ----------------------------------------------------
        // Test 4: AND (alu_control = 4'b0000)
        // ----------------------------------------------------
        a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; alu_control = 4'b0000; #10;
        if (result !== 32'h00000000 || zero !== 1'b1) begin
            $display("FAIL: AND F0F0F0F0 & 0F0F0F0F. Expected: 0, zero: 1. Got: %h, zero: %b", result, zero);
            errors = errors + 1;
        end else $display("PASS: AND");

        // ----------------------------------------------------
        // Test 5: OR (alu_control = 4'b0001)
        // ----------------------------------------------------
        a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; alu_control = 4'b0001; #10;
        if (result !== 32'hFFFFFFFF || zero !== 1'b0) begin
            $display("FAIL: OR F0F0F0F0 | 0F0F0F0F. Expected: FFFFFFFF, zero: 0. Got: %h, zero: %b", result, zero);
            errors = errors + 1;
        end else $display("PASS: OR");

        // ----------------------------------------------------
        // Test 6: XOR (alu_control = 4'b0100)
        // ----------------------------------------------------
        a = 32'hAAAAAAAA; b = 32'h55555555; alu_control = 4'b0100; #10;
        if (result !== 32'hFFFFFFFF || zero !== 1'b0) begin
            $display("FAIL: XOR AAAAAAAA ^ 55555555. Expected: FFFFFFFF, zero: 0. Got: %h, zero: %b", result, zero);
            errors = errors + 1;
        end else $display("PASS: XOR");

        // ----------------------------------------------------
        // Test 7: SLT - Set Less Than Signed (alu_control = 4'b0101)
        // ----------------------------------------------------
        a = -32'd10; b = 32'd5; alu_control = 4'b0101; #10;
        if (result !== 32'd1 || zero !== 1'b0) begin
            $display("FAIL: SLT -10 < 5. Expected: 1, zero: 0. Got: %d, zero: %b", result, zero);
            errors = errors + 1;
        end else $display("PASS: SLT (Signed)");

        // ----------------------------------------------------
        // Test 8: SLTU - Set Less Than Unsigned (alu_control = 4'b0110)
        // ----------------------------------------------------
        a = -32'd10; b = 32'd5; alu_control = 4'b0110; #10;
        if (result !== 32'd0 || zero !== 1'b1) begin // Unsigned: -10 is a huge positive number, so it's not < 5
            $display("FAIL: SLTU -10 < 5. Expected: 0, zero: 1. Got: %d, zero: %b", result, zero);
            errors = errors + 1;
        end else $display("PASS: SLTU (Unsigned)");

        // Summary
        $display("---------------------------------");
        if (errors == 0) begin
            $display("ALL TESTS PASSED!");
        end else begin
            $display("%d TESTS FAILED.", errors);
        end
        $display("---------------------------------");
        
        $finish;
    end

endmodule
