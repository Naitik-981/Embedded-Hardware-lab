module alu (
    input [15:0] a, b,
    input [4:0] f, // Operation code (from instruction)
    output reg [15:0] s
);
    always @(*) begin
        case (f)
            5'b00000: s = a + b; // ADD
            5'b00001: s = a - b; // SUB
            5'b00010: s = a & b; // AND
            5'b00011: s = a | b; // OR
            5'b00100: s = a ^ b; // XOR
            5'b00101: s = ~a;    // NOT
            5'b00110: s = a << 1;// Shift Left
            5'b00111: s = a >> 1;// Shift Right
            default:  s = 16'h0000;
        endcase
    end
endmodule
