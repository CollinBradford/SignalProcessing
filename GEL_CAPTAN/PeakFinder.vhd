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
			  data_in : in  STD_LOGIC_VECTOR (255 downto 0);
			  signal_threshold : in STD_LOGIC_VECTOR(7 downto 0);
			  user_samples_after_trig : in std_logic_vector(15 downto 0);
           empty : in  STD_LOGIC;
			  data_valid : in std_logic;
           data_out : out  STD_LOGIC_VECTOR (255 downto 0);
           out_enable : out  STD_LOGIC;
			  in_enable : out std_logic);
end PeakFinder;

architecture Behavioral of PeakFinder is
	type data_array is array (0 to 15) of unsigned(7 downto 0);
	signal data : data_array;
	
	signal threshold : unsigned( 7 downto 0 );
	signal samplesSinceTrig : unsigned(15 downto 0);
	signal userSamplesSinceTrig : unsigned(15 downto 0);
	signal out_en_sig : std_logic;
begin
	data(0) <= unsigned(data_in(7 downto 0));--First sample
	data(1) <= unsigned(data_in(15 downto 8));
	data(2) <= unsigned(data_in(23 downto 16));
	data(3) <= unsigned(data_in(31 downto 24));
	data(4) <= unsigned(data_in(39 downto 32));
	data(5) <= unsigned(data_in(47 downto 40));
	data(6) <= unsigned(data_in(55 downto 48));
	data(7) <= unsigned(data_in(63 downto 56));--throught the 
	data(8) <= unsigned(data_in(71 downto 64));
	data(9) <= unsigned(data_in(79 downto 72));
	data(10) <= unsigned(data_in(87 downto 80));
	data(11) <= unsigned(data_in(95 downto 88));
	data(12) <= unsigned(data_in(103 downto 96));
	data(13) <= unsigned(data_in(111 downto 104));
	data(14) <= unsigned(data_in(119 downto 112));
	data(15) <= unsigned(data_in(127 downto 120));--Last sample
	
	threshold <= unsigned(signal_threshold);
	userSamplesSinceTrig <= unsigned(user_samples_after_trig);
	out_enable <= out_en_sig;
	
	process(clk)
	
	begin
		in_enable <= '1';
		
		if(reset = '0') then--reset is low
			if(rising_edge(clk)) then--rising edge of clk and reset is low
				if(empty = '0') then
				
					if (data(0) > threshold
					or data(1) > threshold
					or data(2) > threshold
					or data(3) > threshold
					or data(4) > threshold
					or data(5) > threshold
					or data(6) > threshold
					or data(7) > threshold
					or data(8) > threshold
					or data(9) > threshold
					or data(10) > threshold
					or data(11) > threshold
					or data(12) > threshold
					or data(13) > threshold
					or data(14) > threshold
					or data(15) > threshold) then--controlls start of trigger.  
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

