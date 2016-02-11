library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
library altera;
use altera.altera_primitives_components.all;
use altera.maxplus2.all; 
library work;


entity Lab3 is
  port ( 
	KEY0, KEY1, KEY2, KEY3 :  IN   STD_LOGIC;
	SW9  :  IN   STD_LOGIC;
	CLK_50  :  IN   STD_LOGIC;
  	SW 	 :  IN   STD_LOGIC_VECTOR(7 DOWNTO 0);
  	HEX0 :  OUT  STD_LOGIC_VECTOR(0 TO 6);
	HEX1 :  OUT  STD_LOGIC_VECTOR(0 TO 6);
	HEX2 :  OUT  STD_LOGIC_VECTOR(0 TO 6);
	HEX3 :  OUT  STD_LOGIC_VECTOR(0 TO 6);
	HEX4 :  OUT  STD_LOGIC_VECTOR(0 TO 6);
	HEX5 :  OUT  STD_LOGIC_VECTOR(0 TO 6)
  ) ;
end Lab3 ; -- Lab3

architecture Behavior of Lab3 is

	component bcdto7seg
		port (
			BCD 	: 	IN 	STD_LOGIC_VECTOR(3 DOWNTO 0);
		  	DISPLAY : 	OUT STD_LOGIC_VECTOR(0 TO 6)
		);
	end component; -- bcdto7seg

	component bcdCount60
		port (
			clock, reset, load	: 	IN 	std_logic;
			latch 				: 	IN 	std_logic;
			DHigh, DLow			:	IN 	std_logic_vector( 3 downto 0 );
			QHigh, QLow 		:	OUT	std_logic_vector( 3 downto 0 );
			CLK_OUT				: 	BUFFER STD_LOGIC
		 ) ;
	end component; -- bcdCount60

	component bcdCount12
		port (
			clock, reset, load	: 	IN 	std_logic;
			latch				:	IN  std_logic;
			DHigh, DLow			:	IN 	std_logic_vector( 3 downto 0 );
			QHigh, QLow 		:	OUT	std_logic_vector( 3 downto 0 )
		 ) ;
	end component; -- bcdCount12

	component clockDivider
		port (
  			CLK_50	: IN	std_logic;
  			CLK_OUT : OUT 	std_logic
  			) ;
	end component; -- clockDivider


	signal seconds_clock, minutes_clock, hours_clock : STD_LOGIC;

	signal S_Low_Digit, S_High_Digit: STD_LOGIC_VECTOR( 3 downto 0 );
	signal SECONDS_MSD_7SEG, SECONDS_LSD_7SEG: STD_LOGIC_VECTOR( 0 to 6 );

	signal M_Low_Digit, M_High_Digit: STD_LOGIC_VECTOR( 3 downto 0 );
	signal MINUTES_MSD_7SEG, MINUTES_LSD_7SEG: STD_LOGIC_VECTOR( 0 to 6 );

	signal H_Low_Digit, H_High_Digit: STD_LOGIC_VECTOR( 3 downto 0 );
	signal HOURS_MSD_7SEG, HOURS_LSD_7SEG: STD_LOGIC_VECTOR( 0 to 6 );

begin
	HEX0 <= SECONDS_LSD_7SEG;
	HEX1 <= SECONDS_MSD_7SEG;
	HEX2 <= MINUTES_LSD_7SEG;
	HEX3 <= MINUTES_MSD_7SEG;
	HEX4 <= HOURS_LSD_7SEG;
	HEX5 <= HOURS_MSD_7SEG;


	-- slow down the clock from 50 MHz to 0.5 Hz
	slowDownClock: clockDivider 
		port map ( CLK_50, seconds_clock );

	-- counts the seconds
	secondsCount60: bcdCount60
		port map ( 
			clock => seconds_clock, 
			reset => KEY0, 
			load => SW9,
			latch => KEY1,
			Dhigh => SW ( 7 downto 4 ),
			DLow => SW ( 3 downto 0 ),
			QHigh => S_High_Digit,
		 	QLow => S_Low_Digit,
		 	CLK_OUT => minutes_clock
		 );

	-- prints seconds LSD
	printSecondsLSD: BCDto7Seg
		port map ( S_Low_Digit, SECONDS_LSD_7SEG );
	
	-- prints seconds MSD
	printSecondsMSD: BCDto7Seg
		port map ( S_High_Digit, SECONDS_MSD_7SEG );

	--
	minutesCount60: bcdCount60
		port map ( 
			clock => minutes_clock, 
			reset => KEY0, 
			load => SW9,
			latch => KEY2,
			Dhigh => SW ( 7 downto 4 ),
			DLow => SW ( 3 downto 0 ),
			QHigh => M_High_Digit,
		 	QLow => M_Low_Digit,
		 	CLK_OUT => hours_clock
		 );

	printMinutesLSD: BCDto7Seg
		port map ( M_Low_Digit, MINUTES_LSD_7SEG );

	printMinutesMSD: BCDto7Seg
		port map ( M_High_Digit, MINUTES_MSD_7SEG );

	hoursCount12: bcdCount12
		port map ( 
			clock => hours_clock, 
			reset => KEY0, 
			load => SW9,
			latch => KEY3,
			Dhigh => SW ( 7 downto 4 ),
			DLow => SW ( 3 downto 0 ),
			QHigh => H_High_Digit,
		 	QLow => H_Low_Digit
		 );

	printHoursLSD: BCDto7Seg
		port map ( H_Low_Digit, HOURS_LSD_7SEG );

	printHoursMSD: BCDto7Seg
		port map ( H_High_Digit, HOURS_MSD_7SEG );

	

end architecture ; -- Behavior



