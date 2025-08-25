`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Initial Concepts, LLC
// Engineer: Duncan CLark
// 
// Create Date: 08/25/2025 05:42:38 PM
// Module Name: registers
// Project Name: UART
// Target Devices: Arty A7-35T
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Primary documentation for this implementation can be found here:
// https://www.ti.com/lit/ug/sprugp1/sprugp1.pdf?utm_source=chatgpt.com&ts=1756156935299&ref_url=https%253A%252F%252Fchatgpt.com%252F
// 
//////////////////////////////////////////////////////////////////////////////////

reg [31:0] RBR; // Receive Buffer Register
    wire RBR_data = RBR[7:0];
reg [31:0] THR; // Transmitter Holding Register
    wire THR_data = THR[7:0];
reg [31:0] IER; // Interrupt Enable Register
    wire EDSSI = IER[3]; // Enable modem status interrupt
                            // Value is always 0 but I don't know why
    wire ELSI  = IER[2]; // Receiver line status interrupt enable
                            // 0: Receiver line status interrupt is disabled
                            // 1: Receiver line status interrupt is enabled
    wire ETBEI = IER[1]; // Transmitter holding register empty interrupt enable.
                            // 0: Transmitter holding register empty interrupt is disabled.
                            // 1: Transmitter holding register empty interrupt is enabled.
    wire ERBI  = IER[0]; // Receiver data available interrupt and character timeout indication interrupt enable.
                            // 0: Receiver data available interrupt and character timeout indication interrupt is disabled.
                            // 1: Receiver data available interrupt and character timeout indication interrupt is enabled.




module registers(


    );
endmodule
