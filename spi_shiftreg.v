`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.10.2023 14:53:20
// Design Name: 
// Module Name: spi_shiftreg
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


module spi_shiftreg(input sclk, cpol_0, cpol_1, wb_clk, wb_rst, rx_negedge, tx_negedge, lsb, go, miso,
        input [3:0] byte_sel,latch,
        input [7:0] len, // [SPI_CHAR_LEN_BITS - 1:0]
        input [31:0] pin,
        input [3:0] latch1,
        output reg mosi, tip,
        output last, reg [31:0] pout);
        
        reg [8:0] char_count; // [SPI_CHAR_LEN_BITS:0]
        reg [127:0] master_data; // [SPI_MAX_CHAR - 1:0]         // Shift Register
        wire [7:0] tx_bit_pos; // [SPI_CHAR_LEN_BITS - 1:0]    // Next bit position
        wire [7:0] rx_bit_pos; // [SPI_CHAR_LEN_BITS - 1:0]    // Next bit position
        wire tx_clk, rx_clk;
        wire [8:0] char_count_1;
        
        //Character Bit Counter...................................................
        always @(posedge wb_clk, posedge wb_rst) begin
        if (wb_rst) char_count <= 0;
        else if (tip) begin
        if (cpol_0) char_count <= char_count-1;
        end
        else char_count <= {1'b0,len};
        end
        
        //Calculate TIP...........................................................
        always@(posedge wb_clk, posedge wb_rst) begin
        if (wb_rst) tip <= 0;
        else if (go && ~tip) tip <= 1;
        else if (last && tip && cpol_0) tip <= 0;
        end
        
        //calculate last..........................................................
        assign last = ~(|char_count);
        
        //calculate tx_clk, nx_clk................................................
        assign tx_clk = ((tx_negedge) ? cpol_1 : cpol_0) && tip;
        assign rx_clk = ((rx_negedge) ? cpol_1 : cpol_0) && tip;
        
        //Calculate the Serial Out................................................
        always @(posedge wb_clk, posedge wb_rst) begin
        if (wb_rst) mosi <= 0;
        else if (tx_clk) mosi <= master_data[tx_bit_pos];
        end
        
        //Calculate the Serial in.................................................
        always@(posedge wb_clk) begin
        if(rx_clk && !wb_rst) master_data[rx_bit_pos] <= miso;
        end
        
        assign char_count_1 = char_count;
        
        //Calculate tx_bit_pos, rx_bit_pos........................................
        assign tx_bit_pos = lsb ? {!(|len), len} - char_count_1 : char_count_1;
        assign rx_bit_pos = lsb ? {!(|len), len} - char_count_1 : char_count_1;
        
        
        
        //Data In.................................................................
        always@(posedge wb_clk, posedge wb_rst) begin
        if(wb_rst) master_data <= {128{1'b0}};
        else if (latch[0] && !tip) begin
                if(byte_sel[0]) master_data[7:0] <= pin[7:0];
                if(byte_sel[1]) master_data[15:8] <= pin[15:8];
                if(byte_sel[2]) master_data[23:16] <= pin[23:16];
                if(byte_sel[3]) master_data[31:24] <= pin[31:24];     
        end
        else if (latch[1] && !tip) begin
                if(byte_sel[0]) master_data[39:32] <= pin[7:0];
                if(byte_sel[1]) master_data[47:40] <= pin[15:8];
                if(byte_sel[2]) master_data[55:48] <= pin[23:16];
                if(byte_sel[3]) master_data[63:56] <= pin[31:24];     
        end
        else if (latch[2] && !tip) begin
                if(byte_sel[0]) master_data[71:64] <= pin[7:0];
                if(byte_sel[1]) master_data[79:72] <= pin[15:8];
                if(byte_sel[2]) master_data[87:80] <= pin[23:16];
                if(byte_sel[3]) master_data[95:88] <= pin[31:24];     
        end
        else if (latch[3] && !tip) begin
                if(byte_sel[0]) master_data[103:96] <= pin[7:0];
                if(byte_sel[1]) master_data[111:104] <= pin[15:8];
                if(byte_sel[2]) master_data[119:112] <= pin[23:16];
                if(byte_sel[3]) master_data[127:120] <= pin[31:24];     
        end
        end
        
        //Data Out................................................................
        always@(posedge wb_clk, posedge wb_rst) begin
        if(wb_rst) pout <= {32{1'b0}};
        else if (latch1[0] && !tip) begin
                if(byte_sel[0]) pout[7:0] <= master_data[7:0];
                if(byte_sel[1]) pout[15:8] <= master_data[15:8];
                if(byte_sel[2]) pout[23:16] <= master_data[23:16];
                if(byte_sel[3]) pout[31:24] <= master_data[31:24];
        end
        else if (latch1[1] && !tip) begin
                if(byte_sel[0]) pout[7:0] <= master_data[39:32];
                if(byte_sel[1]) pout[15:8] <= master_data[47:40];
                if(byte_sel[2]) pout[23:16] <= master_data[55:48];
                if(byte_sel[3]) pout[31:24] <= master_data[63:56];     
        end
        else if (latch1[2] && !tip) begin
                if(byte_sel[0]) pout[7:0] <= master_data[71:64];
                if(byte_sel[1]) pout[15:8] <= master_data[79:72];
                if(byte_sel[2]) pout[23:16] <= master_data[87:80];
                if(byte_sel[3]) pout[31:24] <= master_data[95:88];    
        end
        else if (latch1[3] && !tip) begin
                if(byte_sel[0]) pout[7:0] <= master_data[103:96];
                if(byte_sel[1]) pout[15:8] <= master_data[111:104];
                if(byte_sel[2]) pout[23:16] <= master_data[119:112];
                if(byte_sel[3]) pout[31:24] <= master_data[127:120];     
        end
        end
        
endmodule
