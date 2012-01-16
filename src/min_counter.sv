module min_counter(input clk, input reset, input enable,
			output min_finish, output[0:3][7:0] hex);
bit[0:3][3:0] bcd;
bit[0:4] en;

defparam B1[3].CNT.INIT = 6;
assign min_finish = en[4];
assign en[0] = enable;

genvar i;
generate for(i=0;i<4;i=i+1) begin : B1
	LEDDEC DEC (.DATA(bcd[i]), .LEDOUT(hex[i]));
	COUNT10D CNT (.RST(reset), .CLK(clk),
	 .EN(en[i]), .COUNT(bcd[i]), .CARRY(en[i+1]));
end
endgenerate
endmodule
