library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Given a clock input, this component counts to 60 in BCD.

entity bcdCount60 is
  port (
	clock, reset, load	: 	IN 	std_logic;
	latch 				:   IN 	std_logic;
	DHigh, DLow			:	IN 	std_logic_vector( 3 downto 0 );
	QHigh, QLow 		:	OUT	std_logic_vector( 3 downto 0 );
	CLK_OUT				:	BUFFER std_logic
  ) ;
end entity ; -- bcdCount60

architecture behavior of bcdCount60 is
	signal LowDigit : std_logic_vector( 3 downto 0 );
	signal HighDigit: std_logic_vector( 3 downto 0 );

begin
	process ( clock, reset, load, latch, DHigh, DLow )
	begin
		if ( reset = '0' ) then -- reset
			LowDigit <= "0000";
			HighDigit <= "0000";

		elsif ( load = '1' and latch = '0' ) then
			 -- when load is high, and pushButton pressed, counts become the D values
				HighDigit <= DHigh;
				LowDigit <= DLow;
				CLK_OUT <= '0'; -- reset clock so that rising transition can occur
			
		elsif ( clock'event and clock = '1' and load = '0' ) then -- rising edge
			if ( LowDigit = 9 ) then -- maxed out low digit
				LowDigit <= "0000";

				if ( HighDigit = 2 ) then -- reset clock half at 30 seconds
					CLK_OUT <= '0';
				end if ;
			
				if ( HighDigit = 5 ) then -- maxed out high digit
					HighDigit <= "0000";
					CLK_OUT <= not CLK_OUT; -- transition 
				else 
					HighDigit <= HighDigit + '1'; -- keep counting high digit
				end if;

			else
				LowDigit <= LowDigit + '1'; -- keep counting low digit
			end if;
				
		end if;

	end process; 

	QHigh <= HighDigit;
	QLow <= LowDigit;

end architecture ; -- behavior