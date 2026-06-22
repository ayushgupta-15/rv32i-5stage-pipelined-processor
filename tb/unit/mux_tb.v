`timescale 1ns / 1ps

module mux_tb;

    reg [31:0] d0, d1, d2;
    reg sel2;
    reg [1:0] sel3;
    wire [31:0] y2, y3;

    integer errors;

    mux2_32 uut2 (
        .d0(d0),
        .d1(d1),
        .sel(sel2),
        .y(y2)
    );

    mux3_32 uut3 (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .sel(sel3),
        .y(y3)
    );

    initial begin
        errors = 0;
        d0 = 32'hAAAA;
        d1 = 32'hBBBB;
        d2 = 32'hCCCC;
        #10;
        
        $display("Starting Mux Tests...");

        // mux2_32 tests
        sel2 = 0; #10;
        if (y2 !== 32'hAAAA) begin $display("FAIL: mux2 sel=0"); errors = errors+1; end
        else $display("PASS: mux2 sel=0 -> d0");
        
        sel2 = 1; #10;
        if (y2 !== 32'hBBBB) begin $display("FAIL: mux2 sel=1"); errors = errors+1; end
        else $display("PASS: mux2 sel=1 -> d1");

        // mux3_32 tests
        sel3 = 2'b00; #10;
        if (y3 !== 32'hAAAA) begin $display("FAIL: mux3 sel=00"); errors = errors+1; end
        else $display("PASS: mux3 sel=00 -> d0");
        
        sel3 = 2'b01; #10;
        if (y3 !== 32'hBBBB) begin $display("FAIL: mux3 sel=01"); errors = errors+1; end
        else $display("PASS: mux3 sel=01 -> d1");
        
        sel3 = 2'b10; #10;
        if (y3 !== 32'hCCCC) begin $display("FAIL: mux3 sel=10"); errors = errors+1; end
        else $display("PASS: mux3 sel=10 -> d2");

        $display("---------------------------------");
        if (errors == 0) $display("ALL TESTS PASSED!");
        else $display("%d TESTS FAILED.", errors);
        $display("---------------------------------");
        $finish;
    end
endmodule
