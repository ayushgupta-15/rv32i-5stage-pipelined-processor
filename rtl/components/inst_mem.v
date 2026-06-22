module inst_mem #(
    parameter INIT_FILE = "programs/hex/program.hex"
) (
    input  wire [31:0] pc,
    output wire [31:0] instruction
);

    reg [31:0] memory [0:255]; // 1KB memory (256 words)

    reg [1023:0] init_file_plusarg;

    initial begin
        if ($value$plusargs("INIT_FILE=%s", init_file_plusarg)) begin
            $readmemh(init_file_plusarg, memory);
        end else begin
            $readmemh(INIT_FILE, memory);
        end
    end

    // Word-aligned access (PC >> 2)
    assign instruction = memory[pc[31:2]];

endmodule
