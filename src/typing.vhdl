library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.UTIL.all;

entity TYPING is
	port ( clk : in std_logic;
		reset : in std_logic;
      ps2clk : in std_logic;
      ps2data : in std_logic;
      --scancode : out std_logic_vector(7 downto 0);
			  
		-- LCD Interface
		lcdData		: out		std_logic_vector(3 downto 0);
		lcdRS			: out		std_logic;
		lcdE			: out		std_logic);
end TYPING;

architecture RTL of TYPING is
component ps2read port (
	clk : in std_logic;
	reset : in std_logic;
	ps2clk : in std_logic;
	ps2data : in std_logic;
	scancode : out std_logic_vector(7 downto 0));
end component;
--component hex2ascii port (
--	input : in std_logic_vector(3 downto 0);
--	output : out std_logic_vector(7 downto 0));
--end component;
component LCDDriver4Bit port (
	clk			: in		std_logic;
	reset			: in		std_logic;

	-- Screen Buffer Interface
	dIn			: in		std_logic_vector(7 downto 0);
	charNum		: in		integer range 0 to 15;
	wEn			: in		std_logic;

	-- LCD Interface
	lcdData		: out		std_logic_vector(3 downto 0);
	lcdRS			: out		std_logic;
	lcdE			: out		std_logic);
end component;
	signal Tscancode : std_logic_vector(7 downto 0);
	signal TdIn : std_logic_vector(7 downto 0);
	signal TcharNum : integer range 0 to 15;
	signal TwEn : std_logic := '1';
	signal ThighFlag : std_logic := '1';
	signal Tascii : std_logic_vector(7 downto 0);
	--signal TasciiLow : std_logic_vector(7 downto 0);
	--signal TasciiHigh : std_logic_vector(7 downto 0);
	--function hex2ascii(input:std_logic_vector)
	--	return std_logic_vector is
	--begin
	--	if (input < x"a") then
	--		return ("0000" & input) + x"30";
	--	else
	--		return ("0000" & input) + (x"41" - x"a");
	--	end if;
	--end hex2ascii;
begin
	U1 : LCDDriver4Bit port map(clk=>clk, reset=>reset,
			lcdData=>lcdData, lcdRs=>lcdRS, lcdE=>lcdE,
			wEn=>TwEn, charNum=>TcharNum, dIn=>TdIn);
	U2 : ps2read port map(clk=>clk, reset=>reset,
			ps2clk=>ps2clk, ps2data=>ps2data, scancode=>Tscancode);
	--W1 : hex2ascii port map(input=>Tscancode(3 downto 0),
	--		output=>TasciiLow);
	--W2 : hex2ascii port map(input=>Tscancode(7 downto 4),
	--		output=>TasciiHigh);
   process(clk, reset, Tscancode) begin
		if (clk'event and clk = '1') then
			Tascii <= scan2ascii(Tscancode);
			if (ThighFlag = '1') then
				TwEn <= '1';
				TcharNum <= 0;
				TdIn <= jisshift(Tascii);
				--TdIn <= hex2ascii(Tascii(7 downto 4));
			else
				TwEn <= '1';
				TcharNum <= 1;
				TdIn <= Tascii;
				--TdIn <= hex2ascii(Tascii(3 downto 0));
			end if;
			ThighFlag <= not ThighFlag;
		end if;
   end process;
end RTL;
