module prng(input clk, input reset, output[length-1:0] random);
parameter length = 4;

always @(posedge reset, posedge clk)
begin
	if(reset)
		random = 0;
	else if(clk)
		++random;
end
endmodule
