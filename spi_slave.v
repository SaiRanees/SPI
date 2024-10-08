`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2023 19:23:33
// Design Name: 
// Module Name: spi_slave
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module spi_slave(input sclk,mosi,
        input [31:0]ss_pad_o,
        output miso);
        
        reg rx_slave;
        reg tx_slave;
        
        //Initial Value of temp is 0
        reg [127:0] temp1 = 0;
        reg [127:0] temp2 = 0;
        
        reg miso1 = 1'b0;
        reg miso2 = 1'b1;
        
        always @(posedge sclk) begin
        if ((ss_pad_o != {32{1'd1}}) && ~rx_slave && tx_slave) temp1 <= {temp1[126:0],mosi};
        end
        
        always @(negedge sclk) begin
        if ((ss_pad_o != {32{1'd1}}) && rx_slave && ~tx_slave) temp2 <= {temp2[126:0],mosi};
        end
        
        always @(negedge sclk) begin
        if (rx_slave && ~tx_slave) miso1 <= temp1[127];
        end
        
        always @(posedge sclk) begin
        if (~rx_slave && tx_slave) miso2 <= temp2[127];
        end
        
        assign miso = miso1 || miso2;
        
        
endmodule
