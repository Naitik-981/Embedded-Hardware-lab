`timescale 1ns / 1ps

module fa (
    input a, b, cin,
    output s, cout
);
    // Sum calculation: s = a ⊕ b ⊕ cin
    assign s = a ^ b ^ cin;
    // Carry-out calculation: cout = (a & b) | (b & cin) | (a & cin)
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule
