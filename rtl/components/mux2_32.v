module mux2_32 (
    input  wire [31:0] d0,
    input  wire [31:0] d1,
    input  wire        sel,
    output wire [31:0] y
);
    assign y = sel ? d1 : d0;
endmodule
