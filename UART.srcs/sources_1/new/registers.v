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





module registers(
    input wire clk,
    input wire rst,
    input wire cs,
    input wire we,
    input wire re,
    
    // Register read/write
    input wire [7:0] addr,
    input wire [31:0] wdata,
    output reg [31:0] rdata,
    
    input wire [7:0] RBR_data,
    output wire [7:0] THR_data,
    
    output wire EDSSI,
    output wire ELSI,
    output wire ETBEI,
    output wire ERBI,
    
    output wire [1:0] FIFOEN_IIR,
    output wire [2:0] INTID,
    output wire IPEND,
    
    output wire [1:0] RXFIFTL,
    output wire DMAMODE1,
    output wire TXCLR,
    output wire RXCLR,
    output wire FIFOEN_FCR,
    
    output wire DLAB,
    output wire BC,
    output wire SP,
    output wire EPS,
    output wire PEN,
    output wire STB,
    output wire [1:0] WLS,
    
    output wire AFE,
    output wire LOOP,
    output wire OUT2,
    output wire OUT1,
    output wire RTS,
    
    output wire RXFIFOE,
    output wire TEMT,
    output wire THRE,
    output wire BI,
    output wire FE,
    output wire PE,
    output wire OE,
    output wire DR,
    
    output wire CD,
    output wire RI,
    output wire DSR,
    output wire CTS,
    output wire DCD,
    output wire TERI,
    output wire DDSR,
    output wire DCTS,
    
    output wire w_SCR,
    
    output wire w_DLL,
    output wire w_DLH,
    
    output wire w_REVID1,
    output wire [7:0] w_REVID2,
    
    output wire UTRST,
    output wire URRST,
    output wire FREE,
    
    output wire OSM_SEL
    );
    
    reg [31:0] RBR; // Receive Buffer Register
    reg [31:0] THR; // Transmitter Holding Register
    reg [31:0] IER; // Interrupt Enable Register
    reg [31:0] IIR; // Interrupt Identification Register
    reg [31:0] FCR; // FIFO Control Register
    reg [31:0] LCR; // Line Control Register
    reg [31:0] MCR; // Modem Control Register
    reg [31:0] LSR; // Line Status Register
    reg [31:0] MSR; // Modem Status Register | See documentation for further detail
    reg [31:0] SCR; // Scratch Pad Register
    reg [31:0] DLL; // Divisor LSB Latch
    reg [31:0] DLH; // Divisor MSB Latch
    reg [31:0] REVID1; // Revision Identification Register One
    reg [31:0] REVID2; // Revision Identification Register Two
    reg [31:0] PWREMU_MGMT; // Power and Emulation Management Register
    reg [31:0] MDR; // Mode Definition Register
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Create a default configuration for UART upon reset
            RBR <= 32'h0; // Read only
            THR <= 32'h0; // Write only
            IER <= 32'h0;
            IIR <= 32'h0; // Read only
            FCR <= 32'h0; // Write only
            LCR <= 32'h0;
            MCR <= 32'h0;
            LSR <= 32'h0;
            MSR <= 32'h0;
            SCR <= 32'h0;
            DLL <= 32'h0;
            DLH <= 32'h0;
            REVID1 <= 32'h0;
            REVID2 <= 32'h0;
            PWREMU_MGMT <= 32'h0;
            MDR <= 32'h0;
        end else if (cs & re & !we) begin // read register
            // Handle the register read/write logic
            case (addr)
                8'h0: rdata <= RBR;
                8'h4: rdata <= IER;
                8'h8: rdata <= IIR;
                8'hC: rdata <= LCR;
                8'h10: rdata <= MCR;
                8'h14: rdata <= LSR;
                8'h18: rdata <= MSR;
                8'h1C: rdata <= SCR;
                8'h20: rdata <= DLL;
                8'h24: rdata <= DLH;
                8'h28: rdata <= REVID1;
                8'h2C: rdata <= REVID2;
                8'h30: rdata <= PWREMU_MGMT;
                8'h34: rdata <= MDR;
            endcase
        end else if (cs & !re & we) begin // write register
            case (addr)
                8'h0: THR <= {24'h0, THR_data};
                8'h4: IER <= wdata;
                8'h8: FCR <= wdata;
                8'hC: LCR <= wdata;
                8'h10: MCR <= wdata;
                8'h14: LSR <= wdata;
                8'h18: MSR <= wdata;
                8'h1C: SCR <= wdata;
                8'h20: DLL <= wdata;
                8'h24: DLH <= wdata;
                8'h28: REVID1 <= wdata;
                8'h2C: REVID2 <= wdata;
                8'h30: PWREMU_MGMT <= wdata;
                8'h34: MDR <= wdata;
            endcase
        end
    end

