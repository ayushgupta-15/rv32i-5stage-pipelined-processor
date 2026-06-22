module data_mem (
    input  wire        clk,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    input  wire        mem_read,
    input  wire        mem_write,
    output wire [31:0] read_data
);

    reg [31:0] memory [0:255]; // 1KB memory (256 words)
    wire [29:0] word_addr = addr[31:2]; // Word-aligned

    // Asynchronous Read
    assign read_data = (mem_read) ? memory[word_addr] : 32'd0;

    // Synchronous Write
    always @(posedge clk) begin
        if (mem_write) begin
            memory[word_addr] <= write_data;
        end
    end

endmodule
