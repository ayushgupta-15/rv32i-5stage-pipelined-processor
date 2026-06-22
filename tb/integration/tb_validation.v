`timescale 1ns / 1ps

module tb_validation;
    reg clk;
    reg reset;
    reg [255:0] test_name;

    riscv_pipeline dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        if (!$value$plusargs("TEST_NAME=%s", test_name)) begin
            $display("FAIL: TEST_NAME not provided");
            $finish;
        end

        clk = 0;
        reset = 1;
        #12 reset = 0;

        // Run for enough cycles (e.g. 20 cycles is enough for these tiny programs)
        #200;

        if (test_name == "arith") begin
            if (dut.rf.registers[3] == 30 && dut.rf.registers[4] == 10)
                $display("PASS");
            else
                $display("FAIL: x3=%0d, x4=%0d", dut.rf.registers[3], dut.rf.registers[4]);
        end 
        else if (test_name == "memory") begin
            if (dut.rf.registers[2] == 55 && dut.dmem.memory[0] == 55)
                $display("PASS");
            else
                $display("FAIL: x2=%0d, mem[0]=%0d", dut.rf.registers[2], dut.dmem.memory[0]);
        end
        else if (test_name == "branch_taken") begin
            if (dut.rf.registers[3] == 0 && dut.rf.registers[4] == 42)
                $display("PASS");
            else
                $display("FAIL: x3=%0d, x4=%0d", dut.rf.registers[3], dut.rf.registers[4]);
        end
        else if (test_name == "branch_not_taken") begin
            if (dut.rf.registers[3] == 99 && dut.rf.registers[4] == 42)
                $display("PASS");
            else
                $display("FAIL: x3=%0d, x4=%0d", dut.rf.registers[3], dut.rf.registers[4]);
        end
        else if (test_name == "jal") begin
            if (dut.rf.registers[1] == 4 && dut.rf.registers[2] == 0 && dut.rf.registers[3] == 42)
                $display("PASS");
            else
                $display("FAIL: x1=%0d, x2=%0d, x3=%0d", dut.rf.registers[1], dut.rf.registers[2], dut.rf.registers[3]);
        end
        else if (test_name == "load_use") begin
            if (dut.rf.registers[2] == 154)
                $display("PASS");
            else
                $display("FAIL: x2=%0d", dut.rf.registers[2]);
        end
        else if (test_name == "dependency") begin
            if (dut.rf.registers[1] == 5 && dut.rf.registers[2] == 8 && dut.rf.registers[3] == 13)
                $display("PASS");
            else
                $display("FAIL: x1=%0d, x2=%0d, x3=%0d", dut.rf.registers[1], dut.rf.registers[2], dut.rf.registers[3]);
        end
        else if (test_name == "mixed") begin
            if (dut.rf.registers[3] == 30 && dut.dmem.memory[0] == 30 && dut.rf.registers[4] == 30 &&
                dut.rf.registers[5] == 0 && dut.rf.registers[6] == 32 && dut.rf.registers[7] == 0 && dut.rf.registers[8] == 42)
                $display("PASS");
            else
                $display("FAIL: x3=%0d, mem[0]=%0d, x4=%0d, x5=%0d, x6=%0d, x7=%0d, x8=%0d",
                         dut.rf.registers[3], dut.dmem.memory[0], dut.rf.registers[4], dut.rf.registers[5], dut.rf.registers[6], dut.rf.registers[7], dut.rf.registers[8]);
        end
        else begin
            $display("FAIL: Unknown test %s", test_name);
        end

        $finish;
    end
endmodule
