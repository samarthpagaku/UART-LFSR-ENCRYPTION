module uart_tb;

reg clk;
reg rst;
reg tx_start;
reg [7:0] data_in;

wire [7:0] data_out;
wire tx_done;
wire rx_done;

// Instantiate the top module
top uut (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .data_in(data_in),
    .data_out(data_out),
    .tx_done(tx_done),
    .rx_done(rx_done)
);

// Clock generation (2 ns period)
always #1 clk = ~clk;

initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, uart_tb);

    // Initialize signals
    clk = 0;
    rst = 1;
    tx_start = 0;
    data_in = 8'h00;

    // Apply reset
    #20;
    rst = 0;

    //-------------------------------------------------
    // TEST 1
    //-------------------------------------------------
    #20;
    data_in = 8'h55;
    tx_start = 1;

    // Keep tx_start high long enough
    #100;
    tx_start = 0;

    wait(rx_done);

    $display("======================================");
    $display("TEST 1");
    $display("Input Data      = %h", data_in);
    $display("Encrypted Data  = %h", uut.encrypted_data);
    $display("Received Data   = %h", uut.received_data);
    $display("Output Data     = %h", data_out);
    $display("Key_tx = %h", uut.tx_key);
    $display("Key_rx = %h", uut.rx_key);

    if(data_out == data_in)
        $display("RESULT : PASS");
    else
        $display("RESULT : FAIL");
    $display("======================================");

    //-------------------------------------------------
    // TEST 2
    //-------------------------------------------------
    #100;

    data_in = 8'hAA;
    tx_start = 1;

    #100;
    tx_start = 0;

    wait(rx_done);

    $display("======================================");
    $display("TEST 2");
    $display("Input Data      = %h", data_in);
    $display("Encrypted Data  = %h", uut.encrypted_data);
    $display("Received Data   = %h", uut.received_data);
    $display("Output Data     = %h", data_out);
   $display("Key_tx = %h", uut.tx_key);
    $display("Key_rx = %h", uut.rx_key);
    if(data_out == data_in)
        $display("RESULT : PASS");
    else
        $display("RESULT : FAIL");
    $display("======================================");

    #200;
    $finish;
end

endmodule
