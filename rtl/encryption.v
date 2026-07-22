module encryption(
    input  [7:0] data_in,
    input  [7:0] key,
    output [7:0] encrypted_data
);

assign encrypted_data = data_in ^ key;

endmodule
