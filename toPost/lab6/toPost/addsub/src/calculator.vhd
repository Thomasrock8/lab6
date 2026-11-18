-------------------------------------------------------------------------------
-- Dr. Kaputa
-- blink top
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;

entity calculator is
  port (
      clk           : in  std_logic; 
      reset         : in  std_logic;
      execute       : in  std_logic;
      switch        : in  std_logic_vector(7 downto 0);
      op            : in  std_logic_vector(1 downto 0);
      bcd_0         : out std_logic_vector(6 downto 0);
      bcd_1         : out std_logic_vector(6 downto 0);
      bcd_2         : out std_logic_vector(6 downto 0)
  );
end calculator;

architecture beh of calculator is

signal a            :std_logic_vector(7 downto 0);
signal b            :std_logic_vector(7 downto 0);
signal button_s     :std_logic;
signal op_s         :std_logic_vector(1 downto 0);
signal output       :std_logic_vector(7 downto 0);
signal output_pad   :std_logic_vector(11 downto 0);
signal out1s        :std_logic_vector(3 downto 0);
signal out10s       :std_logic_vector(3 downto 0);
signal out100s      :std_logic_vector(3 downto 0);
signal output2      :std_logic_vector(7 downto 0);
signal adr          :std_logic_vector(3 downto 0);

signal mult_temp    :std_logic_vector(15 downto 0);
signal div_temp     :std_logic_vector(7 downto 0);

begin
output_pad <= "0000" & output2;

mult_temp <= std_logic_vector(unsigned(a) * unsigned(b));
div_temp  <= std_logic_vector(unsigned(a) / unsigned(b));

process(output,a,b,op_s,mult_temp,div_temp)
  begin
    if (reset = '1') then 
      output <= (others => '0');
    elsif (op_s = "00") then
      output  <= std_logic_vector(unsigned(a) + unsigned(b));
    elsif (op_s = "01") then
      output  <= std_logic_vector(unsigned(a) - unsigned(b));
    elsif (op_s = "10") then
      output  <= mult_temp(7 downto 0);
    else
      output  <= div_temp;
    end if;
  end process;

uutr1: synchronizer_8bit
  port map(        
    clk            => clk,
    reset          => reset,
    async_in       => switch,
    sync_out       => b
  );
  
  uutr2: rising_edge_synchronizer
  port map(        
    clk            => clk,
    reset          => reset,
    input          => execute,
    edge           => button_s
  );
  
  uutr3: synchronizer_2bit
  port map(        
    clk            => clk,
    reset          => reset,
    async_in       => op,
    sync_out       => op_s
  );
  
    uutm: memory
  port map(        
    clk            => clk,
    we             => '1',
    din            => output2,
    addr           => adr,
	dout           => a
  );
  
    uutc: checker
  port map(        
    clk            => clk,
    reset          => reset,
	exec           => button_s,
    data           => output,
	output2        => output2,
    address        => adr
  );

  uutdd: double_dabble
  port map(        
    result_padded => output_pad,
    ones          => out1s,
    tens          => out10s,
    hundreds      => out100s
  );

uuts1: seven_seg
  port map(        
    clk            => clk,
    reset          => reset,
    bcd            => out1s,
    seven_seg_out  => bcd_0
  );
  
  uuts2: seven_seg
  port map(        
    clk            => clk,
    reset          => reset,
    bcd            => out10s,
    seven_seg_out  => bcd_1
  );
  
  uuts3: seven_seg
  port map(        
    clk            => clk,
    reset          => reset,
    bcd            => out100s,
    seven_seg_out  => bcd_2
  );
  end beh;