module uart(
    input clk,
    input rst,
    input tx_start,
    input [7:0]data_in,
    output [7:0] data_out,
    output tx_done,
    output rx_done
);

reg [7:0]lfsr_reg;

wire tick;
wire tx_out;

wire [7:0] tx_key;
wire [7:0] rx_key;
wire [7:0] encrypted_data;
wire [7:0] received_data;



lfsr lfsr_inst1(
    .clk(clk),
    .rst(rst),
    .key(tx_key),
    .enable(tx_done)
);


baud_rate baud_inst(
    .clk(clk),
    .rst(rst),
    .tick(tick)
);


encryption enc_inst(
    
    .data_in(data_in),
    .key(tx_key),
    .encrypted_data(encrypted_data)
);



tx tx_inst(
    .clk(clk),
    .rst(rst),
    .tick(tick),
    .tx_start(tx_start),
    .data_in(encrypted_data),      // Send encrypted data
    .tx_out(tx_out),
    .tx_done(tx_done)
);



rx rx_inst(
    .clk(clk),
    .rst(rst),
    .tick(tick),
    .rx_in(tx_out),
    .data_out(received_data),      // Receive encrypted data
    .rx_done(rx_done)
);


lfsr lfsr_inst2(
    .clk(clk),
    .rst(rst),
    .key(rx_key),
    .enable(rx_done)
);


decryption dec_inst(
    .encrypted_data(received_data),
    .key(rx_key),
    .decrypted_data(data_out)
);

endmodule
