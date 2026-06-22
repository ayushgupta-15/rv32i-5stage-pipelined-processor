`timescale 1ns / 1ps

module control_tb;

    reg [6:0] opcode;
    wire reg_write;
    wire alu_src;
    wire mem_read;
    wire mem_write;
    wire mem_to_reg;
    wire branch;
    wire jump;
    wire [1:0] alu_op;
    wire [2:0] imm_sel;

    integer errors;

    control uut (
        .opcode(opcode),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op),
        .imm_sel(imm_sel)
    );

    initial begin
        errors = 0;
        #10;
        $display("Starting Control Unit Tests...");

        // R-Type
        opcode = 7'b0110011; #10;
        if (reg_write !== 1 || alu_src !== 0 || mem_read !== 0 || mem_write !== 0 || mem_to_reg !== 0 || branch !== 0 || jump !== 0 || alu_op !== 2'b10) begin
            $display("FAIL: R-Type"); errors = errors + 1;
        end else $display("PASS: R-Type");

        // ADDI
        opcode = 7'b0010011; #10;
        if (reg_write !== 1 || alu_src !== 1 || mem_read !== 0 || mem_write !== 0 || mem_to_reg !== 0 || branch !== 0 || jump !== 0 || alu_op !== 2'b10) begin
            $display("FAIL: ADDI"); errors = errors + 1;
        end else $display("PASS: ADDI");

        // LW
        opcode = 7'b0000011; #10;
        if (reg_write !== 1 || alu_src !== 1 || mem_read !== 1 || mem_write !== 0 || mem_to_reg !== 1 || branch !== 0 || jump !== 0 || alu_op !== 2'b00) begin
            $display("FAIL: LW"); errors = errors + 1;
        end else $display("PASS: LW");

        // SW
        opcode = 7'b0100011; #10;
        if (reg_write !== 0 || alu_src !== 1 || mem_read !== 0 || mem_write !== 1 || mem_to_reg !== 0 || branch !== 0 || jump !== 0 || alu_op !== 2'b00) begin
            $display("FAIL: SW"); errors = errors + 1;
        end else $display("PASS: SW");

        // BEQ
        opcode = 7'b1100011; #10;
        if (reg_write !== 0 || alu_src !== 0 || mem_read !== 0 || mem_write !== 0 || mem_to_reg !== 0 || branch !== 1 || jump !== 0 || alu_op !== 2'b01) begin
            $display("FAIL: BEQ"); errors = errors + 1;
        end else $display("PASS: BEQ");

        // JAL
        opcode = 7'b1101111; #10;
        if (reg_write !== 1 || mem_read !== 0 || mem_write !== 0 || branch !== 0 || jump !== 1) begin
            $display("FAIL: JAL"); errors = errors + 1;
        end else $display("PASS: JAL");

        // LUI
        opcode = 7'b0110111; #10;
        if (reg_write !== 1 || alu_src !== 1 || mem_read !== 0 || mem_write !== 0 || mem_to_reg !== 0 || branch !== 0 || jump !== 0) begin
            $display("FAIL: LUI"); errors = errors + 1;
        end else $display("PASS: LUI");

        $display("---------------------------------");
        if (errors == 0) $display("ALL TESTS PASSED!");
        else $display("%d TESTS FAILED.", errors);
        $display("---------------------------------");
        $finish;
    end
endmodule
