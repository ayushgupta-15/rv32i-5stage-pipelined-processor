`timescale 1ns / 1ps

module data_mem_tb;

    reg clk;
    reg [31:0] addr;
    reg [31:0] write_data;
    reg mem_read;
    reg mem_write;
    
    wire [31:0] read_data;

    integer errors;

    data_mem uut (
        .clk(clk),
        .addr(addr),
        .write_data(write_data),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        addr = 0;
        write_data = 0;
        mem_read = 0;
        mem_write = 0;
        errors = 0;

        #10;
        $display("Starting Data Memory Tests...");

        // Write 42 to address 0
        mem_write = 1; addr = 32'd0; write_data = 32'd42; #10;
        mem_write = 0;
        
        // Read address 0
        mem_read = 1; addr = 32'd0; #10;
        if (read_data !== 32'd42) begin
            $display("FAIL: Address 0. Expected 42, Got: %d", read_data);
            errors = errors + 1;
        end else $display("PASS: Address 0 -> 42");
        mem_read = 0;

        // Multiple writes
        mem_write = 1; addr = 32'd0; write_data = 32'd10; #10;
        mem_write = 1; addr = 32'd4; write_data = 32'd20; #10;
        mem_write = 1; addr = 32'd8; write_data = 32'd30; #10;
        mem_write = 0;

        // Multiple reads
        mem_read = 1; addr = 32'd0; #10;
        if (read_data !== 32'd10) begin $display("FAIL: Addr 0 Aliasing"); errors = errors+1; end
        else $display("PASS: Address 0 -> 10");

        mem_read = 1; addr = 32'd4; #10;
        if (read_data !== 32'd20) begin $display("FAIL: Addr 4 Aliasing"); errors = errors+1; end
        else $display("PASS: Address 4 -> 20");

        mem_read = 1; addr = 32'd8; #10;
        if (read_data !== 32'd30) begin $display("FAIL: Addr 8 Aliasing"); errors = errors+1; end
        else $display("PASS: Address 8 -> 30");

        $display("---------------------------------");
        if (errors == 0) $display("ALL TESTS PASSED!");
        else $display("%d TESTS FAILED.", errors);
        $display("---------------------------------");
        
        $finish;
    end
endmodule
