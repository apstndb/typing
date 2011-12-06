library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.UTIL.all;

entity TYPING is
	port (
	clk	: in std_logic;
	reset	: in std_logic;
	ps2clk	: in std_logic;
	ps2data	: in std_logic;
	--scancode : out std_logic_vector(7 downto 0);
			  
	-- LCD Interface
	lcdData	: out std_logic_vector(3 downto 0);
	lcdRS	: out std_logic;
	lcdE	: out std_logic);
end TYPING;

architecture RTL of TYPING is
--component ps2read port (
--	clk	: in std_logic;
--	reset	: in std_logic;
--	ps2clk	: in std_logic;
--	ps2data	: in std_logic;
--	scancode: out std_logic_vector(7 downto 0));
--end component;
--component hex2ascii port (
--	input : in std_logic_vector(3 downto 0);
--	output : out std_logic_vector(7 downto 0));
--end component;
--component LCDDriver4Bit port (
--	clk	: in std_logic;
--	reset	: in std_logic;
--
--	-- Screen Buffer Interface
--	dIn	: in std_logic_vector(7 downto 0);
--	charNum	: in integer range 0 to 15;
--	wEn	: in std_logic;
--
--	-- LCD Interface
--	lcdData	: out std_logic_vector(3 downto 0);
--	lcdRS	: out std_logic;
--	lcdE   	: out std_logic);
--end component;
	signal sScancode : std_logic_vector(7 downto 0);
	signal sDIn : std_logic_vector(7 downto 0);
	signal sCharNum : integer range 0 to 15;
	signal sWEn : std_logic := '1';
	signal sHighFlag : std_logic := '0';
	signal sAscii : std_logic_vector(7 downto 0);
begin
	process(clk, reset) begin
		if (reset = '1') then
			sHighFlag <= '0';
		elsif (clk'event and clk = '1') then
			sWEn <= '1';
			sAscii <= scan2ascii(sScancode);
			if (sHighFlag = '1') then
				sCharNum <= 0;
				sDIn <= jisshift(sAscii);
				--sDIn <= hex2ascii(sAscii(7 downto 4));
			else
				sCharNum <= 1;
				sDIn <= sAscii;
				--sDIn <= hex2ascii(sAscii(3 downto 0));
			end if;
			sHighFlag <= not sHighFlag;
		end if;
	end process;
	U1 : entity work.LCDDriver4Bit port map(clk=>clk, reset=>reset,
			lcdData=>lcdData, lcdRs=>lcdRS, lcdE=>lcdE,
			wEn=>sWEn, charNum=>sCharNum, dIn=>sDIn);
	U2 : entity work.ps2read port map(clk=>clk, reset=>reset,
			ps2clk=>ps2clk, ps2data=>ps2data, scancode=>sScancode);
end RTL;