//    assign RBR[7:0] = RBR_data;
    assign THR_data = THR[7:0];

    assign EDSSI = IER[3]; // Enable modem status interrupt
                            // Value is always 0 but I don't know why
    assign ELSI  = IER[2]; // Receiver line status interrupt enable
                            // 0: Receiver line status interrupt is disabled
                            // 1: Receiver line status interrupt is enabled
    assign ETBEI = IER[1]; // Transmitter holding register empty interrupt enable.
                            // 0: Transmitter holding register empty interrupt is disabled.
                            // 1: Transmitter holding register empty interrupt is enabled.
    assign ERBI  = IER[0]; // Receiver data available interrupt and character timeout indication interrupt enable.
                            // 0: Receiver data available interrupt and character timeout indication interrupt is disabled.
                            // 1: Receiver data available interrupt and character timeout indication interrupt is enabled.

    assign FIFOEN_IIR = IIR[7:6]; // FIFOs enabled
                                        // 0 = Non-FIFO mode.
                                        // 1 = Reserved.
                                        // 2 = Reserved.
                                        // 3 = FIFOs are enabled. FIFOEN bit in the FIFO control register (FCR) is set to 1.
    assign INTID = IIR[3:1]; // Interrupt Type
                                        // 0 = Reserved.
                                        // 1 = Transmitter holding register empty (priority 3).
                                        // 2 = Receiver data available (priority 2).
                                        // 3 = Receiver line status (priority 1, highest).
                                        // 4 = Reserved.
                                        // 5 = Reserved.
                                        // 6 = Character timeout indication (priority 2).
                                        // 7 = Reserved.
    assign IPEND = IIR[0]; // Interrupt pending

    assign RXFIFTL = FCR[7:6]; // Receiver FIFO trigger level.
                                        // 0 = 1 byte.
                                        // 1 = 4 bytes.
                                        // 2 = 8 bytes.
                                        // 3 = 14 bytes.
    assign DMAMODE1 = FCR[3]; // Enable if FIFOs are enabled.
                                        // 0 = DMA MODE1 is disabled.
                                        // 1 = DMA MODE1 is enabled.
    assign TXCLR = FCR[2]; // Transmitter FIFO cleared
                                        // 0 = No effect.
                                        // 1 = Clears transmitter FIFO and resets the transmitter FIFO counter. The shift register is not cleared.
    assign RXCLR = FCR[1]; // Receiver FIFO clear. Write a 1 to RXCLR to clear the bit.
                                        // 0 = No effect.
                                        // 1 = Clears receiver FIFO and resets the receiver FIFO counter. The shift register is not cleared.
    assign FIFOEN_FCR = FCR[0]; // Transmitter and receiver FIFO mode enable
                                        // 0 = Non-FIFO mode. The transmitter and receiver FIFOs are disabled, and the FIFO pointers are cleared.
                                        // 1 = FIFO mode. The transmitter and receiver FIFOs are enabled.

    assign DLAB = LCR[7]; // Divisor latch access bit
                            // See documentation for details
    assign BC = LCR[6]; // Break control
                            // 0 = Break condition is disabled.
                            // 1 = Break condition is transmitted to the receiving UART.
    assign SP = LCR[5]; // Stick Parity
                            // 0 = Stick parity is disabled.
                            // 1 = Stick parity is enabled.
    assign EPS = LCR[4]; // Even parity select
                            // 0 = Odd parity is selected.
                            // 1 = Even parity is selected.
    assign PEN = LCR[3]; // Parity enable
                            // 0 = No parity bit is transmitted or checked.
                            // 1 = Parity bit is generated in transmitted data.
    assign STB = LCR[2]; // Number of stop bits generated
                            // 0 = one stop bit is generated.
                            // 1 = WLS bit determines the number of stop bits.
                                // When WLS = 0, 1.5 stop bits are generated.
                                // When WLS = 1h, 2h, or 3h, 2 stop bits are generated.
    assign WLS = LCR[1:0]; // Word length select
                                // 0 = 5 bits
                                // 1 = 6 bits
                                // 2 = 7 bits
                                // 3 = 8 bits

    assign AFE = MCR[5]; // Autoflow control enable
                            // 0 = Autoflow control is disabled.
                            // 1 = Autoflow control is enabled:
                                // » When RTS = 0, only UARTn_CTS is enabled.
                                // » When RTS = 1, UARTn_RTS and UARTn_CTS are enabled.
    assign LOOP = MCR[4]; // Loopback mode enable
                            // 0 = Loopback mode is disabled.
                            // 1 = Loopback mode is enabled. When LOOP is set, the following occur:
                                // » The UARTn_TXD signal is set high.
                                // » The UARTn_RXD pin is disconnected
                                // » The output of the transmitter shift register (TSR) is looped back in to the receiver shift register (RSR) input.
    assign OUT2 = MCR[3]; // OUT2 control bit
    assign OUT1 = MCR[2]; // OUT1 control bit
    assign RTS = MCR[1]; // RTS control
                            // 0 = UARTn_RTS is disabled, only UARTn_CTS is enabled.
                            // 1 = UARTn_RTS and UARTn_CTS are enabled.

    assign RXFIFOE = LSR[7]; // RX FIFO error
                            // See documentation for further detail.
    assign TEMT = LSR[6]; // Temporary empty indicator.
                            // See documentation for further detail.
    assign THRE = LSR[5]; // Transmitter holding register empty indicator.
                            // See documentation for further detail.
    assign BI = LSR[4]; // Break indicator
                            // See documentation for further detail.
    assign FE = LSR[3]; // Framing error indicator
                            // See documentation for further detail.
    assign PE = LSR[2]; // Parity error indicator
                            // See documentation for further detail.
    assign OE = LSR[1]; // Overrun error indicator
                            // See documentation for further detail.
    assign DR = LSR[0]; // Data-ready indicator for the receiver
                            // See documentation for further detail.

    assign CD = MSR[7]; // Compliment of the carrier detect input
    assign RI = MSR[6]; // Compliment of the ring indicator input
    assign DSR = MSR[5]; // Compliment of the data set ready input
    assign CTS = MSR[4]; // Compliment of the clear to send input
    assign DCD = MSR[3]; // Change in DCD indicator bit
    assign TERI = MSR[2]; // Trailing edge of RI indicator bit
    assign DDSR = MSR[1]; // Change in the DSR indicator bit
    assign DCTS = MSR[0]; // Change in CTS indicator bit

    assign w_SCR = SCR[7:0]; // Temporarily holds programmers data without affecting any other UART operation.

    assign w_DLL = DLL[7:0]; // the 8 least-significant bits of the 16 bit divisor for generation of the baud clock.

    assign w_DLH = DLH[7:0]; // The most-significant bits of the 16 bit divisor for generation of the baud clock.

    assign w_REVID1 = REVID1;
    assign w_REVID2 = REVID2[7:0];

    assign UTRST = PWREMU_MGMT[14]; // UART transmitter reset. Resets and enables the transmitter.
                                        // 0 = Transmitter is disabled and in reset state.
                                        // 1 = Transmitter is enabled.
    assign URRST = PWREMU_MGMT[13]; // UART receiver reset. Resets and enables the receiver.
                                        // 0 = Receiver is disabled and in reset state.
                                        // 1 = Receiver is enabled.
    assign FREE = PWREMU_MGMT[0]; // Free-running enable mode bit. | See documentation for further detail.

    assign OSM_SEL = MDR[0]; // Over-sampling mode select
                                // 0 = 16× oversampling.
                                // 1 = 13× oversampling.
endmodule
