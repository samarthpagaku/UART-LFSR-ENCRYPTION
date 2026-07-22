module baud_rate (input clk ,rst ,output reg tick );
parameter BAUD_DIV=10;
reg [12:0]counter ;
always@(posedge clk or posedge rst )begin
if(rst)begin             //initialises the counter to 0 and resets the tick value
    counter<=0;
    tick<=0;
end
else begin
    if(counter==BAUD_DIV-1)begin     //if the counter touches the value 5027, counter is again reset to 0 and tick is assigned to be 1 ( to send or receive the bit )
    counter<=0;
    tick<=1;
 end
 else begin
   counter<=counter+1;    // counter keeps incrementing until i reaches the baud divisor value 
   tick<=0;
 end
 end
    
end 
endmodule
