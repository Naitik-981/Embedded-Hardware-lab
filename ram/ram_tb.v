`timescale 1ns / 1ps

module ram_tb;

    parameter WIDTH = 16;
    parameter ADDR_WIDTH = 12;
    parameter DEPTH = 4096;

    reg clk, load;
    reg [ADDR_WIDTH-1:0] addr;
    reg [WIDTH-1:0] d;
    wire [WIDTH-1:0] q;

    // Instantiate RAM module
    ram #(WIDTH, ADDR_WIDTH, DEPTH) uut (
        .clk(clk),
        .load(load),
        .addr(addr),
        .d(d),
        .q(q)
    );

    // Clock generation
    always #5 clk = ~clk; // Generate a 10ns clock period

    initial begin
        // Initialize signals
        clk = 0;
        load = 0;
        addr = 0;
        d = 0;

        // Apply test cases
        #10;
        load = 1; addr = 12'h005; d = 16'hABCD; // Write value ABCD at address 5
        #10;
        load = 0; addr = 12'h005; // Read from address 5
        #10;
        load = 1; addr = 12'h00A; d = 16'h1234; // Write value 1234 at address A
        #10;
        load = 0; addr = 12'h00A; // Read from address A
        #10;

        // Finish simulation
        $stop;
    end

endmodule
