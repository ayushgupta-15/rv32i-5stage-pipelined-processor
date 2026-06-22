module riscv_single_cycle #(
    parameter INIT_FILE = "programs/hex/program.hex"
) (
    input wire clk,
    input wire reset
);

    // PC Register
    reg [31:0] pc;
    wire [31:0] next_pc;

    // Instruction Memory wires
    wire [31:0] instruction;

    // PC Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'd0;
        end else begin
            pc <= next_pc;
        end
    end

    // Instruction Memory Instance
    inst_mem #(
        .INIT_FILE(INIT_FILE)
    ) imem (
        .pc(pc),
        .instruction(instruction)
    );

    // -----------------------------------------------------------------
    // Decode Stage
    // -----------------------------------------------------------------

    // Instruction Fields
    wire [6:0]  opcode = instruction[6:0];
    wire [4:0]  rd     = instruction[11:7];
    wire [2:0]  funct3 = instruction[14:12];
    wire [4:0]  rs1    = instruction[19:15];
    wire [4:0]  rs2    = instruction[24:20];
    wire [6:0]  funct7 = instruction[31:25];

    // Control Unit Wires
    wire       reg_write;
    wire       alu_src;
    wire       mem_read;
    wire       mem_write;
    wire       mem_to_reg;
    wire       branch;
    wire       jump;
    wire [1:0] alu_op;
    wire [2:0] imm_sel;

    control ctrl (
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

    // Register File Wires
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] writeback_data; 

    reg_file rf (
        .clk(clk),
        .reg_write(reg_write),
        .read_reg1(rs1),
        .read_reg2(rs2),
        .write_reg(rd),
        .write_data(writeback_data),
        .read_data1(rs1_data),
        .read_data2(rs2_data)
    );

    // Immediate Generator Wires
    wire [31:0] imm_out;

    imm_gen ig (
        .instruction(instruction),
        .imm_sel(imm_sel),
        .imm_out(imm_out)
    );

    // -----------------------------------------------------------------
    // Execute Stage
    // -----------------------------------------------------------------

    // ALU Control
    wire [3:0] alu_ctrl;
    alu_control ac (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7_b5(instruction[30]),
        .alu_control_out(alu_ctrl)
    );

    // ALUSrc Mux
    wire [31:0] alu_in_b;
    mux2_32 alu_src_mux (
        .d0(rs2_data),
        .d1(imm_out),
        .sel(alu_src),
        .y(alu_in_b)
    );

    // ALU
    wire [31:0] alu_result;
    wire        alu_zero;
    alu alu_inst (
        .a(rs1_data),
        .b(alu_in_b),
        .alu_control(alu_ctrl),
        .result(alu_result),
        .zero(alu_zero)
    );

    // -----------------------------------------------------------------
    // Memory Stage
    // -----------------------------------------------------------------

    wire [31:0] mem_read_data;

    data_mem dmem (
        .clk(clk),
        .addr(alu_result),
        .write_data(rs2_data),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(mem_read_data)
    );

    // -----------------------------------------------------------------
    // Branch, Jump & PC Logic
    // -----------------------------------------------------------------
    
    wire [31:0] pc_plus_4 = pc + 32'd4;
    wire [31:0] branch_target = pc + imm_out;

    wire is_beq = (funct3 == 3'b000);
    wire is_bne = (funct3 == 3'b001);
    
    wire branch_taken = branch && (
        (is_beq && (rs1_data == rs2_data)) ||
        (is_bne && (rs1_data != rs2_data))
    );

    assign next_pc = (branch_taken || jump) ? branch_target : pc_plus_4;

    // -----------------------------------------------------------------
    // Writeback Stage
    // -----------------------------------------------------------------

    // Writeback Mux
    wire [1:0] wb_sel = {jump, mem_to_reg};

    mux3_32 wb_mux (
        .d0(alu_result),
        .d1(mem_read_data),
        .d2(pc_plus_4),
        .sel(wb_sel),
        .y(writeback_data)
    );

endmodule
