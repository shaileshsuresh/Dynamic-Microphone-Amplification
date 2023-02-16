library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_interface is

--generic(
--SPI_MODE :integer :=0);

port(
clk : in std_logic;
reset : in std_logic;
tx_byte : in std_logic_vector(7 downto 0);
tx_dataval : in std_logic;
tx_ready : out std_logic;
SSZ : in std_logic;

--rx_dataval : out std_logic;
--rx_byte : out std_logic_vector(7 downto 0);
spi_clk : out std_logic;
--spi_miso : in std_logic;
spi_mosi : out std_logic
);

end spi_interface;

architecture arch_spi_interface of spi_interface is

component slower_clk is
	port(reset : in std_logic;
	     clk : in std_logic;
	     slower_clk_en : out std_logic);
end component slower_clk;



--signal CPOL : std_logic;
--signal CPHA : std_logic;
signal sig_spi_clk : std_logic;
--signal sig_miso : std_logic;
signal sig_mosi : std_logic;
signal sig_tx_byte :  std_logic_vector(7 downto 0);
signal sig_tx_dataval : std_logic;
signal tx_bitcount : integer range 0 to 7;
--signal rx_bitcount : integer range 0 to 7;
signal slower_clk_sig : std_logic;

BEGIN
	--CPOL <= '1' when (SPI_MODE=2) OR (SPI_MODE=3) else '0';
	--CPOL <= '0';
	--CPHA <= '1' when (SPI_MODE=1) OR (SPI_MODE=3) else '0';
--	CPHA <= '1';
	
	slower_clk_inst:
		component slower_clk
		port map(reset => reset,
			 clk => clk,
			 slower_clk_en => slower_clk_sig);
	
	
	process(clk,SSZ)  --spi_clk
	begin
		if SSZ = '0' then
			sig_spi_clk <= slower_clk_sig;
		else
			sig_spi_clk <= '0';
		end if;
	
	end process;
	
	spi_clk <= sig_spi_clk;

	process(sig_spi_clk,reset,tx_dataval) --Reg_Data
	begin
		if (reset='0') then
			sig_tx_byte<=X"00";
			--sig_tx_dataval<='0';
		elsif SSZ='0' then
			if rising_edge(sig_spi_clk) then
				sig_tx_dataval <= tx_dataval;
				if tx_dataval = '1' then
					sig_tx_byte <= tx_byte;
				end if;
			end if;
		end if;
	end process;
	
	
	process(slower_clk_sig,reset,tx_dataval,SSZ)  --	MOSI
	begin
		if (reset='0') then	
			spi_mosi <= '0';
			tx_ready <= '1';
			tx_bitcount<=7;
		elsif SSZ='0' then
			if rising_edge(slower_clk_sig) then
				if (tx_dataval='1') then	
					spi_mosi <= sig_tx_byte(tx_bitcount);
					tx_bitcount <= tx_bitcount-1;
				end if;
			end if;
		end if;
		
	end process;
	
	--MISO : process(clk,reset) 
	--begin	
	--	if (reset='0') then	
	--		rx_dataval <= '0';
	--	elsif rising_edge(clk) then	
	--		rx_dataval <= '0';
	--		if tx_ready = '1' then
	--			bitcount <=7;
	--		elsif sig_tx_dataval='1' and CPHA='1' then
	--			rx_byte(bitcount)<=spi_miso;
	--			bitcount<=bitcount-1;
	--			if bitcount=0 then
	--				rx_dataval<='1';
	--			end if;
	--		end if;
	--	end if;
	--end process MISO;
	

	
	--spi_clk <= sig_spi_clk;
end architecture arch_spi_interface;
