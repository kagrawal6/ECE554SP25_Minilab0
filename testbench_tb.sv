`timescale 1ns/1ps

module testbench_tb;

  // Clock and reset
  reg clk;
  reg rst_n;
  
  // Inputs to DUT
  reg [9:0] SW;
  reg [3:0] KEY;
  
  // Outputs from DUT
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  wire [9:0] LEDR;

  // Instantiate the DUT (Device Under Test)
  Minilab0 dut (
    .CLOCK_50(clk),
    .CLOCK2_50(clk),
    .CLOCK3_50(clk),
    .CLOCK4_50(clk),
    .HEX0(HEX0),
    .HEX1(HEX1),
    .HEX2(HEX2),
    .HEX3(HEX3),
    .HEX4(HEX4),
    .HEX5(HEX5),
    .LEDR(LEDR),
    .KEY(KEY),
    .SW(SW)
  );

  // Clock generation: 50 MHz = 20ns period
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  // Test sequence
  initial begin
    // Initialize inputs
    SW = 10'b0;
    KEY = 4'b1111;  // All keys released (active low)
    
    // Apply reset (KEY[0] is active low reset)
    KEY[0] = 1'b0;
    #100;
    KEY[0] = 1'b1;  // Release reset
    
    // Wait for state machine to complete
    // FILL state: 8 cycles to fill FIFO
    // EXEC state: 8 cycles to process
    // Then DONE state
    #500;
    
    // Turn on SW[0] to display result
    SW[0] = 1'b1;
    
    // Wait and observe
    #200;
    
    // Check if we're in DONE state (LEDR[1:0] should be 2)
    if (LEDR[1:0] == 2'd2) begin
      $display("SUCCESS: State machine reached DONE state");
      $display("LEDR = %b", LEDR);
      $display("MAC output displayed on 7-segment displays");
    end
    else begin
      $display("ERROR: State machine did not reach DONE state");
      $display("Current state (LEDR[1:0]) = %d", LEDR[1:0]);
    end
    
    // Display the MAC result
    // Expected: dot product of [0,5,10,15,20,25,30,35] and [0,10,20,30,40,50,60,70]
    // = 0 + 50 + 200 + 450 + 800 + 1250 + 1800 + 2450 = 7000 = 0x1B58
    $display("Expected result: 7000 (0x1B58)");
    
    #100;
    $finish;
  end

  // Monitor state changes
  initial begin
    $monitor("Time=%0t | State=%d | SW[0]=%b | LEDR=%b", 
             $time, LEDR[1:0], SW[0], LEDR);
  end

endmodule
