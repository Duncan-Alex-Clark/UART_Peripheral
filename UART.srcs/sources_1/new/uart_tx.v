`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2025 06:14:47 PM
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
    input wire clk, // May not be necessary if I have the baud_clk input
    input wire rst,
    input wire baud_tick,
    input wire load,
    input wire [7:0] THR_data,
    
    input wire STB,
    input wire [1:0] WLS,
    input wire PEN,
    input wire EPS,
    
    output wire tx_data_line,
    output reg tx_busy
    );
    
    reg tx_data_reg;
    assign tx_data_line = tx_data_reg;
    
    
    reg stop_length;
    reg parity_even, parity_odd;
    reg [2:0] word_length;
    reg [3:0] frame_length;
    always @* begin
        case (WLS)
            2'h0: word_length = 5;
            2'h1: word_length = 6;
            2'h2: word_length = 7;
            2'h3: word_length = 8;
        endcase
        case (STB)
            1'b0: stop_length = 1;
            1'b1: stop_length = WLS ? 2 : 1;
        endcase 
        frame_length = stop_length + word_length;
    end
    
    
    // Update the local THR_shift register. This may be redundant, in the future, allow bit shifting directly from the register module.
    reg [15:0] THR_shift; // Larger than ever necessary to cover all configurations
    reg [3:0] shift_counter;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            THR_shift <= 16'h0;
            tx_data_reg <= 1'b1; // Hold the line idle
        end else begin
            if (load && !tx_busy) begin
                shift_counter <= 4'h0;
                if (PEN) begin
//                    THR_shift <= EPS ? {2'b11, THR_data, ^THR_data, 1'b0} : {2'b11, THR_data, ~(^THR_data), 1'b0};
                end else begin
                    THR_shift <= {2'b11, THR_data, 1'b0};
                end
                tx_busy <= 1'b1;
            end else if (tx_busy && baud_tick) begin
                if (shift_counter < frame_length) begin
                    tx_data_reg <= THR_shift[0];
                    THR_shift <= THR_shift >> 1;
                    shift_counter <= shift_counter + 1;
                end else begin
                    tx_data_reg <= 1'b1; // Set back to idle
                    tx_busy <= 1'b0;
                end
            end
        end
    end
    
    
endmodule
