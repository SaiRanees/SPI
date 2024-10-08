`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2023 18:44:03
// Design Name: 
// Module Name: wishbone_master
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


module wishbone_master(input clk_in, rst_in, ack_in,
        input [31:0] data_in,
        output reg [4:0] addr_out,
        output reg cyc_out, stb_out, we_out,
        output reg [31:0] data_out,
        output reg [3:0] sel_out);
        
        //Internals Signals........................................
        integer addr_temp, sel_temp, data_temp;
        reg we_temp, cyc_temp, stb_temp;
        
        //Initialize task..........................................
        task initialize;
            begin
            {addr_temp, sel_temp, data_temp, we_temp, cyc_temp, stb_temp} = 0;
            end
        endtask
        
        //Wishbone Bus cycle single Read/Write
        task single_write;
        input [4:0] addr;
        input [31:0] data;
        input [3:0] sel;
            begin
            @(negedge clk_in);
            addr_temp = addr;
            sel_temp  = sel;
            we_temp   = 1;
            data_temp = data;
            cyc_temp  = 1;
            stb_temp  = 1;
            @(negedge clk_in);
            wait(~ack_in)
            @(negedge clk_in);
            addr_temp = 5'dz;
            sel_temp  = 4'd0;
            we_temp   = 1'b0;
            data_temp = 32'dz;
            cyc_temp  = 1'b0;
            stb_temp  = 1'b0;
            end
        endtask
        
        always @(posedge clk_in) begin
        addr_out <= addr_temp;
        end
        
        always @(posedge clk_in) begin
        we_out <= we_temp;
        end
        
        always @(posedge clk_in) begin
        data_out <= data_temp;
        end
        
        always @(posedge clk_in) begin
        sel_out <= sel_temp;
        end
        
        always @(posedge clk_in) begin
        if (rst_in) cyc_out <= 0;
        else cyc_out <= cyc_temp;
        end
        
        always @(posedge clk_in) begin
        if(rst_in) stb_out <= 0;
        else stb_out <= stb_temp;
        end
                
endmodule
