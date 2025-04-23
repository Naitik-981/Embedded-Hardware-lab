`timescale 1ns / 1ps

module stack_tb;
    reg clk, reset, load, push, pop;
    reg [15:0] d;
    wire [15:0] qtop, qnext;

    // Instantiate the stack module
    stack uut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .push(push),
        .pop(pop),
        .d(d),
        .qtop(qtop),
        .qnext(qnext)
    );

    // Generate clock signal
    always #10 clk = ~clk; // 20ns period (50MHz)

    initial begin
        $dumpfile("stack_tb.vcd");
        $dumpvars(0, stack_tb);

        // Initialize signals
        clk = 0;
        reset = 1;
        load = 0;
        push = 0;
        pop = 0;
        d = 16'b0;

        // Apply Reset
        #20 reset = 0;
        #20 reset = 1; // Ensure reset is applied
        #20 reset = 0;

        // Push 3 values onto stack
        #20 d = 16'hAAAA; push = 1; #20 push = 0;
        #20 d = 16'hBBBB; push = 1; #20 push = 0;
        #20 d = 16'hCCCC; push = 1; #20 push = 0;

        // Pop 2 values from stack
        #20 pop = 1; #20 pop = 0;
        #20 pop = 1; #20 pop = 0;

        // Try popping beyond stack limit (should handle gracefully)
        #20 pop = 1; #20 pop = 0;
        #20 pop = 1; #20 pop = 0;

        // Push more values to test
        #20 d = 16'hDDDD; push = 1; #20 push = 0;
        #20 d = 16'hEEEE; push = 1; #20 push = 0;

        #100 $finish;
    end
endmodule
