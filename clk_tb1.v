module tb_spi_clk_gen;

  // Inputs
  reg wb_clk_in = 1'b0; // Initialize to a known value
  reg wb_rst = 1'b1; // Initialize with reset active
  reg go = 1'b0;
  wire [2:0] divider; // Declare divider as an output wire

  // Outputs
  wire tip;
  wire sclk_out;
  wire cpol_0;
  wire cpol_1;

  // Instantiate the spi_clk_gen module
  spi_clk_gen uut (
    .wb_clk_in(wb_clk_in),
    .wb_rst(wb_rst),
    .tip(tip),
    .go(go),
    .sclk_out(sclk_out),
    .cpol_0(cpol_0),
    .cpol_1(cpol_1),
    .divider(divider) // Pass the divider signal
  );

  // Clock generation logic to simulate the clock divider
  always begin
    #5; // Delay for simulation purposes
    wb_clk_in = ~wb_clk_in; // Toggle the clock
  end

  // Testbench logic
  initial begin
    // Release reset after a delay
    #10;
    wb_rst = 1'b0;
    
    // Start clock generation by setting go to 1
    go = 1'b1;
    
    // Simulate clock cycles to observe sclk_out and cpol_0/cpol_1
    #10000;
    
    // Finish the simulation after some time
    $finish;
  end

endmodule
