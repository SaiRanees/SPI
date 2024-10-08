module spi_clk_gen (
    input wb_clk_in,
    input wire wb_rst,
    output reg tip,
    input wire go,
    output reg sclk_out,
    output reg cpol_0,
    output reg cpol_1,
    output wire [2:0] divider // 2-bit divider output
);

// Define registers for counting cycles
reg [2:0] cnt = 3'b001; // Initialize cnt to 001
reg [2:0] divider_internal = 3'b000; // Initialize internal divider

// Reset and clocked logic
always @(posedge wb_clk_in or posedge wb_rst) begin
    if (wb_rst) begin
        // Reset logic
        cnt <= 3'b001;
        sclk_out <= 1'b0;
        cpol_0 <= 1'b0;
        cpol_1 <= 1'b0;
        divider_internal <= 3'b000; // Initialize internal divider to 0
    end else begin
        // Generate serial clock
        if (go) begin
            if (cnt == 3'b101) begin // 5 cycles
                cnt <= 3'b001;
                sclk_out <= ~sclk_out;
                cpol_0 <= 1'b0; // Set cpol_0 to 0 in the same cycle as sclk_out changes
                if (sclk_out == 1'b1) begin
                    cpol_1 <= 1'b1; // Set cpol_1 to 1 just before the rising edge
                end else begin
                    cpol_1 <= 1'b0;
                end
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
        
        // Increment the internal divider
        if (divider_internal < 3'b101) begin
            divider_internal = divider_internal; 
        end 
    end
end

// Generate cpol_1 and cpol_0
always @(posedge wb_clk_in) begin
    // Generate cpol_1
    if (sclk_out == 1'b1) begin
        if (cnt == 3'b100) begin
            cpol_1 <= 1'b1; // Set cpol_1 to 1 at cnt = 4 when sclk_out is high
        end else if (cnt == 3'b101) begin
            cpol_1 <= 1'b0; // Set cpol_1 to 0 at cnt = 5 when sclk_out is high
        end
    end else begin
        cpol_1 <= cpol_1; // Maintain the previous value for all other cycles when sclk_out is low
    end

    // Generate cpol_0
    if (sclk_out == 1'b0) begin
        if (cnt == 3'b100) begin
            cpol_0 <= 1'b1; // Set cpol_0 to 1 at cnt = 4 when sclk_out is low
        end else if (cnt == 3'b101) begin
            cpol_0 <= 1'b0; // Set cpol_0 to 0 at cnt = 5 when sclk_out is low
        end
    end else begin
        cpol_0 <= cpol_0; // Maintain the previous value for all other cycles when sclk_out is high
    end
end

// Clock divider logic with a 10ns delay
always @(posedge wb_clk_in or posedge wb_rst) begin
    tip <= wb_clk_in; // No divider
    if (wb_rst) begin
        // Reset divider after 10ns
        #10 divider_internal <= 3'b100; // Set divider to 100 after 10ns
    end
end

// Output the divider value
assign divider = divider_internal;

endmodule
