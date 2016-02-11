library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Divides 50Mhz clock pulse to .5Hz

entity clockDivider is
  port (
  	CLK_50	: IN	std_logic;
  	CLK_OUT : BUFFER 	std_logic
  	) ;
end entity ; -- clockDivider

architecture behavior of clockDivider is

	signal Internal_Count: 	STD_LOGIC_VECTOR( 28 downto 0 );

begin
	process( CLK_50 )
	begin
		if (CLK_50'event and CLK_50 = '1') then
			if Internal_Count < 25000000 then
				Internal_Count <= Internal_Count + 1;
			else
				Internal_Count <= (others => '0');
				CLK_OUT <= not CLK_OUT;
			end if;
		end if;		
	end process ; -- divide clock

end behavior ; -- behavior