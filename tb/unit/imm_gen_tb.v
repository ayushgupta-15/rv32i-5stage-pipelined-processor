`timescale 1ns / 1ps

module imm_gen_tb;

    reg [31:0] instruction;
    reg [2:0]  imm_sel;
    wire [31:0] imm_out;

    integer errors;

    imm_gen uut (
        .instruction(instruction),
        .imm_sel(imm_sel),
        .imm_out(imm_out)
    );

    initial begin
        errors = 0;
        
        $display("Starting Immediate Generator Tests...");

        // ----------------------------------------------------
        // Test 1: I-Type (ADDI x1, x0, 5)
        // binary: 0000 0000 0101 0000 0000 0000 1001 0011 (0x00500093)
        // ----------------------------------------------------
        instruction = 32'h00500093; imm_sel = 3'b000; #10;
        if (imm_out !== 32'd5) begin 
            $display("FAIL: I-Type (ADDI). Expected: 5, Got: %d", imm_out); 
            errors = errors + 1; 
        end else $display("PASS: I-Type (ADDI x1, x0, 5) -> 5");

        // ----------------------------------------------------
        // Test 2: S-Type (SW x1, 16(x2))
        // binary: 0000 0000 0001 0001 0010 1000 0010 0011 (0x00112823)
        // ----------------------------------------------------
        instruction = 32'h00112823; imm_sel = 3'b001; #10;
        if (imm_out !== 32'd16) begin 
            $display("FAIL: S-Type (SW). Expected: 16, Got: %d", imm_out); 
            errors = errors + 1; 
        end else $display("PASS: S-Type (SW x1, 16(x2)) -> 16");

        // ----------------------------------------------------
        // Test 3: B-Type (BEQ x1, x2, -8)
        // binary: 1111 1110 0010 0000 1000 1100 1110 0011 (0xFE208CE3)
        // ----------------------------------------------------
        instruction = 32'hFE208CE3; imm_sel = 3'b010; #10;
        if (imm_out !== 32'hFFFFFFF8) begin 
            $display("FAIL: B-Type (BEQ). Expected: FFFFFFF8 (-8), Got: %h", imm_out); 
            errors = errors + 1; 
        end else $display("PASS: B-Type (BEQ x1, x2, -8) -> -8");

        // ----------------------------------------------------
        // Test 4: U-Type (LUI x1, 0x12345)
        // binary: 0001 0010 0011 0100 0101 0000 1011 0111 (0x123450B7)
        // ----------------------------------------------------
        instruction = 32'h123450B7; imm_sel = 3'b011; #10;
        if (imm_out !== 32'h12345000) begin 
            $display("FAIL: U-Type (LUI). Expected: 12345000, Got: %h", imm_out); 
            errors = errors + 1; 
        end else $display("PASS: U-Type (LUI x1, 0x12345) -> 0x12345000");

        // ----------------------------------------------------
        // Test 5: J-Type (JAL x1, -4)
        // binary: 1111 1111 1101 1111 1111 0000 1110 1111 (0xFFDFF0EF)
        // ----------------------------------------------------
        instruction = 32'hFFDFF0EF; imm_sel = 3'b100; #10;
        if (imm_out !== 32'hFFFFFFFC) begin 
            $display("FAIL: J-Type (JAL). Expected: FFFFFFFC (-4), Got: %h", imm_out); 
            errors = errors + 1; 
        end else $display("PASS: J-Type (JAL x1, -4) -> -4");

        $display("---------------------------------");
        if (errors == 0) $display("ALL TESTS PASSED!");
        else $display("%d TESTS FAILED.", errors);
        $display("---------------------------------");
        
        $finish;
    end

endmodule
