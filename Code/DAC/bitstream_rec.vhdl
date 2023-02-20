----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.02.2023 10:44:17
-- Design Name: 
-- Module Name: DAC16 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bitstream_rec is  
      Port (
        resetn : in std_logic;
        clk : in std_logic;
        input_bit : in std_logic;
        fsync : in std_logic;
        clk_output : out std_logic;
        output : out std_logic_vector(15 downto 0));
end bitstream_rec;

architecture behavioral of DAC16 is
    
    signal temp_clk : std_logic;
    signal i : integer range 0 to 15:=15;
    signal fsync_received : std_logic;
    signal load_finished : std_logic;
    signal current_input : std_logic;
    signal input_bitstream : std_logic_vector(15 downto 0);
    signal value: std_logic_vector (15 downto 0);
    type state_type is (idle_state,
    load_state,
    send_state);
    signal current_state : state_type;
    signal next_state : state_type;
    type memory is array (0 to 255) of std_logic_vector(15 downto 0);
    constant sine : memory := (
X"8000", X"8324", X"8647", X"896a", X"8c8b", X"8fab", X"92c7", X"95e1", 
X"98f8", X"9c0b", X"9f19", X"a223", X"a527", X"a826", X"ab1e", X"ae10", 
X"b0fb", X"b3de", X"b6b9", X"b98c", X"bc56", X"bf16", X"c1cd", X"c47a", 
X"c71c", X"c9b3", X"cc3f", X"cebf", X"d133", X"d39a", X"d5f4", X"d842", 
X"da81", X"dcb3", X"ded6", X"e0eb", X"e2f1", X"e4e7", X"e6ce", X"e8a5", 
X"ea6c", X"ec23", X"edc9", X"ef5e", X"f0e1", X"f254", X"f3b5", X"f503", 
X"f640", X"f76b", X"f883", X"f989", X"fa7c", X"fb5c", X"fc29", X"fce2", 
X"fd89", X"fe1c", X"fe9c", X"ff08", X"ff61", X"ffa6", X"ffd7", X"fff5", 
X"ffff", X"fff5", X"ffd7", X"ffa6", X"ff61", X"ff08", X"fe9c", X"fe1c", 
X"fd89", X"fce2", X"fc29", X"fb5c", X"fa7c", X"f989", X"f883", X"f76b", 
X"f640", X"f503", X"f3b5", X"f254", X"f0e1", X"ef5e", X"edc9", X"ec23", 
X"ea6c", X"e8a5", X"e6ce", X"e4e7", X"e2f1", X"e0eb", X"ded6", X"dcb3", 
X"da81", X"d842", X"d5f4", X"d39a", X"d133", X"cebf", X"cc3f", X"c9b3", 
X"c71c", X"c47a", X"c1cd", X"bf16", X"bc56", X"b98c", X"b6b9", X"b3de", 
X"b0fb", X"ae10", X"ab1e", X"a826", X"a527", X"a223", X"9f19", X"9c0b", 
X"98f8", X"95e1", X"92c7", X"8fab", X"8c8b", X"896a", X"8647", X"8324", 
X"8000", X"7cdb", X"79b8", X"7695", X"7374", X"7054", X"6d38", X"6a1e", 
X"6707", X"63f4", X"60e6", X"5ddc", X"5ad8", X"57d9", X"54e1", X"51ef", 
X"4f04", X"4c21", X"4946", X"4673", X"43a9", X"40e9", X"3e32", X"3b85", 
X"38e3", X"364c", X"33c0", X"3140", X"2ecc", X"2c65", X"2a0b", X"27bd", 
X"257e", X"234c", X"2129", X"1f14", X"1d0e", X"1b18", X"1931", X"175a", 
X"1593", X"13dc", X"1236", X"10a1", X"0f1e", X"0dab", X"0c4a", X"0afc", 
X"09bf", X"0894", X"077c", X"0676", X"0583", X"04a3", X"03d6", X"031d", 
X"0276", X"01e3", X"0163", X"00f7", X"009e", X"0059", X"0028", X"000a", 
X"0001", X"000a", X"0028", X"0059", X"009e", X"00f7", X"0163", X"01e3", 
X"0276", X"031d", X"03d6", X"04a3", X"0583", X"0676", X"077c", X"0894", 
X"09bf", X"0afc", X"0c4a", X"0dab", X"0f1e", X"10a1", X"1236", X"13dc", 
X"1593", X"175a", X"1931", X"1b18", X"1d0e", X"1f14", X"2129", X"234c", 
X"257e", X"27bd", X"2a0b", X"2c65", X"2ecc", X"3140", X"33c0", X"364c", 
X"38e3", X"3b85", X"3e32", X"40e9", X"43a9", X"4673", X"4946", X"4c21", 
X"4f04", X"51ef", X"54e1", X"57d9", X"5ad8", X"5ddc", X"60e6", X"63f4", 
X"6707", X"6a1e", X"6d38", X"7054", X"7374", X"7695", X"79b8", X"7cdb"
		);
	
		
begin
    clk_output <= temp_clk;
    fsync_received <= fsync;
state_flow_proc : process(clk, resetn)
begin
    if (resetn = '0') then
        current_state <= idle_state;
    elsif rising_edge(clk) then
        current_state <= next_state;
    end if;
end process;


state_proc: process(load_finished, current_state)
begin
    case current_state is
        when idle_state =>
            if fsync_received = '1' then
                next_state <= load_state;
            else
                next_state <= idle_state;
            end if;
        when load_state =>
            if load_finished = '1' then 
                next_state <= send_state;
            else
                next_state <= load_state;
            end if;
        when send_state =>
              next_state <= idle_state;
    end case;
    
end process;

assignment_proc : process(current_state)
begin   
    case current_state is
        when idle_state => 
            input_bitstream <= X"0000";        
        when load_state =>
            input_bitstream(i) <= input_bit;   
        when send_state =>
            fsync_received <= '0';
            output <= input_bitstream;                  --send output to dac input
    end case;
end process;
    
counter_proc: process(clk, resetn)
BEGIN
    if (resetn = '0') then
        temp_clk <= '0';
        i <= 15;
   elsif rising_edge(clk) then
        temp_clk <= not(temp_clk);
        
        if current_state = load_state then
           i <= i-1;
        elsif i = 0 then
            load_finished <= '1';
            i <= 15;
            --value <= input;
        end if;
    end if;
    
end process;

end behavioral;
