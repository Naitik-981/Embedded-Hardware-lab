module ram #(parameter WIDTH = 16, ADDR_WIDTH = 12, DEPTH = 4096) (
    input clk, load,
    input [ADDR_WIDTH-1:0] addr,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        if (load)
            mem[addr] <= d;
        q <= mem[addr];
    end
endmodule