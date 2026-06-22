module riscv_pipeline #(
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
        end else if (pc_write) begin
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
    // IF/ID Pipeline Register
    // -----------------------------------------------------------------
    wire [31:0] id_pc;
    wire [31:0] id_instruction;

    if_id_reg if_id (
        .clk(clk),
        .reset(reset),
        .write_enable(if_id_write),
        .flush(flush),
        .if_pc(pc),
        .if_instruction(instruction),
        .id_pc(id_pc),
        .id_instruction(id_instruction)
    );

    // -----------------------------------------------------------------
    // Decode Stage
    // -----------------------------------------------------------------

    wire [6:0]  id_opcode = id_instruction[6:0];
    wire [4:0]  id_rd     = id_instruction[11:7];
    wire [2:0]  id_funct3 = id_instruction[14:12];
    wire [4:0]  id_rs1    = id_instruction[19:15];
    wire [4:0]  id_rs2    = id_instruction[24:20];
    wire        id_funct7_b5 = id_instruction[30];

    wire       id_reg_write;
    wire       id_alu_src;
    wire       id_mem_read;
    wire       id_mem_write;
    wire       id_mem_to_reg;
    wire       id_branch;
    wire       id_jump;
    wire [1:0] id_alu_op;
    wire [2:0] id_imm_sel;

    control ctrl (
        .opcode(id_opcode),
        .reg_write(id_reg_write),
        .alu_src(id_alu_src),
        .mem_read(id_mem_read),
        .mem_write(id_mem_write),
        .mem_to_reg(id_mem_to_reg),
        .branch(id_branch),
        .jump(id_jump),
        .alu_op(id_alu_op),
        .imm_sel(id_imm_sel)
    );

    wire wb_reg_write; 
    wire [4:0] wb_rd;
    wire [31:0] wb_writeback_data;

    wire [31:0] id_rs1_data;
    wire [31:0] id_rs2_data;

    reg_file rf (
        .clk(clk),
        .reg_write(wb_reg_write),
        .read_reg1(id_rs1),
        .read_reg2(id_rs2),
        .write_reg(wb_rd),
        .write_data(wb_writeback_data),
        .read_data1(id_rs1_data),
        .read_data2(id_rs2_data)
    );

    wire [31:0] id_imm_out;

    imm_gen ig (
        .instruction(id_instruction),
        .imm_sel(id_imm_sel),
        .imm_out(id_imm_out)
    );

    // -----------------------------------------------------------------
    // Hazard Detection Unit
    // -----------------------------------------------------------------
    wire hazard_stall;
    wire pc_write;
    wire if_id_write;

    hazard_detection_unit hdu (
        .id_ex_memread(ex_mem_read),
        .id_ex_rd(ex_rd),
        .if_id_rs1(id_rs1),
        .if_id_rs2(id_rs2),
        .pc_write(pc_write),
        .if_id_write(if_id_write),
        .stall(hazard_stall)
    );

    // -----------------------------------------------------------------
    // ID/EX Pipeline Register
    // -----------------------------------------------------------------
    wire [31:0] ex_pc;
    wire [31:0] ex_rs1_data;
    wire [31:0] ex_rs2_data;
    wire [31:0] ex_imm_out;
    wire [4:0]  ex_rs1;
    wire [4:0]  ex_rs2;
    wire [4:0]  ex_rd;
    wire [2:0]  ex_funct3;
    wire        ex_funct7_b5;

    wire       ex_reg_write;
    wire       ex_alu_src;
    wire       ex_mem_read;
    wire       ex_mem_write;
    wire       ex_mem_to_reg;
    wire       ex_branch;
    wire       ex_jump;
    wire [1:0] ex_alu_op;

    wire force_bubble = hazard_stall || flush;

    wire mux_id_reg_write = force_bubble ? 1'b0 : id_reg_write;
    wire mux_id_mem_read  = force_bubble ? 1'b0 : id_mem_read;
    wire mux_id_mem_write = force_bubble ? 1'b0 : id_mem_write;
    wire mux_id_branch    = force_bubble ? 1'b0 : id_branch;
    wire mux_id_jump      = force_bubble ? 1'b0 : id_jump;

    id_ex_reg id_ex (
        .clk(clk),
        .reset(reset),

        .id_pc(id_pc),
        .id_rs1_data(id_rs1_data),
        .id_rs2_data(id_rs2_data),
        .id_imm_out(id_imm_out),
        .id_rs1(id_rs1),
        .id_rs2(id_rs2),
        .id_rd(id_rd),
        .id_funct3(id_funct3),
        .id_funct7_b5(id_funct7_b5),

        .id_reg_write(mux_id_reg_write),
        .id_alu_src(id_alu_src),
        .id_mem_read(mux_id_mem_read),
        .id_mem_write(mux_id_mem_write),
        .id_mem_to_reg(id_mem_to_reg),
        .id_branch(mux_id_branch),
        .id_jump(mux_id_jump),
        .id_alu_op(id_alu_op),

        .ex_pc(ex_pc),
        .ex_rs1_data(ex_rs1_data),
        .ex_rs2_data(ex_rs2_data),
        .ex_imm_out(ex_imm_out),
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .ex_rd(ex_rd),
        .ex_funct3(ex_funct3),
        .ex_funct7_b5(ex_funct7_b5),

        .ex_reg_write(ex_reg_write),
        .ex_alu_src(ex_alu_src),
        .ex_mem_read(ex_mem_read),
        .ex_mem_write(ex_mem_write),
        .ex_mem_to_reg(ex_mem_to_reg),
        .ex_branch(ex_branch),
        .ex_jump(ex_jump),
        .ex_alu_op(ex_alu_op)
    );

    // -----------------------------------------------------------------
    // Execute Stage
    // -----------------------------------------------------------------

    wire [3:0] alu_ctrl;
    alu_control ac (
        .alu_op(ex_alu_op),
        .funct3(ex_funct3),
        .funct7_b5(ex_funct7_b5),
        .alu_control_out(alu_ctrl)
    );

    // Forwarding Unit
    wire [1:0] forward_a;
    wire [1:0] forward_b;

    forwarding_unit fwd (
        .id_ex_rs1(ex_rs1),
        .id_ex_rs2(ex_rs2),
        .ex_mem_rd(mem_rd),
        .ex_mem_regwrite(mem_reg_write),
        .mem_wb_rd(wb_rd),
        .mem_wb_regwrite(wb_reg_write),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    wire [31:0] ex_mem_forward_val = mem_jump ? mem_pc_plus_4 : mem_alu_result;

    wire [31:0] forward_a_val;
    mux3_32 fwd_a_mux (
        .d0(ex_rs1_data),
        .d1(wb_writeback_data),
        .d2(ex_mem_forward_val),
        .sel(forward_a),
        .y(forward_a_val)
    );

    wire [31:0] forward_b_val;
    mux3_32 fwd_b_mux (
        .d0(ex_rs2_data),
        .d1(wb_writeback_data),
        .d2(ex_mem_forward_val),
        .sel(forward_b),
        .y(forward_b_val)
    );

    wire [31:0] alu_in_b;
    mux2_32 alu_src_mux (
        .d0(forward_b_val),
        .d1(ex_imm_out),
        .sel(ex_alu_src),
        .y(alu_in_b)
    );

    wire [31:0] ex_alu_result;
    wire        ex_alu_zero;
    alu alu_inst (
        .a(forward_a_val),
        .b(alu_in_b),
        .alu_control(alu_ctrl),
        .result(ex_alu_result),
        .zero(ex_alu_zero)
    );

    // -----------------------------------------------------------------
    // Branch, Jump & PC Logic
    // -----------------------------------------------------------------
    
    wire [31:0] if_pc_plus_4 = pc + 32'd4;
    wire [31:0] ex_pc_plus_4 = ex_pc + 32'd4;
    wire [31:0] branch_target = ex_pc + ex_imm_out;

    wire is_beq = (ex_funct3 == 3'b000);
    wire is_bne = (ex_funct3 == 3'b001);
    
    wire branch_taken = ex_branch && (
        (is_beq && (forward_a_val == forward_b_val)) ||
        (is_bne && (forward_a_val != forward_b_val))
    );

    wire flush = branch_taken || ex_jump;

    assign next_pc = flush ? branch_target : if_pc_plus_4;

    // -----------------------------------------------------------------
    // EX/MEM Pipeline Register
    // -----------------------------------------------------------------
    wire [31:0] mem_alu_result;
    wire [31:0] mem_rs2_data;
    wire [4:0]  mem_rd;
    wire [31:0] mem_pc_plus_4;

    wire        mem_reg_write;
    wire        mem_mem_read;
    wire        mem_mem_write;
    wire        mem_mem_to_reg;
    wire        mem_jump;

    ex_mem_reg ex_mem (
        .clk(clk),
        .reset(reset),

        .ex_alu_result(ex_alu_result),
        .ex_rs2_data(forward_b_val),
        .ex_rd(ex_rd),
        .ex_pc_plus_4(ex_pc_plus_4),

        .ex_reg_write(ex_reg_write),
        .ex_mem_read(ex_mem_read),
        .ex_mem_write(ex_mem_write),
        .ex_mem_to_reg(ex_mem_to_reg),
        .ex_jump(ex_jump),

        .mem_alu_result(mem_alu_result),
        .mem_rs2_data(mem_rs2_data),
        .mem_rd(mem_rd),
        .mem_pc_plus_4(mem_pc_plus_4),

        .mem_reg_write(mem_reg_write),
        .mem_mem_read(mem_mem_read),
        .mem_mem_write(mem_mem_write),
        .mem_mem_to_reg(mem_mem_to_reg),
        .mem_jump(mem_jump)
    );

    // -----------------------------------------------------------------
    // Memory Stage
    // -----------------------------------------------------------------

    wire [31:0] mem_read_data;

    data_mem dmem (
        .clk(clk),
        .addr(mem_alu_result),
        .write_data(mem_rs2_data),
        .mem_read(mem_mem_read),
        .mem_write(mem_mem_write),
        .read_data(mem_read_data)
    );

    // -----------------------------------------------------------------
    // MEM/WB Pipeline Register
    // -----------------------------------------------------------------
    wire [31:0] wb_read_data;
    wire [31:0] wb_alu_result;
    wire [31:0] wb_pc_plus_4;

    wire        wb_mem_to_reg;
    wire        wb_jump;

    mem_wb_reg mem_wb (
        .clk(clk),
        .reset(reset),

        .mem_read_data(mem_read_data),
        .mem_alu_result(mem_alu_result),
        .mem_rd(mem_rd),
        .mem_pc_plus_4(mem_pc_plus_4),

        .mem_reg_write(mem_reg_write),
        .mem_mem_to_reg(mem_mem_to_reg),
        .mem_jump(mem_jump),

        .wb_read_data(wb_read_data),
        .wb_alu_result(wb_alu_result),
        .wb_rd_out(wb_rd),
        .wb_pc_plus_4(wb_pc_plus_4),

        .wb_reg_write_out(wb_reg_write),
        .wb_mem_to_reg_out(wb_mem_to_reg),
        .wb_jump_out(wb_jump)
    );

    // -----------------------------------------------------------------
    // Writeback Stage
    // -----------------------------------------------------------------

    wire [1:0] wb_sel = {wb_jump, wb_mem_to_reg};

    mux3_32 wb_mux (
        .d0(wb_alu_result),
        .d1(wb_read_data),
        .d2(wb_pc_plus_4),
        .sel(wb_sel),
        .y(wb_writeback_data)
    );

endmodule
