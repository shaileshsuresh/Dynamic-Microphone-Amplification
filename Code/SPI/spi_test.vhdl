library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_test is

end spi_test;

architecture arch_spi_test of spi_test is

	component spi_interface is
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
	end component spi_interface;
	signal clk_tb:std_logic:='0';
	signal reset_tb:std_logic:='0';
	signal tx_byte_tb:std_logic_vector(7 downto 0);
	signal tx_dataval_tb:std_logic;
	signal tx_ready_tb:std_logic;
	signal SSZ_tb:std_logic:='1';
	--signal rx_dataval_tb:std_logic;
	--signal rx_byte_tb:std_logic_vector(7 downto 0);
	signal spi_clk_tb:std_logic;
	--signal spi_miso_tb:std_logic;
	signal spi_mosi_tb:std_logic;
	signal slower_clk_tb:std_logic;
	
	begin
	
		spi_inst:
		component spi_interface
		port map(clk => clk_tb,
			 reset => reset_tb,
			 tx_byte => tx_byte_tb,
			 tx_dataval => tx_dataval_tb,
			 tx_ready => tx_ready_tb,
			 SSZ => SSZ_tb,
		        --rx_dataval => rx_dataval_tb,
			-- rx_byte => rx_byte_tb,
			 spi_clk => spi_clk_tb,
			-- spi_miso => spi_miso_tb,
			 spi_mosi => spi_mosi_tb
		);

	
		
		
		clk_process:
		process
			begin
				wait for 1 ns;
				clk_tb <= not(clk_tb);
		end process clk_process;


		
		test_process:
		process
			begin
			
			

			  wait for 10 ns;
			  reset_tb<='1';

			
			tx_dataval_tb <= '1';

			
			  
			  SSZ_tb <= '0';

				tx_byte_tb<=X"01";
				wait for 5 ns;
				tx_byte_tb<=X"02";
				wait for 5 ns;
				tx_byte_tb<=X"03";
				wait for 5 ns;
				tx_byte_tb<=X"04";
				wait for 5 ns;
				tx_byte_tb<=X"05";
				wait for 5 ns;
				tx_byte_tb<=X"06";
				wait for 5 ns;
				tx_byte_tb<=X"07";
				wait for 5 ns;
				tx_byte_tb<=X"08";
				wait for 5 ns;
				tx_byte_tb<=X"09";
			
				
		end process test_process;
		
end arch_spi_test;
