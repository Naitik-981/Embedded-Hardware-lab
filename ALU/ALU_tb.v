`timescale 1ns/1ps

module alu_tb;
    reg [15:0] a, b;
    reg [4:0] f;
    wire [15:0] s;
    
    // Instantiate the ALU
    alu uut (
        .a(a),
        .b(b),
        .f(f),
        .s(s)
    );
    
    initial begin
        // Test case 1: ADD (a + b)
        a = 16'h0005; b = 16'h0003; f = 5'b00000; #10;
        $display("ADD: %h + %h = %h", a, b, s);
        
        // Test case 2: SUB (a - b)
        a = 16'h000A; b = 16'h0004; f = 5'b00001; #10;
        $display("SUB: %h - %h = %h", a, b, s);
        
        // Test case 3: AND (a & b)
        a = 16'h00FF; b = 16'h0F0F; f = 5'b00010; #10;
        $display("AND: %h & %h = %h", a, b, s);
        
        // Test case 4: OR (a | b)
        a = 16'h00F0; b = 16'h0F0F; f = 5'b00011; #10;
        $display("OR: %h | %h = %h", a, b, s);
        
        // Test case 5: XOR (a ^ b)
        a = 16'h00FF; b = 16'h0F0F; f = 5'b00100; #10;
        $display("XOR: %h ^ %h = %h", a, b, s);
        
        // Test case 6: NOT (~a)
        a = 16'hFFFF; b = 16'h0000; f = 5'b00101; #10;
        $display("NOT: ~%h = %h", a, s);
        
        // Test case 7: Shift Left (a << 1)
        a = 16'h0001; f = 5'b00110; #10;
        $display("Shift Left: %h << 1 = %h", a, s);
        
        // Test case 8: Shift Right (a >> 1)
        a = 16'h0002; f = 5'b00111; #10;
        $display("Shift Right: %h >> 1 = %h", a, s);
        
        $stop;
    end
endmodule
