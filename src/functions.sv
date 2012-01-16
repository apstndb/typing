function[7:0] hex2ascii;
input[3:0] hex;
if (hex < 4'ha)
	hex2ascii = {4'b0000, hex} + 8'h30;
else
	hex2ascii = {4'b0000, hex} + (8'h41 - 8'h0a);
endfunction

function[0:7][7:0] string_table;
input[3:0] num;
case(num)
	4'h0	: return 64'h6162636465660000;
	4'h1	: return 64'h6665646362610000;
	4'h2	: return 64'h6362636465660000;
	4'h3	: return 64'h6462636465660000;
	4'h4	: return 64'h6562636465660000;
	4'h5	: return 64'h6662636465660000;
	4'h6	: return 64'h6762636465660000;
	4'h7	: return 64'h6862636465660000;
	4'h8	: return 64'h6962636465660000;
	4'h9	: return 64'h6a62636465660000;
	4'ha	: return 64'h6b62636465660000;
	4'hb	: return 64'h6c62636465660000;
	4'hc	: return 64'h6d62636465660000;
	4'hd	: return 64'h6e62636465660000;
	4'he	: return 64'h6f62636465660000;
	4'hf	: return 64'h7062636465660000;
	default	: return 64'h0000000000000000;
endcase
endfunction

function[7:0] scan2ascii;
input[7:0] scan;
case(scan)
	8'h45 : return 8'h30;
	8'h16 : return 8'h31;
	8'h1e : return 8'h32;
	8'h26 : return 8'h33;
	8'h25 : return 8'h34;
	8'h2e : return 8'h35;
	8'h36 : return 8'h36;
	8'h3d : return 8'h37;
	8'h3e : return 8'h38;
	8'h46 : return 8'h39;
	8'h1C : return 8'h61;
	8'h32 : return 8'h62;
	8'h21 : return 8'h63;
	8'h23 : return 8'h64;
	8'h24 : return 8'h65;
	8'h2B : return 8'h66;
	8'h34 : return 8'h67;
	8'h33 : return 8'h68;
	8'h43 : return 8'h69;
	8'h3B : return 8'h6a;
	8'h42 : return 8'h6b;
	8'h4B : return 8'h6c;
	8'h3A : return 8'h6d;
	8'h31 : return 8'h6e;
	8'h44 : return 8'h6f;
	8'h4D : return 8'h70;
	8'h15 : return 8'h71;
	8'h2D : return 8'h72;
	8'h1B : return 8'h73;
	8'h2C : return 8'h74;
	8'h3C : return 8'h75;
	8'h2A : return 8'h76;
	8'h1D : return 8'h77;
	8'h22 : return 8'h78;
	8'h35 : return 8'h79;
	8'h1A : return 8'h7a;
	8'h4e : return 8'h2d;
	8'h55 : return 8'h5e;
	8'h6a : return 8'h5c;
	8'h54 : return 8'h40;
	8'h5b : return 8'h5b;
	8'h4c : return 8'h3b;
	8'h52 : return 8'h3a;
	8'h5d : return 8'h5d;
	8'h41 : return 8'h2c;
	8'h49 : return 8'h2e;
	8'h4a : return 8'h2f;
	8'h51 : return 8'h5c;
	8'h29 : return 8'h20;
	default : return 8'hff;
endcase
endfunction

function[7:0] jisshift;
input[7:0] ascii;
case (ascii[7:4])
	4'h2 : return ascii + 8'h10;
	4'h3 : return ascii - 8'h10;
	4'h4, 4'h5 : return ascii + 8'h20;
	4'h6, 4'h7 : return ascii - 8'h20;
	default : return 8'hff;
endcase
endfunction
