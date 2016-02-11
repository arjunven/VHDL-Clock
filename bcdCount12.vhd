library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Given a clock input, this component counts from 1 to 12 in BCD.

entity bcdCount12 is
  port (
	clock, reset, load	: 	IN 	std_logic;
	latch				:	IN  std_logic;
	DHigh, DLow			:	IN 	std_logic_vector( 3 downto 0 );
	QHigh, QLow 		:	OUT	std_logic_vector( 3 downto 0 )
  ) ;
end entity ; -- bcdCount12

architecture behavior of bcdCount12 is
	signal LowDigit : std_logic_vector( 3 downto 0 );
	signal HighDigit: std_logic_vector( 3 downto 0 );

begin
	process ( clock, reset, load, latch, DHigh, DLow )
	begin
		if ( reset = '0' ) then -- reset
			LowDigit <= "0010";
			HighDigit <= "0001";

		elsif ( load = '1' and latch = '0' ) then
			 -- when load is high, and pushButton pressed, counts become the D values
				HighDigit <= DHigh;
				LowDigit <= DLow;

		elsif ( clock'event and clock = '1' ) then -- rising edge
			if ( LowDigit = 2 and HighDigit = 1 ) then -- maxed out low digit
				LowDigit <= "0001";
				HighDigit <= "0000";

			elsif ( LowDigit = 9 ) then
				LowDigit <= "0000";
				
				if ( HighDigit = 1 ) then -- maxed out high digit
					HighDigit <= "0000";

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