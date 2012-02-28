module min_counter(input clk, input reset,
			output min_finish, output[0:3][7:0] hex);
parameter CLOCK_HZ = 50000000;
parameter COUNT_10MS = CLOCK_HZ/100;

defparam B1[3].CNT.INIT = 2;

bit[0:3][3:0] bcd;
bit[0:4] en;
bit[18:0] timeCount;

assign min_finish = en[4];
assign en[0] = timeCount==0;

genvar i;
generate for(i=0;i<4;i=i+1) begin : B1
	LEDDEC DEC (.DATA(bcd[i]), .LEDOUT(hex[i]));
	COUNT10D CNT (.RST(reset), .CLK(clk),
	 .EN(en[i]), .COUNT(bcd[i]), .CARRY(en[i+1]));
end
endgenerate
always@(posedge reset, posedge clk) begin
	if(reset)
		timeCount = COUNT_10MS[18:0];
	else
		if(timeCount)
			--timeCount;
		else
			timeCount = COUNT_10MS[18:0];
end
endmodule
