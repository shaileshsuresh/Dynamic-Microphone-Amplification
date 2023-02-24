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

entity bitstream_rec is
    generic (
        CHAN_WID : integer := 16
    );
    port (
        resetn : in std_logic;
        clk : in std_logic;
        input_bit : in std_logic;
        fsync : in std_logic;
        chan1_data : out std_logic_vector(CHAN_WID-1 downto 0);
        chan2_data : out std_logic_vector(CHAN_WID-1 downto 0);
        chan3_data : out std_logic_vector(CHAN_WID-1 downto 0);
        chan4_data : out std_logic_vector(CHAN_WID-1 downto 0)
    );
end bitstream_rec;

architecture behavioral of bitstream_rec is

    constant CHAN_NUM : integer := 4;  -- channel number, maximum 4
    signal start      : std_logic;
    signal i          : integer range 0 to 511;
	signal chan_buff  : std_logic_vector((CHAN_NUM*CHAN_WID)-1 downto 0);

	
begin

    tdm_handle_proc:
    process (resetn,fsync,clk,i)
    begin
        if resetn = '0' then
            start      <=  '0';
            chan_buff  <= x"FFFFFFFFFFFFFFFF";
            chan1_data <= (others => '0');
            chan2_data <= (others => '0');
            chan3_data <= (others => '0');
            chan4_data <= (others => '0');
        else
            if rising_edge(fsync) then
                if start = '1' then
                    if CHAN_NUM = 1 then
                        chan1_data <= chan_buff(CHAN_WID-1 downto 0);
                        chan2_data <= (others => '0');
                        chan3_data <= (others => '0');
                        chan4_data <= (others => '0');
                    elsif CHAN_NUM = 2 then
                        chan2_data <= chan_buff(CHAN_WID-1 downto 0);
                        chan1_data <= chan_buff((2*CHAN_WID)-1 downto CHAN_WID);
                        chan3_data <= (others => '0');
                        chan4_data <= (others => '0');
                    elsif CHAN_NUM = 3 then
                        chan3_data <= chan_buff(CHAN_WID-1 downto 0);
                        chan2_data <= chan_buff((2*CHAN_WID)-1 downto CHAN_WID);
                        chan1_data <= chan_buff((3*CHAN_WID)-1 downto 2*CHAN_WID);
                        chan4_data <= (others => '0');
                    elsif CHAN_NUM = 4 then
                        chan4_data <= chan_buff(CHAN_WID-1 downto 0);
                        chan3_data <= chan_buff((2*CHAN_WID)-1 downto CHAN_WID);
                        chan2_data <= chan_buff((3*CHAN_WID)-1 downto 2*CHAN_WID);
                        chan1_data <= chan_buff((4*CHAN_WID)-1 downto 3*CHAN_WID);
                    end if;
                else
                    start <= '1';
                end if;
            end if;
            if falling_edge(clk) then
                chan_buff(i) <= input_bit;
            end if;
        end if;
    end process tdm_handle_proc;


    counter_proc:
    process (clk,resetn,start)
    begin
        if resetn = '0' then
            i <= (CHAN_NUM * CHAN_WID) - 1;
        elsif rising_edge(clk) then
            if start = '1' then
                if i = 0 then
                    i <= (CHAN_NUM * CHAN_WID) - 1;
                else
                    i <= i - 1;
                end if;
            end if;
        end if;
    end process counter_proc;

end behavioral;
