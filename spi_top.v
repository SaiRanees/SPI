`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2023 16:04:50
// Design Name: 
// Module Name: spi_top
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


module spi_top(input wb_clk_in, wb_rst_in, wb_stb_in, wb_cyc_in, miso,
        input [4:0] wb_addr_in, [31:0] wb_data_in, [3:0] wb_sel_in,
        output sclk_out, mosi,
        output reg wb_ack_out, wb_int_out,
        output reg [31:0] wb_data_out,
        output [31:0] ss_pad_o);
        
        wire rx_negedge;
        wire tx_negedge;
        wire [3:0] spi_tx_sel, spi_rx_sel;
        wire [7:0] char_len;
        wire go, ie, ass;
        wire lsb;
        wire cpol_0, cpol_1, last, tip;
        wire spi_divider_sel, spi_ctrl_sel, spi_ss_sel;
        reg [31:0] divider;
        reg [31:0] wb_temp_data;
        reg [13:0] ctrl;
        reg [31:0] ss;
        wire [31:0] tx,rx;
        wire in,out;
        
        //Instantiate the SPI clock generator...............................
        spi_clkgen   clkgen(wb_clk_in, wb_rst_in, tip, go, last,divider[15:0],sclk_out, cpol_0, cpol_1);
        
        //Instantiate the SPI shift register................................
        spi_shiftreg shiftreg(sclk_out, cpol_0, cpol_1, wb_clk_in, wb_rst_in, rx_negedge, tx_negedge, lsb, go, miso,
        wb_sel_in, {spi_tx_sel[3:0] & {4{wb_we_in}}}, char_len, tx, spi_rx_sel, mosi, tip, last, rx);
        
        //Adress Decoder.....................................................
        assign spi_divider_sel = wb_cyc_in & wb_stb_in & {wb_addr_in == {5'b10100}};
        assign spi_ctrl_sel    = wb_cyc_in & wb_stb_in & {wb_addr_in == {5'b10000}};
        assign spi_ss_sel      = wb_cyc_in & wb_stb_in & {wb_addr_in == {5'b11000}};
        assign spi_tx_sel[0]   = wb_cyc_in & wb_stb_in & {wb_addr_in == {5'b00000}};
        assign spi_tx_sel[1]   = wb_cyc_in & wb_stb_in & {wb_addr_in == {5'b00100}};
        assign spi_tx_sel[2]   = wb_cyc_in & wb_stb_in & {wb_addr_in == {5'b01000}};
        assign spi_tx_sel[3]   = wb_cyc_in & wb_stb_in & {wb_addr_in == {5'b01100}};
        assign spi_rx_sel[0]   = {wb_addr_in == {5'b00000}};
        assign spi_rx_sel[1]   = {wb_addr_in == {5'b00100}};
        assign spi_rx_sel[2]   = {wb_addr_in == {5'b01000}};
        assign spi_rx_sel[3]   = {wb_addr_in == {5'b01100}};
        
        
        //Read from Registers................................................
        always@(*) begin
        case(wb_addr_in)
        5'b00000 : wb_temp_data = rx;
        5'b00100 : wb_temp_data = rx;
        5'b01000 : wb_temp_data = rx;
        5'b01100 : wb_temp_data = rx;
        5'b10000 : wb_temp_data = ctrl;
        5'b10100 : wb_temp_data = divider;
        5'b11000 : wb_temp_data = ss;
        default : wb_temp_data = 32'dx;
        endcase
        end
        
        //Sending Data to the SPI shift register.............................
        assign tx = (|spi_tx_sel) ? wb_data_in : 32'd0;
        
        //WB Data out........................................................
        always @(posedge wb_clk_in, posedge wb_rst_in) begin
        if (wb_rst_in) wb_data_out <= 32'd0;
        else wb_data_out <= wb_temp_data;
        end
        
        //WB Acknowledgement.................................................
        always @(posedge wb_clk_in, posedge wb_rst_in) begin
        if (wb_rst_in) wb_ack_out <= 0;
        else wb_ack_out <= wb_cyc_in & wb_stb_in & ~wb_ack_out;
        end
        
        //Interrupt..........................................................
        always @(posedge wb_clk_in, posedge wb_rst_in) begin
        if (wb_rst_in) wb_int_out <= 1'b0;
        else if (ie & tip & last & cpol_0) wb_int_out <= 1'b1;
        else if (wb_ack_out) wb_int_out <= 1'b0;
        end
        
        //Divide Register....................................................
        always @(posedge wb_clk_in, posedge wb_rst_in) begin
        if (wb_rst_in) divider <= 0;
        else if (spi_divider_sel && wb_we_in && !tip)
                begin
                if (wb_sel_in[0]) divider[7:0] <= wb_data_in[7:0];
                if (wb_sel_in[1]) divider[15:8] <= wb_data_in[15:8];
                if (wb_sel_in[2]) divider[23:16] <= wb_data_in[23:16];
                if (wb_sel_in[3]) divider[31:24] <= wb_data_in[31:24];
                end
        end
        
        //Control ans Status Register.........................................
        always @(posedge wb_clk_in, posedge wb_rst_in) begin
        if (wb_rst_in) ctrl <= 0;
        else if (spi_ctrl_sel & wb_we_in & !tip) ctrl <= wb_data_in[13:0];
        else if (tip && last && cpol_0) ctrl[8] <= 1'b0;
        end
        
        assign rx_negedge = ctrl[9];
        assign tx_negedge = ctrl[10];
        assign lsb = ctrl[11];
        assign ie = ctrl[12];
        assign ass = ctrl[13];
        assign go = ctrl[8];
        assign char_len = ctrl[6:0];
        
        always @(posedge wb_clk_in, posedge wb_rst_in) begin
        if (wb_rst_in) ss <= 0;
        else if (spi_ss_sel & wb_we_in & !tip)
                begin
                if(wb_sel_in[0]) ss <= wb_data_in[7:0];
                if(wb_sel_in[1]) ss <= wb_data_in[15:8];
                if(wb_sel_in[2]) ss <= wb_data_in[23:16];
                if(wb_sel_in[3]) ss <= wb_data_in[31:24];
                end
        end
        
        assign ss_pad_o = ss;
                
endmodule
