`define IDLE   3'b000
`define FETCHA 3'b001
`define FETCHB 3'b010
`define EXECA  3'b011
`define EXECB  3'b100

module fetch(clk, reset, run, cs, pcout, irout, ramout, abus, dbus, out);

    input clk, reset, run;
    output [2:0] cs;
    output [7:0] abus, pcout;
    output [15:0] irout, ramout, dbus, out;
    
    reg [7:0] abus;
    wire halt, read, write;

    // Program Counter
    counter #(8) pc0(
        .clk(clk), .reset(reset), .load(1'b0), 
        .inc(cs == `FETCHA), .d(8'b0), .q(pcout)
    );

    // Instruction Register
    counter #(16) ir0(
        .clk(clk), .reset(reset), .load(cs == `FETCHB), 
        .inc(1'b0), .d(dbus), .q(irout)
    );

    // State Machine
    state state0(
        .clk(clk), .reset(reset), .run(run), .halt(halt), .cont(read), .cs(cs)
    );

    // RAM
    ram #(16, 8, 256) ram0(
        .clk(clk), .load(cs == `EXECA && write), 
        .addr(abus), .d(dbus), .q(ramout)
    );

    // Output Buffer
    counter #(16) obuf0(
        .clk(clk), .reset(reset), .load(cs == `EXECB), 
        .inc(1'b0), .d(dbus), .q(out)
    );

    // Control Signals
    assign halt  = (irout == 16'h0000);
    assign read  = (irout[15:8] != 8'h00 && irout[7:0] == 8'h00);
    assign write = (!halt && !read);

    // Address Bus
    always @(*) begin
        if (cs == `FETCHA) abus = pcout;
        else if (cs == `EXECA) abus = irout[15:8];
        else abus = 8'hxx;
    end

    // Data Bus
    assign dbus = (cs == `FETCHB || cs == `EXECB) ? ramout :
                  (cs == `EXECA) ? {8'h00, irout[7:0]} :
                  16'hzzzz;

endmodule
