`timescale 1ns/1ps

module ff_tb;
    reg clk, reset, d;
    wire q;

    // Instantiate the flip-flop module
    ff ff0 (.clk(clk), .reset(reset), .d(d), .q(q));

    // Clock generation
    initial begin
        clk = 0;
        forever #50 clk = ~clk; // Toggle clock every 50 ns
    end

    // Stimulus
    initial begin
        reset = 0; d = 0;
        #10 reset = 1; d = 1;
        #20 d = 0;
        #20 d = 1;
        #10 reset = 0;  // Assert reset
        #10 reset = 1;  // Deassert reset
        #20 d = 1;
        #10 d = 0;
        #10 $finish;  // End simulation
    end

    // Monitor outputs
    initial begin
        $monitor("Time = %0t | clk = %b | reset = %b | d = %b | q = %b", 
                  $time, clk, reset, d, q);
    end
endmodule
