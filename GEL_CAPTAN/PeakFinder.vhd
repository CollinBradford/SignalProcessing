----------------------------------------------------------------------------------
-- Company: Fermilab
-- Engineer: Collin Bradford
-- 
-- Create Date:    13:51:43 07/07/2016 
-- Design Name: 
-- Module Name:    PeakFinder - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PeakFinder is
    Port ( clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  data_in : in  STD_LOGIC_VECTOR (127 downto 0);
			  signal_threshold : in STD_LOGIC_VECTOR(7 downto 0);
			  user_samples_after_trig : in std_logic_vector(15 downto 0);
           empty : in  STD_LOGIC;
			  data_valid : in std_logic;
           data_out : out  STD_LOGIC_VECTOR (127 downto 0);
           out_enable : out  STD_LOGIC;
			  in_enable : out std_logic);
end PeakFinder;

architecture Behavioral of PeakFinder is
	signal partOne : unsigned( 7 downto 0 );
	signal threshold : unsigned( 7 downto 0 );
	signal samplesSinceTrig : unsigned(15 downto 0);
	signal userSamplesSinceTrig : unsigned(15 downto 0);
	signal out_en_sig : std_logic;
begin
	partOne <= unsigned(data_in(7 downto 0));
	threshold <= unsigned(signal_threshold);
	userSamplesSinceTrig <= unsigned(user_samples_after_trig);
	out_enable <= out_en_sig;
	
	process(clk)
	
	begin
		in_enable <= '1';
		
		if(reset = '0') then--reset is low
			if(rising_edge(clk)) then--rising edge of clk and reset is low
				if(empty = '0') then
				
					if (partOne > threshold) then--controlls start of trigger.  
						data_out <= data_in;
						out_en_sig <= '1';
					else
						if(samplesSinceTrig >= userSamplesSinceTrig)then--Our sample count matches the user request.  Turn off.  
							out_en_sig <= '0';
							samplesSinceTrig <= (others => '0');
						end if;
					end if;
					
					if(out_en_sig = '1')then --We took another sample.  Increase the sample count
						samplesSinceTrig <= samplesSinceTrig + 1;
					end if;
					
				end if;
			end if;
		else--reset is high
			out_en_sig <= '0';
			samplesSinceTrig <= (others => '0');
		end if;
	end process;
end Behavioral;

