library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity slower_clk is

generic(max:integer:=1250000000);
port(reset : in std_logic;
     clk : in std_logic;
     slower_clk_en : out std_logic);
end slower_clk;

architecture arch_slower_clk of slower_clk is
signal counter : natural range 0 to max;
signal out_signal : std_logic;

begin

clk_count : process(reset, clk)
begin
	if reset= '0' then
		counter <= 0;
		out_signal<='0';
	elsif rising_edge(clk) then
			counter <= counter + 1;
			if counter = max/2 - 1 then
				counter <= 0;
				out_signal <= not out_signal;
			end if;
	
	end if;
end process clk_count;

slower_clk_en  <= out_signal;

end arch_slower_clk;
