library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package UTIL is
	function hex2ascii (input: std_logic_vector)
		return std_logic_vector;
	function scan2ascii (input: std_logic_vector)
		return std_logic_vector;
	function jisshift (input: std_logic_vector)
		return std_logic_vector;
end UTIL;

package body UTIL is
	function hex2ascii(input:std_logic_vector)
		return std_logic_vector is
	begin
		if (input < x"a") then
			return ("0000" & input) + x"30";
		else
			return ("0000" & input) + (x"41" - x"a");
		end if;
	end hex2ascii;
	function scan2ascii (input: std_logic_vector)
		return std_logic_vector is
	begin
		case input is
			when x"45" => return x"30";
			when x"16" => return x"31";
			when x"1e" => return x"32";
			when x"26" => return x"33";
			when x"25" => return x"34";
			when x"2e" => return x"35";
			when x"36" => return x"36";
			when x"3d" => return x"37";
			when x"3e" => return x"38";
			when x"46" => return x"39";
			when x"1C" => return x"61";
			when x"32" => return x"62";
			when x"21" => return x"63";
			when x"23" => return x"64";
			when x"24" => return x"65";
			when x"2B" => return x"66";
			when x"34" => return x"67";
			when x"33" => return x"68";
			when x"43" => return x"69";
			when x"3B" => return x"6a";
			when x"42" => return x"6b";
			when x"4B" => return x"6c";
			when x"3A" => return x"6d";
			when x"31" => return x"6e";
			when x"44" => return x"6f";
			when x"4D" => return x"70";
			when x"15" => return x"71";
			when x"2D" => return x"72";
			when x"1B" => return x"73";
			when x"2C" => return x"74";
			when x"3C" => return x"75";
			when x"2A" => return x"76";
			when x"1D" => return x"77";
			when x"22" => return x"78";
			when x"35" => return x"79";
			when x"1A" => return x"7a";
			when x"4e" => return x"2d";
			when x"55" => return x"5e";
			when x"6a" => return x"5c";
			when x"54" => return x"40";
			when x"5b" => return x"5b";
			when x"4c" => return x"3b";
			when x"52" => return x"3a";
			when x"5d" => return x"5d";
			when x"41" => return x"2c";
			when x"49" => return x"2e";
			when x"4a" => return x"2f";
			when x"51" => return x"5c";
			when x"29" => return x"20";
			when others => return x"ff";		
		end case;
	end scan2ascii;
	function jisshift(input:std_logic_vector)
		return std_logic_vector is
	begin
		case input(7 downto 4) is
			when x"3" => return input - x"10";
			when x"2" => return input + x"10";
			when x"5" | x"4" => return input + x"20";
			when x"6" | x"7" => return input - x"20";
			when others => return x"ff";
		end case;
	end jisshift;
end UTIL;
