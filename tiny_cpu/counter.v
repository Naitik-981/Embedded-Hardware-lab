module counter(clk, reset, load, inc, d, q);
    parameter N = 16;

    input clk, reset, load, inc;
    input [N-1:0] d;
    output reg [N-1:0] q;  // Declare output as reg for sequential logic

    always @(posedge clk or negedge reset) begin
        if (!reset) 
            q <= 0;
        else if (load) 
            q <= d;
        else if (inc) 
            q <= q + 1;
    end
endmodule
