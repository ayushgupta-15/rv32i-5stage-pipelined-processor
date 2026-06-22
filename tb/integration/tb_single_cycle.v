`timescale 1ns / 1ps

module tb_single_cycle;

    reg clk;
    reg reset;

    riscv_single_cycle #(
        .INIT_FILE("programs/hex/jal_program.hex")
    ) dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        
        $display("Starting Single-Cycle Integration Tests (JAL Stage)...");
        
        // Hold reset for 12ns (drops on the negative edge)
        #12;
        reset = 0;
        
        // Cycle 1: JAL x1, target (+8 bytes)
        #3; 
        $display("--- Cycle 1: JAL PC=%h ---", dut.pc);
        
        // Cycle 2: Target -> ADDI x3, x0, 42
        #10;
        $display("--- Cycle 2: Target PC=%h ---", dut.pc);

        // Wait one more cycle for the last writeback to complete
        #10;
        $display("--- Final State ---");
        $display("x1 = %0d", dut.rf.registers[1]);
        $display("x2 = %0d", dut.rf.registers[2]);
        $display("x3 = %0d\n", dut.rf.registers[3]);

        #10;
        $finish;
    end
endmodule
