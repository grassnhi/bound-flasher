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

    $display("Test Case 1: Normal Operation");
    #10 flick = 1; 
    #10 flick = 0;
    #600 flick = 1; 
    #10 rst = 0; 
    #10 rst = 1;
    #10 flick = 1;
    #10 flick = 0;
    #600 rst = 0; 
    #10 rst = 1;

    $display("Test Case 2: Flick at LEDs[5] of ON_0_TO_10");    
    #10 flick = 1; 
    #100 flick = 0;
    #50 flick = 1; // here
    #50 flick = 0;
    #600 rst = 0; 
    #10 rst = 1;
    
    $display("Test Case 3: Flick at LEDs[10] of ON_0_TO_10");
    #10 flick = 1; 
    #10 flick = 0;
    #200 flick = 1; // here
    #150 flick = 0;
    #500 rst = 0; 
    #10 rst = 1;
    
    $display("Test Case 4: Flick at LEDs[5] of ON_5_TO_15");
    #10 flick = 1; 
    #10 flick = 0;
    #250 flick = 1; // here
    #100 flick = 0;
    #400 rst = 0; 
    #10 rst = 1;
    
    $display("Test Case 5: Flick at LEDs[10] of ON_5_TO_15");
    #10 flick = 1; 
    #10 flick = 0;
    #300 flick = 1;
    #50 flick = 0;
    #400 rst = 0; 
    #10 rst = 1;
    
    $display("Test Case 6: Flick at LEDs[5] then LEDs[10] of ON_5_TO_10");
    #10 flick = 1; 
    #100 flick = 0;
    #50 flick = 1; // here
    #50 flick = 0;
    #150 flick = 1; // here
    #50 flick = 0;
    #600 rst = 0; 
    #10 rst = 1;

    $display("Test Case 7: Flick at LEDs[5] and then LEDs[10] of ON_5_TO_15");
    #10 flick = 1; 
    #10 flick = 0;
    #250 flick = 1; // here
    #100 flick = 0;
    #50 flick = 1; // here
    #50 flick = 0;
    #400 rst = 0; 
    #10 rst = 1;
    
    $display("Test Case 8: Flick at certain LEDs[5] and LEDs[10] of ON states");
    #10 flick = 1; 
    #100 flick = 0;
    #50 flick = 1; // here
    #50 flick = 0;
    #150 flick = 1; // here
    #50 flick = 0;
    #250 flick = 1; // here
    #150 flick = 0;
    #100 flick = 1; // here
    #50 flick = 0;
    #200 rst = 0; 
    #10 rst = 1;

    $display("Test Case 9: Flick signal at any time slot (not kickback point)");
    #20 flick = 1;
    #20 flick = 0;
    #50 flick = 1;
    #20 flick = 0;
    #50 flick = 1;
    #20 flick = 0;
    #50 flick = 1;
    #20 flick = 0;
    #80 flick = 1;
    #30 flick = 0;
    #20 flick = 1;
    #50 flick = 0;
    #200 rst = 0; 
    #10 rst = 1;
    
    $display("Test Case 10: Reset signal at any time slot (not kickback point)");
    #50 rst = 0; 
    #10 rst = 1;
    #10 flick = 1;
    #10 flick = 0;
    #100 rst = 0; 
    #20 rst = 1;
    #10 flick = 1;
    #10 flick = 0;    
    #300 rst = 0;
    #20 rst = 1;
    #10 flick = 1;
    #10 flick = 0;    
    #50 rst = 0;
    #100 rst = 1;
    
    $display("Test Case 11: Multiple Resets and Flicking");
    #10 flick = 1; 
    #50 rst = 0; 
    #20 rst = 1; 
    #20 flick = 0; 
    #70 flick = 1;
    #20 flick = 0; 
    #20 rst = 0;
    #10 flick = 1;
    #10 flick = 0;
    #10 flick = 1;
    #20 rst = 1; 
    #80 flick = 0;
    #250 flick = 1; 
    #150 rst = 0;
    #100 rst = 1;
    
    $display("Test Case 12: Reset signal with flick signal at kickback point.");
    #10 flick = 1;
    #60 rst = 0;
    #10 rst = 1; 
    #10 flick = 0;
    #250 flick = 1;
    #80 rst = 0;
    #50 rst = 1; 

    $display("Test Case 13: Flick signal at the OFF states");
    #10 flick = 1;
    #10 flick = 0;
    #60 flick = 1;
    #10 flick = 0;
    #10 flick = 1;
    #50 flick = 0;
    #300 flick = 1;
    #80 flick = 0;
    #80 flick = 1;
    #10 flick = 0;
    #10 rst = 0;
    #10 rst = 1;
    
    $display("Test Case 14: Flick signal is randomly active");
    #10 flick = 1;
    #10 flick = 0;
    #20 flick = 1;
    #30 flick = 0;
    #40 flick = 1;
    #50 flick = 0;
    #60 flick = 1;
    #70 flick = 0;
    repeat (20) begin
      #20 flick = ~flick;
    end
    #400 rst = 0; 
    #10 rst = 1;
    
    $display("Test Case 15: Reset signal is randomly active");
    #10 rst = 0;
    #10 rst = 1;
    #10 flick = 1;
    repeat (10) begin
      #20 rst = ~rst;
    end 
    #10 flick = 0; 
    #100 rst = 0;
    repeat (5) begin
      #20 rst = ~rst;
    end   
    #10 rst = 1;
    #10 flick = 1;
    #10 flick = 0;
    #400 rst = 0; 
    #10 rst = 1;
    
    #50 $finish;
  end

initial begin
  $recordfile ("waves");
  $recordvars ("depth=0", bound_flasher_tb);
end

endmodule
