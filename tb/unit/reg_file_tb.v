`timescale 1ns / 1ps

module reg_file_tb;

    reg clk;
    reg reg_write;
    reg [4:0] read_reg1;
    reg [4:0] read_reg2;
    reg [4:0] write_reg;
    reg [31:0] write_data;

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    integer errors;

    reg_file uut (
        .clk(clk),
        .reg_write(reg_write),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reg_write = 0;
        read_reg1 = 0;
        read_reg2 = 0;
        write_reg = 0;
        write_data = 0;
        errors = 0;

        // Wait 10 ns for global reset
        #10;
        $display("Starting Register File Tests...");

        // ----------------------------------------------------
        // Test 1: Write x5 = 42, Read x5
        // ----------------------------------------------------
        reg_write = 1; write_reg = 5; write_data = 32'd42;
        #10; // Wait for positive clock edge
        reg_write = 0; read_reg1 = 5;
        #10;
        if (read_data1 !== 32'd42) begin 
            $display("FAIL: Test 1. Expected 42, Got: %d", read_data1); 
            errors = errors + 1; 
        end else $display("PASS: Test 1 (Write x5=42, Read x5)");

        // ----------------------------------------------------
        // Test 2: Write x10 = 0x12345678, Read x10 (via port 2)
        // ----------------------------------------------------
        reg_write = 1; write_reg = 10; write_data = 32'h12345678;
        #10;
        reg_write = 0; read_reg2 = 10;
        #10;
        if (read_data2 !== 32'h12345678) begin 
            $display("FAIL: Test 2. Expected 12345678, Got: %h", read_data2); 
            errors = errors + 1; 
        end else $display("PASS: Test 2 (Write x10=0x12345678, Read x10)");

        // ----------------------------------------------------
        // Test 3: Write x0 = 999, Read x0 (Should be 0)
        // ----------------------------------------------------
        reg_write = 1; write_reg = 0; write_data = 32'd999;
        #10;
        reg_write = 0; read_reg1 = 0;
        #10;
        if (read_data1 !== 32'd0) begin 
            $display("FAIL: Test 3. Expected 0, Got: %d", read_data1); 
            errors = errors + 1; 
        end else $display("PASS: Test 3 (Write x0=999, Read x0 returns 0)");

        $display("---------------------------------");
        if (errors == 0) $display("ALL TESTS PASSED!");
        else $display("%d TESTS FAILED.", errors);
        $display("---------------------------------");
        
        $finish;
    end

endmodule
