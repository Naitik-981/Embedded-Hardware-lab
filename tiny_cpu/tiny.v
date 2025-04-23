`include "defs.v"

module tinycpu(clk, reset, run, in, cs, pcout, irout, qtop, abus, dbus, out);

    input clk, reset, run;
    input [15:0] in;
    output [2:0] cs;
    output [15:0] irout, qtop, dbus, out;
    output [11:0] pcout, abus;
    
    wire [15:0] qnext, ramout, aluout;
    reg [11:0] abus;
    reg halt, cont, pcinc, push, pop, abus2pc, dbus2ir, dbus2qtop, dbus2ram, dbus2obuf;
    reg pc2abus, ir2abus, ir2dbus, qtop2dbus, alu2dbus, ram2dbus, in2dbus;

    // Define instruction opcodes
    `define PUSHI  4'b0000
    `define PUSH   4'b0001
    `define POP    4'b0010
    `define JMP    4'b0011
    `define JZ     4'b0100
    `define JNZ    4'b0101
    `define IN     4'b0110
    `define OUT    4'b0111
    `define OP     4'b1000

    // Program Counter
    counter #(12) pc0(
        .clk(clk),
        .reset(reset),
        .load(abus2pc),
        .inc(pcinc),
        .d(abus),
        .q(pcout)
    );

    // Instruction Register
    counter #(16) ir0(
        .clk(clk),
        .reset(reset),
        .load(dbus2ir),
        .inc(0),
        .d(dbus),
        .q(irout)
    );

    // State Machine
    state state0(
        .clk(clk),
        .reset(reset),
        .run(run),
        .cont(cont),
        .halt(halt),
        .cs(cs)
    );

    // Stack
    stack stack0(
        .clk(clk),
        .reset(reset),
        .load(dbus2qtop),
        .push(push),
        .pop(pop),
        .d(dbus),
        .qtop(qtop),
        .qnext(qnext)
    );

    // ALU
    alu alu0(
        .a(qtop),
        .b(qnext),
        .f(irout[4:0]),
        .s(aluout)
    );

    // RAM
    ram #(16,12,4096) ram0(
        .clk(clk),
        .load(dbus2ram),
        .addr(abus),
        .d(dbus),
        .q(ramout)
    );

    // Output Buffer
    counter #(16) obuf0(
        .clk(clk),
        .reset(reset),
        .load(dbus2obuf),
        .inc(0),
        .d(dbus),
        .q(out)
    );

    // Address Bus Logic
    always @(pc2abus or ir2abus or pcout or irout) begin
        if (pc2abus)
            abus = pcout;
        else if (ir2abus)
            abus = irout[11:0];
        else
            abus = 12'hxxx;
    end

    // Data Bus Multiplexing
    assign dbus = ir2dbus  ? {{4{irout[11]}}, irout[11:0]} :
                  qtop2dbus ? qtop :
                  alu2dbus  ? aluout :
                  ram2dbus  ? ramout :
                  in2dbus   ? in : 16'hzzzz;

    // Control Logic
    always @(cs or irout or qtop) begin
        // Reset all control signals
        halt = 0; cont = 0; pcinc = 0; push = 0; pop = 0;
        abus2pc = 0; dbus2ir = 0; dbus2qtop = 0; dbus2ram = 0; dbus2obuf = 0;
        pc2abus = 0; ir2abus = 0; ir2dbus = 0; qtop2dbus = 0; alu2dbus = 0;
        ram2dbus = 0; in2dbus = 0;

        case (cs)
            `FETCHA: begin
                pcinc = 1;
                pc2abus = 1;
            end

            `FETCHB: begin
                ram2dbus = 1;
                dbus2ir = 1;
            end

            `EXECA: begin
                case (irout[15:12])
                    `PUSHI: begin
                        ir2dbus = 1;
                        dbus2qtop = 1;
                        push = 1;
                    end

                    `PUSH: begin
                        ir2abus = 1;
                        cont = 1;
                    end

                    `POP: begin
                        ir2abus = 1;
                        qtop2dbus = 1;
                        dbus2ram = 1;
                        pop = 1;
                    end

                    `JMP: begin
                        ir2abus = 1;
                        abus2pc = 1;
                    end

                    `JZ: begin
                        if (qtop == 0) begin
                            ir2abus = 1;
                            abus2pc = 1;
                        end
                        pop = 1;
                    end

                    `JNZ: begin
                        if (qtop != 0) begin
                            ir2abus = 1;
                            abus2pc = 1;
                        end
                        pop = 1;
                    end

                    `IN: begin
                        in2dbus = 1;
                        dbus2qtop = 1;
                        push = 1;
                    end

                    `OUT: begin
                        qtop2dbus = 1;
                        dbus2obuf = 1;
                        pop = 1;
                    end

                    `OP: begin
                        alu2dbus = 1;
                        dbus2qtop = 1;
                        if (irout[4] == 0) 
                            pop = 1;
                    end

                    default: halt = 1;
                endcase
            end

            `EXECB: begin
                if (irout[15:12] == `PUSH) begin
                    ram2dbus = 1;
                    dbus2qtop = 1;
                    push = 1;
                end
            end
        endcase
    end

endmodule
