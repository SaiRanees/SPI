`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2023 16:09:31
// Design Name: 
// Module Name: spi_clkgen
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


module spi_clkgen(input wb_clk, wb_rst, tip, go, last_clk, [15:0] divider,
        output reg sclk_out, cpol_0, cpol_1);
        
        reg [15:0] cnt;
        //counter design
        always @(posedge wb_clk, posedge wb_rst) begin
        if(wb_rst) cnt <= 16'd1;
        else if (tip & go) begin
        if (cnt == divider+1) cnt <= 16'd1;
        else cnt <= cnt + 1;
        end
        else begin 
        if (cnt == 0) cnt <= 16'd1;
        end
        end
        //Serial Clock Design
        always @(posedge wb_clk, posedge wb_rst) begin
        if (wb_rst) sclk_out <= 0;
        else if(tip & go) begin
        if (cnt == divider + 1) begin
        if(!last_clk | sclk_out) begin
        sclk_out <= !sclk_out;
        end
        end
        end
        end
        //CPOL_0
        always @(posedge wb_clk, posedge wb_rst) begin
        if (wb_rst) cpol_0 <= 0;
        else begin
        if (tip & go) begin
        if (!sclk_out) begin
        if (cnt == divider) cpol_0 <= 1;
        else cpol_0 <= 0;
        end
        end
        end
        end
        //CPOL_1
        always @(posedge wb_clk, posedge wb_rst) begin
        if (wb_rst) cpol_1 <= 0;
        else begin
        if (tip & go) begin
        if (sclk_out) begin
        if (cnt == divider) cpol_1 <= 1;
        else cpol_1 <= 0;
        end
        end
        end
        end
endmodule
