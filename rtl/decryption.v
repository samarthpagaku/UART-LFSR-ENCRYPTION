module decryption(
    input  [7:0]encrypted_data,
    input  [7:0]key,
    output [7:0]decrypted_data
);

assign decrypted_data = encrypted_data ^ key;

endmodule
