module lfsr(input clk,
            input rst,
            input enable,
            output [7:0]key);

  reg [7:0] lfsr_reg;

wire feedback;

assign feedback = lfsr_reg[7] ^ lfsr_reg[5] ^ lfsr_reg[4] ^lfsr_reg[3];

always @(posedge clk or posedge rst) begin
    if(rst)
        lfsr_reg <= 8'hA5;      // Non-zero seed
    else begin
       if(enable)
        lfsr_reg <= {feedback, lfsr_reg[7:1]};
    end
end

assign key = lfsr_reg;

endmodule


