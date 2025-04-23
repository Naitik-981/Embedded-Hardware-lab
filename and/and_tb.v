// Code your testbench here
// or browse Examples
module AND_Gate_tb;
  reg A;
  reg B;
  wire Y;
  integer i;
  
  AND_Gate inst(.A(A), .B(B), .Y(Y));
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #100 $finish;
  end
  
  initial 
    begin
      A <= 0;
      B <= 0;
      $monitor ("A=%0b B=%0b Y=%0b", A, B, Y);
      for (i=0; i< 4; i= i + 1)
        begin
          {A, B} = i;
      #10;
        end 
    end
   
endmodule