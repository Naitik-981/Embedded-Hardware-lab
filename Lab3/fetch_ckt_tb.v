`timescale 1ns / 1ps

module fetch_tb;

    reg clk, reset, run;
    wire [2:0] cs;
    wire [7:0] pcout, abus;
    wire [15:0] irout, ramout, dbus, out;

    // Instantiate the fetch module
    fetch fetch0(
        .clk(clk), .reset(reset), .run(run),
        .cs(cs), .pcout(pcout), .irout(irout), .ramout(ramout),
        .abus(abus), .dbus(dbus), .out(out)
    );

    // Generate Clock
    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end

    // Stimulus
    initial begin
        reset = 0; run = 0;
        #100 reset = 1; run = 1;  // Start Fetch
        #100 run = 0;  // Stop Fetch
        #200 $finish;  // End simulation
    end

    // Monitor Outputs
    initial begin
        $monitor("Time: %0t | clk=%b | reset=%b | run=%b | cs=%b | pcout=%h | irout=%h | ramout=%h | abus=%h | dbus=%h | out=%h", 
                  $time, clk, reset, run, cs, pcout, irout, ramout, abus, dbus, out);
    end

endmodule
