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
	type data_array is array (31 downto 0) of unsigned(7 downto 0);
	signal data : data_array;
	
	signal threshold : unsigned( 7 downto 0 );
	signal samplesSinceTrig : unsigned(15 downto 0);
	signal userSamplesSinceTrig : unsigned(15 downto 0);
	signal out_en_sig : std_logic;
	signal triggered : std_logic;--sets when we have a trigger and we are reading.  
begin
	--This large assignment block is needed because we need to 
	--interpolate the data switching between rising and falling for different samples.  
	--Take a set of rising samples
	data(0) <= unsigned(data_in(7 downto 0));--First sample
	data(1) <= unsigned(data_in(15 downto 8));
	data(2) <= unsigned(data_in(23 downto 16));
	data(3) <= unsigned(data_in(31 downto 24));
	--Take a set of falling samples
	data(4) <= unsigned(data_in(135 downto 128));
	data(5) <= unsigned(data_in(143 downto 136));
	data(6) <= unsigned(data_in(151 downto 144));
	data(7) <= unsigned(data_in(159 downto 152));
	--Take a set of rising sample
	data(8) <= unsigned(data_in(39 downto 32));
	data(9) <= unsigned(data_in(47 downto 40));
	data(10) <= unsigned(data_in(55 downto 48));
	data(11) <= unsigned(data_in(63 downto 56));  
	--Take a set of falling samples
	data(12) <= unsigned(data_in(167 downto 160));
	data(13) <= unsigned(data_in(175 downto 168));
	data(14) <= unsigned(data_in(183 downto 176));
	data(15) <= unsigned(data_in(191 downto 184));
	--Take a set of rising samples
	data(16) <= unsigned(data_in(71 downto 64));
	data(17) <= unsigned(data_in(79 downto 72));
	data(18) <= unsigned(data_in(87 downto 80));
	data(19) <= unsigned(data_in(95 downto 88));
	--Take a set of falling samples
	data(20) <= unsigned(data_in(199 downto 192));
	data(21) <= unsigned(data_in(207 downto 200));
	data(22) <= unsigned(data_in(215 downto 208));
	data(23) <= unsigned(data_in(223 downto 216));
	--Take a set of rising samples
	data(24) <= unsigned(data_in(103 downto 96));
	data(25) <= unsigned(data_in(111 downto 104));
	data(26) <= unsigned(data_in(119 downto 112));
	data(27) <= unsigned(data_in(127 downto 120));
	--Take a set of falling samples
	data(28) <= unsigned(data_in(231 downto 224));
	data(29) <= unsigned(data_in(239 downto 232));
	data(30) <= unsigned(data_in(247 downto 240));
	data(31) <= unsigned(data_in(255 downto 248));
	
	threshold <= unsigned(signal_threshold);
	userSamplesSinceTrig <= unsigned(user_samples_after_trig);
	out_enable <= out_en_sig;
	
	process(clk)
	
	begin
		
		data_out(7 downto 0) <= std_logic_vector(data(0));
		data_out(15 downto 8) <= std_logic_vector(data(1));
		data_out(23 downto 16) <= std_logic_vector(data(2));
		data_out(31 downto 24) <= std_logic_vector(data(3));
		data_out(39 downto 32) <= std_logic_vector(data(4));
		data_out(47 downto 40) <= std_logic_vector(data(5));
		data_out(55 downto 48) <= std_logic_vector(data(6));
		data_out(63 downto 56) <= std_logic_vector(data(7));
		data_out(71 downto 64) <= std_logic_vector(data(8));
		data_out(79 downto 72) <= std_logic_vector(data(9));
		data_out(87 downto 80) <= std_logic_vector(data(10));
		data_out(95 downto 88) <= std_logic_vector(data(11));
		data_out(103 downto 96) <= std_logic_vector(data(12));
		data_out(111 downto 104) <= std_logic_vector(data(13));
		data_out(119 downto 112) <= std_logic_vector(data(14));
		data_out(127 downto 120) <= std_logic_vector(data(15));
		data_out(135 downto 128) <= std_logic_vector(data(16));
		data_out(143 downto 136) <= std_logic_vector(data(17));
		data_out(151 downto 144) <= std_logic_vector(data(18));
		data_out(159 downto 152) <= std_logic_vector(data(19));
		data_out(167 downto 160) <= std_logic_vector(data(20));
		data_out(175 downto 168) <= std_logic_vector(data(21));
		data_out(183 downto 176) <= std_logic_vector(data(22));
		data_out(191 downto 184) <= std_logic_vector(data(23));
		data_out(199 downto 192) <= std_logic_vector(data(24));
		data_out(207 downto 200) <= std_logic_vector(data(25));
		data_out(215 downto 208) <= std_logic_vector(data(26));
		data_out(223 downto 216) <= std_logic_vector(data(27));
		data_out(231 downto 224) <= std_logic_vector(data(28));
		data_out(239 downto 232) <= std_logic_vector(data(29));
		data_out(247 downto 240) <= std_logic_vector(data(30));
		data_out(255 downto 248) <= std_logic_vector(data(31));
		
		in_enable <= '1';
		
		if(reset = '0') then--reset is low
			if(rising_edge(clk)) then--rising edge of clk and reset is low
				if(empty = '0' and triggered = '0') then --If we aren't currently triggered, test for trigger.  
				
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
					or data(15) > threshold
					or data(16) > threshold
					or data(17) > threshold
					or data(18) > threshold
					or data(19) > threshold
					or data(20) > threshold
					or data(21) > threshold
					or data(22) > threshold
					or data(23) > threshold
					or data(24) > threshold
					or data(25) > threshold
					or data(26) > threshold
					or data(27) > threshold
					or data(28) > threshold
					or data(29) > threshold
					or data(30) > threshold
					or data(31) > threshold) then--controlls start of trigger.  
						out_en_sig <= '1';
						triggered <= '1';
					end if;
				else
					if(triggered = '1' and samplesSinceTrig >= userSamplesSinceTrig)then--Our sample count matches the user request.  Turn off.  
						out_en_sig <= '0';
						samplesSinceTrig <= (others => '0');
						triggered <= '0';
					end if;
					
					if(triggered = '1' and empty = '0') then
						out_en_sig <= '1';
					end if;
					
					if(triggered = '1' and empty = '1') then
						out_en_sig <= '0';
					end if;
				end if;
				
				if(out_en_sig = '1')then --We took another sample.  Increase the sample count
					samplesSinceTrig <= samplesSinceTrig + 1;
				end if;
			end if;
		else--reset is high
			out_en_sig <= '0';
			samplesSinceTrig <= (others => '0');
			triggered <= '0';
		end if;
	end process;
end Behavioral;

