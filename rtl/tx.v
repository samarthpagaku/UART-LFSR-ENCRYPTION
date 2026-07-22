module tx(
    input clk, rst, tick, tx_start,
    input [7:0] data_in,
    output reg tx_out,
    output reg tx_done
);

reg [2:0] state;          // FSM state
reg [2:0] index;          // Bit counter
reg [7:0] shift_reg;      // Data to be transmitted

// Transmitter states
parameter IDLE  = 3'b000,
          START = 3'b001,
          DATA  = 3'b010,
          STOP  = 3'b011,
          DONE  = 3'b100;

always @(posedge clk or posedge rst) begin
    // Reset transmitter
    if (rst) begin
        state <= IDLE;
        tx_out <= 1;
        tx_done <= 0;
        index <= 0;
        shift_reg <= 0;
    end

    else begin
        tx_done <= 0;
        // Transmit one bit for  every baud tick
        if (tick) begin

            case (state)

                IDLE: begin
                    tx_out <= 1;
                    if (tx_start) begin
                        shift_reg <= data_in;
                        index <= 0;
                        state <= START;
                    end
                end

                // Send start bit
                START: begin
                    tx_out <= 0;
                    state <= DATA;
                end

                // Send data bits (LSB first)
                DATA: begin
                    tx_out <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;
                    index <= index + 1;

                    if (index == 7)
                        state <= STOP;
                end

                // Send stop bit
                STOP: begin
                    tx_out <= 1;
                    state <= DONE;
                end

                // Transmission complete
                DONE: begin
                    tx_done <= 1;
                    state <= IDLE;
                end

            endcase
        end
    end
end

endmodule
