module ff (clk, reset, d, q);
    input clk, reset, d;
    output reg q;  // `q` should be declared as `reg` for sequential logic

    always @(posedge clk or negedge reset) begin
        if (!reset) 
            q <= 0;  // Asynchronous reset
        else 
            q <= d;
    end
endmodule
