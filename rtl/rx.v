module rx(
    input clk, rst, tick, rx_in,
    output reg [7:0] data_out,
    output reg rx_done
);

// State register to control the receiver FSM
reg [2:0] state;

// Stores the received 8-bit data temporarily
reg [7:0] shift_reg;

// Keeps track of how many bits have been received
reg [2:0] index;

// Receiver state definitions
parameter IDLE  = 3'b000,
          START = 3'b001,
          DATA  = 3'b010,
          STOP  = 3'b011,
          DONE  = 3'b100;

always @(posedge clk or posedge rst) begin

    // Reset all registers and return to the idle state
    if (rst) begin
        state <= IDLE;
        rx_done <= 0;
        index <= 0;
        shift_reg <= 0;
        data_out <= 0;
    end 
    else begin

        // Keep rx_done low unless a complete byte is received
        rx_done <= 0;

        case (state)

            // Wait until the start bit (logic 0) is detected
            IDLE: begin
                if (rx_in == 0) begin
                    state <= START;
                end
            end

            // Wait for one baud tick so sampling begins at the correct time
            START: begin
                if (tick) begin
                    index <= 0;      // Start receiving from bit 0
                    state <= DATA;
                end
            end

            // Receive one data bit on every baud tick
            DATA: begin
                if (tick) begin

                    // Store the received bit in the shift register
                    // UART transmits the Least Significant Bit (LSB) first
                    shift_reg[index] <= rx_in;
                    index <= index + 1;

                    // After receiving all 8 bits, move to the STOP state
                    if (index == 7)
                        state <= STOP;
                end
            end

            // Verify that the stop bit is logic 1
            STOP: begin
                if (tick) begin

                    // Valid stop bit means the frame is complete
                    if (rx_in == 1)
                        state <= DONE;

                    // Invalid stop bit indicates a framing error,
                    // so discard the data and wait for the next frame
                    else
                        state <= IDLE;
                end
            end

            // Transfer the received byte to the output
            DONE: begin

                // Make the received data available at the output
                data_out <= shift_reg;

                // Generate a one-clock-cycle pulse indicating reception is complete
                rx_done <= 1;

                // Return to idle and wait for the next frame
                state <= IDLE;
            end

        endcase
    end
end

endmodule
