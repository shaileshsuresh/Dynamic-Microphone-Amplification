library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tdm_handler is
  port (
    clk      : in  std_logic;
    rstn     : in  std_logic;
    en       : in  std_logic;
    -- tdm
    fsync    : in  std_logic;
    bclk     : in  std_logic;
    sdin     : in  std_logic;
    sdout    : out std_logic);
end entity tdm_handler;

architecture archi_tdm_handler of tdm_handler is
  
  -- output 
  signal sdout_out  : std_logic;
begin
  -- output
  sdout <= sdout_out;
  sdout_out <= sdin;
  
end architecture archi_tdm_handler;
