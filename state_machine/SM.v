`define IDLE   3'b000
`define FETCHA 3'b001
`define FETCHB 3'b010
`define EXECA  3'b011
`define EXECB  3'b100

module state(clk, reset, run, cont, halt, cs);
    
    input clk, reset, run, cont, halt;
    output reg [2:0] cs; // Declare output as reg for sequential logic

    always @(posedge clk or negedge reset) begin
        if (!reset)
            cs <= `IDLE;  // Corrected macro usage
        else
            case (cs)
                `IDLE: if (run) cs <= `FETCHA;
                `FETCHA: cs <= `FETCHB;
                `FETCHB: cs <= `EXECA;
                `EXECA: 
                    if (halt) cs <= `IDLE;
                    else if (cont) cs <= `EXECB;
                    else cs <= `FETCHA;
                `EXECB: cs <= `FETCHA;
                default: cs <= 3'bxxx; // Corrected binary representation
            endcase
    end

endmodule
