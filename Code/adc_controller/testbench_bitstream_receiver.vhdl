----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/21/2023 10:31:07 AM
-- Design Name: 
-- Module Name: bitstream_rev_TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.env.stop;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bitstream_rev_TB is

end bitstream_rev_TB;

architecture Behavioral of bitstream_rev_TB is
    
    component bitstream_rec is
        port(resetn : in std_logic;
        clk : in std_logic;
        input_bit : in std_logic;
        fsync : in std_logic;
        clk_output : out std_logic;
        output : out std_logic_vector(15 downto 0));
    end component bitstream_rec;
    
    constant clk_period : time := 10 ns;
    signal tb_clk : std_logic := '0';
    signal tb_resetn : std_logic := '0';
    signal tb_input_bit : std_logic;
    signal tb_fsync : std_logic;
    signal tb_clk_output : std_logic;
    signal tb_output : std_logic_vector(15 downto 0);
    
begin
   
    bitstream_rec_inst:
    component bitstream_rec
        port map(resetn => tb_resetn,
                clk => tb_clk,
                input_bit => tb_input_bit,
                fsync => tb_fsync,
                clk_output => tb_clk_output,
                output => tb_output
        );
    

clk_proc : process
begin       
        tb_clk <= '0';
        wait for (clk_period/2);
        tb_clk <= '1';
        wait for clk_period/2;
        
end process clk_proc;

main_proc : process
begin
    wait for 50 ns;
        tb_resetn <= '1';
        tb_fsync <= '1';
    wait for 10 ns;
        tb_input_bit <= '1';
    wait for 10 ns;
        tb_input_bit <= '1';
    wait for 10 ns;
        tb_input_bit <= '1';
    wait for 10 ns;
        tb_input_bit <= '1';
    wait for 10 ns;
        tb_input_bit <= '1';
    wait for 10 ns;
        tb_input_bit <= '0';
    wait for 10 ns;
        tb_input_bit <= '1';
    wait for 10 ns;
        tb_input_bit <= '0';
    wait for 10 ns;
        tb_input_bit <= '1';
    wait for 10 ns;
        tb_input_bit <= '0';
    wait for 10 ns;
        tb_input_bit <= '1';
    wait for 10 ns;
        tb_input_bit <= '0';
    wait for 10 ns;
        tb_input_bit <= '1';
    wait for 10 ns;
        tb_input_bit <= '0';
    wait for 10 ns;
        tb_input_bit <= '1';
    wait for 10 ns;
        tb_input_bit <= '0';
    wait for 20 ns;
        
        assert tb_output /= "1010101010101010" report "Error in component" severity FAILURE;
        stop;
end process main_proc;
end Behavioral;
