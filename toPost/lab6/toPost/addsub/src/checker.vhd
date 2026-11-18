-------------------------------------------------------------------------------
-- Dr. Kaputa
-- memory 
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      
use ieee.numeric_std.all;

entity checker is 
  port (
	clk          : in std_logic;
    reset        : in std_logic;
    exec         : in std_logic;
    data         : in std_logic_vector(7 downto 0);
	address      : out std_logic_vector(3 downto 0);
	output2      : out std_logic_vector(7 downto 0)
  );
end checker;

architecture beh of checker is

signal addr     :std_logic_vector(3 downto 0) := (others => '0');

begin 
process(clk)
begin
  if (clk'event and clk = '1') then
    if (exec = '1') then
      addr <= addr + '1';
	  address <= addr;
	  output2 <= data;
    else
    address <= "0000";
   end if;
  end if;
end process;

end beh; 