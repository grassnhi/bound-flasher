`timescale 1ns/1ns

module bound_flasher_tb;

  // I/O
  reg rst;
  reg clk;
  reg flick;
  wire [15:0] leds;

  // Instantiate the bound_flasher module
  bound_flasher uut (
    .rst(rst),
    .clk(clk),
    .flick(flick),
    .LEDs(leds)
  );

  // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


  initial begin
    rst = 1;
    clk = 0;
    flick = 0;

//    $display("Test Case 1: Normal Operation");
//    #10 flick = 1; 
//    #10 flick = 0;
//    #600 flick = 0; 

    $display("Test Case 2: Flick at Kickback Points");    
    #10 flick = 1; 
    #100 flick = 0;
    #100 flick = 1; 
    #200 flick = 0;
    #200 flick = 1;
    #200 flick = 0;
    #200 flick = 1;
    
//    $display("Test Case 3: Multiple Resets and Flicking");
//    #20 flick = 1; 
//    #50 rst = 0; 
//    #20 rst = 1; 
//    #50 flick = 0; 
//    #20 flick = 1;
//    #50 flick = 0; 
//    #50 rst = 0;
//    #20 flick = 1;
//    #50 flick = 0;
//    #20 flick = 1;

    #10 $finish;
  end

endmodule
