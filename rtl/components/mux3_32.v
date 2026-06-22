module mux3_32 (
    input  wire [31:0] d0,
    input  wire [31:0] d1,
    input  wire [31:0] d2,
    input  wire [1:0]  sel,
    output wire [31:0] y
);
    assign y = (sel == 2'b00) ? d0 :
               (sel == 2'b01) ? d1 :
               (sel == 2'b10) ? d2 : 32'd0;
endmodule
