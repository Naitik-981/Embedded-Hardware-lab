module tb;
  // Input ports declared as registers
  reg a, b, en;

  // Output port declared as wire
  wire [3:0] y;

  // Instantiate the design block
  decoder24_assign dut(en, a, b, y);

  initial
    begin
      $monitor("en=%b a=%b b=%b y=%b", en, a, b, y);
      
      // Provide input values according to the truth table
      en = 1; a = 1'bx; b = 1'bx; #5;
      en = 0; a = 0; b = 0; #5;
      en = 0; a = 0; b = 1; #5;
      en = 0; a = 1; b = 0; #5;
      en = 0; a = 1; b = 1; #5;
      
      // Terminate simulation using $finish system task
      $finish;
    end
endmodule
