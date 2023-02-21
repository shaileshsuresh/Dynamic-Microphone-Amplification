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

architecture behavioral of bitstream_rec is
    
    signal temp_clk : std_logic;
    signal i : integer range 0 to 15:=15;
    signal fsync_received : std_logic;
    signal load_finished : std_logic := '0';
    signal current_input : std_logic;
    signal input_bitstream : std_logic_vector(15 downto 0);
    signal value: std_logic_vector (15 downto 0);
    type state_type is (idle_state,
    load_state,
    send_state);
    signal current_state : state_type;
    signal next_state : state_type;
   
	
		
begin
    clk_output <= temp_clk;
    fsync_received <= fsync;
    output <= input_bitstream;
    
    
------------------------------------------------------------------------------------------------------------ FSM start-------------------------------------------------
state_flow_proc : process(clk, resetn)
begin
    if (resetn = '0') then
        current_state <= idle_state;
    elsif rising_edge(clk) then
        current_state <= next_state;
    end if;
end process;


state_proc: process(load_finished, current_state, fsync)
begin
    case current_state is
        when idle_state =>
            if fsync = '1' then
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

assignment_proc : process(clk, current_state)
begin   
    case current_state is
        when idle_state => 
            input_bitstream <= X"0000";  
            value <= X"0000";    
            --fsync_received <= fsync; 
            --load_finished <= '0';
        when load_state =>
            value(i) <= input_bit;
            fsync_received <= fsync; 
        when send_state =>
            fsync_received <= '0';
            input_bitstream <= value;                  --send output to dac input
            --load_finished <= '0';
    end case;
end process;
    
counter_proc: process(clk, resetn, current_state)
BEGIN
    if (resetn = '0') then
        temp_clk <= '0';
        i <= 15;
   elsif rising_edge(clk) then
        temp_clk <= not(temp_clk);
        
        if current_state = load_state then
           i <= i-1;
        end if;
        if i = 0 then
            load_finished <= '1';
            i <= 15;
            --value <= input;
        end if;
    end if;
    
end process;

end behavioral;
