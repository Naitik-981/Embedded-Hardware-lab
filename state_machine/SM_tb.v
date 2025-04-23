`timescale 1ns/1ps

module state_tb;

    reg clk, reset, run, halt, cont;
    wire [2:0] cs;

    // Instantiate the state machine module
    state state0 (.clk(clk), .reset(reset), .run(run), .cont(cont), .halt(halt), .cs(cs));

    // Clock generation
    initial begin
        clk = 0;
        forever #50 clk = ~clk; // Toggle clock every 50 ns
    end

    // Stimulus
    initial begin
        reset = 0; run = 0; halt = 0; cont = 0;

        #100 reset = 1; run = 1; // Start running
        #200 run = 0;  // Stop run
        #300 cont = 1; // Continue execution
        #150 cont = 0;
        #600 halt = 1; // Halt state
        #150 halt = 0;

        #100 $finish; // End simulation
    end

    // Monitor outputs
    initial begin
        $monitor("Time = %0t | clk = %b | reset = %b | run = %b | cont = %b | halt = %b | cs = %b", 
                 $time, clk, reset, run, cont, halt, cs);
    end

endmodule
