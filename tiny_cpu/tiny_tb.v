`timescale 1ns / 1ps

module tinycpu_tb;

    reg clk, reset, run;
    reg [15:0] in;
    wire [2:0] cs;
    wire [15:0] irout, qtop, dbus, out;
    wire [11:0] pcout, abus;

    // Instantiate the DUT (Device Under Test)
    tinycpu tinycpu0(
        .clk(clk),
        .reset(reset),
        .run(run),
        .in(in),
        .cs(cs),
        .pcout(pcout),
        .irout(irout),
        .qtop(qtop),
        .abus(abus),
        .dbus(dbus),
        .out(out)
    );

    // Clock Generation (50 ns period -> 20 MHz frequency)
    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end

    // Stimulus Block
    initial begin
        reset = 1; 
        run = 0; 
        in = 16'd3; 

        #100 reset = 0;   // Apply Reset
        #50 reset = 1;    // Release Reset
        #50 run = 1;      // Start CPU
        #200 run = 0;     // Stop after some time

        #500 $finish;     // End Simulation
    end

endmodule
