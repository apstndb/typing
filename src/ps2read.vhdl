library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ps2read is
    Port ( clk : in std_logic;
           reset : in std_logic;
           ps2clk : in std_logic;
           ps2data : in std_logic;
           scancode : out std_logic_vector(7 downto 0));
end ps2read;

architecture RTL of ps2read is

signal ps2clk_last1 : std_logic;
signal ps2clk_last2 : std_logic;
signal shift_reg : std_logic_vector(9 downto 0);
Type State_t is (Idle, Shifting);
signal state : State_t;

begin
  process(clk, reset)
  begin
    if(reset = '1') then
      state <= Idle;
      scancode <= "00000000";
    elsif(clk'event and clk = '1') then
      ps2clk_last2 <= ps2clk_last1;
      ps2clk_last1 <= ps2clk;

      if (ps2clk_last2 = '1' and ps2clk_last1 = '0') then  -- ps2clk fall edge

        case state is
        when Idle =>
          if (ps2data = '0') then	 -- start bit has come
            state <= Shifting;
            shift_reg <= "0111111111";
          end if;

        when Shifting =>
          if (shift_reg(0) = '0' and ps2data = '1') then	 -- stop bit has come
            scancode <= shift_reg(8 downto 1);
            state <= Idle;
          else
            shift_reg <= ps2data & shift_reg(shift_reg'high downto 1);
          end if;

        when Others =>
          state <= Idle;
        end case;
      end if;
    end if;
  end process;
end RTL;
