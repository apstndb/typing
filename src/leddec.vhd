library ieee;
use ieee.std_logic_1164.all;

entity LEDDEC is
    port (
        DATA    : in std_logic_vector(3 downto 0);
        LEDOUT  : out std_logic_vector(7 downto 0));
end LEDDEC;

architecture RTL of LEDDEC is
begin
    process (DATA) begin
        case DATA is
            when "0000" => LEDOUT <= "11000000";
            when "0001" => LEDOUT <= "11111001";
            when "0010" => LEDOUT <= "10100100";
            when "0011" => LEDOUT <= "10110000";
            when "0100" => LEDOUT <= "10011001";
            when "0101" => LEDOUT <= "10010010";
            when "0110" => LEDOUT <= "10000010";
            when "0111" => LEDOUT <= "11011000";
            when "1000" => LEDOUT <= "10000000";
            when "1001" => LEDOUT <= "10010000";
            when "1010" => LEDOUT <= "10100000";
            when "1011" => LEDOUT <= "10000011";
            when "1100" => LEDOUT <= "10100111";
            when "1101" => LEDOUT <= "10100001";
            when "1110" => LEDOUT <= "10000100";
            when "1111" => LEDOUT <= "10001110";
            when others => LEDOUT <= "10111111";
        end case;
    end process;
end RTL;
