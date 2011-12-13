// vim: set filetype=verilog
module typing(
	input clk,
	input reset,
	inout ps2clk,
	inout ps2data,
	output[3:0] lcdData,
	output lcdRS,
	output lcdE
);
byte unsigned scancode;
byte unsigned dIn;
bit[3:0] charNum;
bit wEn;
bit rx_released_prev;
bit rx_released;
byte unsigned rx_ascii;
byte unsigned rx_ascii_prev;

function[7:0] hex2ascii;
input[3:0] hex;
if (hex < 4'ha)
	hex2ascii = {4'b0000, hex} + 8'h30;
else
	hex2ascii = {4'b0000, hex} + (8'h41 - 8'h0a);
endfunction

function[7:0] scan2ascii;
input[7:0] scan;
case(scan)
	8'h45 : scan2ascii = 8'h30;
	8'h16 : scan2ascii = 8'h31;
	8'h1e : scan2ascii = 8'h32;
	8'h26 : scan2ascii = 8'h33;
	8'h25 : scan2ascii = 8'h34;
	8'h2e : scan2ascii = 8'h35;
	8'h36 : scan2ascii = 8'h36;
	8'h3d : scan2ascii = 8'h37;
	8'h3e : scan2ascii = 8'h38;
	8'h46 : scan2ascii = 8'h39;
	8'h1C : scan2ascii = 8'h61;
	8'h32 : scan2ascii = 8'h62;
	8'h21 : scan2ascii = 8'h63;
	8'h23 : scan2ascii = 8'h64;
	8'h24 : scan2ascii = 8'h65;
	8'h2B : scan2ascii = 8'h66;
	8'h34 : scan2ascii = 8'h67;
	8'h33 : scan2ascii = 8'h68;
	8'h43 : scan2ascii = 8'h69;
	8'h3B : scan2ascii = 8'h6a;
	8'h42 : scan2ascii = 8'h6b;
	8'h4B : scan2ascii = 8'h6c;
	8'h3A : scan2ascii = 8'h6d;
	8'h31 : scan2ascii = 8'h6e;
	8'h44 : scan2ascii = 8'h6f;
	8'h4D : scan2ascii = 8'h70;
	8'h15 : scan2ascii = 8'h71;
	8'h2D : scan2ascii = 8'h72;
	8'h1B : scan2ascii = 8'h73;
	8'h2C : scan2ascii = 8'h74;
	8'h3C : scan2ascii = 8'h75;
	8'h2A : scan2ascii = 8'h76;
	8'h1D : scan2ascii = 8'h77;
	8'h22 : scan2ascii = 8'h78;
	8'h35 : scan2ascii = 8'h79;
	8'h1A : scan2ascii = 8'h7a;
	8'h4e : scan2ascii = 8'h2d;
	8'h55 : scan2ascii = 8'h5e;
	8'h6a : scan2ascii = 8'h5c;
	8'h54 : scan2ascii = 8'h40;
	8'h5b : scan2ascii = 8'h5b;
	8'h4c : scan2ascii = 8'h3b;
	8'h52 : scan2ascii = 8'h3a;
	8'h5d : scan2ascii = 8'h5d;
	8'h41 : scan2ascii = 8'h2c;
	8'h49 : scan2ascii = 8'h2e;
	8'h4a : scan2ascii = 8'h2f;
	8'h51 : scan2ascii = 8'h5c;
	8'h29 : scan2ascii = 8'h20;
	default : scan2ascii = 8'hff;
endcase
endfunction

function[7:0] jisshift;
input[7:0] ascii;
case (ascii[7:4])
	4'h2 : jisshift = ascii + 8'h10;
	4'h3 : jisshift = ascii - 8'h10;
	4'h4, 4'h5 : jisshift = ascii + 8'h20;
	4'h6, 4'h7 : jisshift = ascii - 8'h20;
	default : jisshift = 8'hff;
endcase
endfunction

LCDDriver4Bit LCD (.clk(clk), .reset(reset),
		.lcdData(lcdData), .lcdRs(lcdRS), .lcdE(lcdE),
		.wEn(wEn), .charNum(charNum), .dIn(dIn));
ps2_keyboard_interface KBD (.clk(clk), .reset(reset),
		.ps2_clk(ps2clk), .ps2_data(ps2data), .rx_scan_code(scancode), .rx_ascii(rx_ascii), .rx_released(rx_released));
always@(posedge clk, posedge reset) begin
	if (reset) begin
		charNum <= 15;
		wEn <= 0;
	end else begin
		//rx_ascii = scan2ascii(scancode);
		//if (charNum == 1) begin
		//	dIn = jisshift(rx_ascii);
		//end else if(charNum == 2) begin
		//	dIn = rx_ascii;
		//end else if(charNum == 3) begin
		//	dIn = hex2ascii(scancode[7:4]);
		//end else begin
		//	dIn = hex2ascii(scancode[3:0]);
		//end
		if((rx_released_prev||rx_ascii != rx_ascii_prev) && !rx_released) begin
			wEn <= 1;
			dIn <= rx_ascii;
			++charNum;// = (charNum+1)%4;
		end else
			wEn <= 0;
		rx_released_prev <= rx_released;
		rx_ascii_prev <= rx_ascii; 
	end
end
endmodule
