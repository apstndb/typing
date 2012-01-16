library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity COUNT10D is
    generic
    (
        INIT : integer := 0;
        BASE : integer := 10
    );
    port (
        CLK, RST, EN    : in std_logic;
        COUNT           : out integer range 0 to BASE-1;
	CARRY		: out std_logic
    );
end COUNT10D;

architecture RTL of COUNT10D is
    signal COUNT_IN : integer range 0 to BASE-1;
begin
    CARRY <= '1' when COUNT_IN=0 and EN='1' else '0';
    COUNT <= COUNT_IN;
    process (CLK, RST) begin
        if (RST = '1') then
            COUNT_IN <= INIT;
        elsif (CLK'event and CLK = '1') then
            if (EN = '1') then
                if (COUNT_IN = 0) then
                    COUNT_IN <= BASE - 1;
                else
                    COUNT_IN <= COUNT_IN - 1;
                end if;
            else
            end if;
        end if;
    end process;
end RTL;
