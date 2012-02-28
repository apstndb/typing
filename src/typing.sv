// vim: set filetype=verilog
module typing(
	input clk,
	input reset,
	inout ps2clk,
	inout ps2data,
	output[3:0] lcdData,
	output lcdRS,
	output lcdE,
	output[7:0] hex0,
	output[7:0] hex1,
	output[7:0] hex2,
	output[7:0] hex3
);
`include "functions.sv"

typedef enum {TITLE_INIT, TITLE, PLAY_INIT, PLAY, RESULT_INIT, RESULT} mode_t;
mode_t current_mode;
byte unsigned scancode;
byte unsigned dIn;
bit[9:0] typeCountDiv3;
bit[9:0] typeCount;
bit[3:0] charNum;
bit[3:0] charNumPrev;
bit wLineEn;
bit wLineEnNext;
bit wEn;
bit rx_released_prev;
bit rx_released;
wire min_finish;
byte unsigned rx_ascii;
byte unsigned rx_ascii_prev;
bit[0:7][7:0] target_string;
bit[0:7][7:0] next_string;
wire[3:0] random;

assign dIn = 8'h20;
assign typeCountDiv3 = typeCount*3;
min_counter MIN (.*,
		.clk(clk && current_mode == PLAY),
		.reset(reset || current_mode == PLAY_INIT),
		.hex({hex0,hex1,hex2,hex3}));
prng RNG (.*);
LCDDriver4Bit LCD (.clk(clk), .reset(reset),
	.lcdData(lcdData), .lcdRs(lcdRS), .lcdE(lcdE),
	.wLineEn(wLineEn), .wEn(wEn), .charNum(charNumPrev),
	.lineIn(target_string),.nextLineIn(next_string), .dIn(dIn));
ps2_keyboard_interface KBD (.clk(clk), .reset(reset),
	.ps2_clk(ps2clk), .ps2_data(ps2data),
	.rx_scan_code(scancode), .rx_ascii(rx_ascii),
	.rx_released(rx_released));

always@(posedge clk, posedge reset)
	if (reset) begin
		next_string <= string_table(random);
		target_string <= string_table(random);
		charNum <= 0;
		wEn <= 0;
		wLineEn <= 0;
		wLineEnNext <= 1;
		current_mode <= TITLE_INIT;
	end else begin
		if(wLineEnNext) begin
			wLineEn <= 1;
			wLineEnNext <= 0;
		end else
			wLineEn <= 0;
				
		case(current_mode)
		TITLE_INIT: begin
			target_string <= 64'h747970696e670000;
			next_string <= 64'h0000000000000000;
			wLineEnNext <= 1;
			current_mode <= TITLE;
		end
		TITLE: begin
			if(rx_ascii == 8'h0d)
				current_mode <= PLAY_INIT;
		end
		PLAY_INIT: begin
			next_string <= string_table(random+4'h02);
			target_string <= string_table(random);
			typeCount <= 0;
			charNum <= 0;
			wLineEnNext <= 1;
			current_mode <= PLAY;
		end
		PLAY: begin
			if(min_finish)
				current_mode <= RESULT_INIT;
			else if(rx_ascii == 8'h1b)
				current_mode <= TITLE_INIT;
			else if((rx_released_prev || rx_ascii != rx_ascii_prev) &&
			!rx_released && rx_ascii == target_string[charNum]) begin
				typeCount <= typeCount + 10'h1;
				if(charNum == 4'h7 ||
					target_string[charNum+4'b1] == 8'h00) begin
					wEn <= 0;
					wLineEnNext <= 1;
					target_string <= next_string;
					next_string <= string_table(random);
					charNum <= 4'h0;
				end else begin
					wEn <= 1;
					charNum <= charNum + 4'b1;
				end
			end else
				wEn <= 0;

			charNumPrev <= charNum;
			rx_released_prev <= rx_released;
			rx_ascii_prev <= rx_ascii; 
		end
		RESULT_INIT: begin
			target_string <= 64'h526573756c740000;
			next_string <= {8'h00,
				hex2ascii(typeCountDiv3/100%10),
				hex2ascii(typeCountDiv3/10%10),
				hex2ascii(typeCountDiv3%10),
				8'h20, 8'h63, 8'h70, 8'h6d
			};
			wLineEnNext <= 1;
			current_mode <= RESULT;
		end
		RESULT: begin
			if(rx_ascii == 8'h0d)
				current_mode <= PLAY_INIT;
		end
	endcase
	end
endmodule
