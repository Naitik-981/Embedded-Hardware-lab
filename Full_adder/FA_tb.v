`timescale 1ns / 1ps
module fa_tb; 

    reg a, b, cin; 
    wire s, cout; 

    // Instantiate the full adder module
    fa fa0 (.a(a), .b(b), .cin(cin), .s(s), .cout(cout)); 

    initial begin 
        a = 0; b = 0; cin = 0; 
        #50 a = 1; b = 0; cin = 0; 
        #50 a = 0; b = 1; cin = 0; 
        #50 a = 1; b = 1; cin = 0; 
        #50 a = 0; b = 0; cin = 1; 
        #50 a = 1; b = 0; cin = 1; 
        #50 a = 0; b = 1; cin = 1; 
        #50 a = 1; b = 1; cin = 1; 
        #50 a = 0; b = 0; cin = 0; 
    end 

endmodule
