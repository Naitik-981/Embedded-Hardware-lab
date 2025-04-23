`timescale 1ns/1ps

module counter_tb;
    parameter N = 16;
    
    reg clk, reset, load, inc;
    reg [N-1:0] d;
    wire [N-1:0] q;

    // Instantiate the counter module
    counter #(N) uut (.clk(clk), .reset(reset), .load(load), .inc(inc), .d(d), .q(q));

    // Clock generation
    initial begin
        clk = 0;
        forever #50 clk = ~clk; // Toggle clock every 50 ns
    end

    // Stimulus
    initial begin
        reset = 0; load = 0; inc = 0; d = 0;
        #100 reset = 1;  // Release reset
        #100 load = 1; d = 16'h1234; // Load value
        #50 load = 0;
        #200 inc = 1; // Start incrementing
        #400 inc = 0;
        #100 reset = 0; // Assert reset
        #100 reset = 1; // Deassert reset
        #200 d = 16'h5678; load = 1; // Load another value
        #50 load = 0;
        #200 inc = 1;
        #200 $finish;  // Stop simulation
    end

    // Monitor outputs
    initial begin
        $monitor("Time = %0t | clk = %b | reset = %b | load = %b | inc = %b | d = %h | q = %h", 
                  $time, clk, reset, load, inc, d, q);
    end
endmodule
