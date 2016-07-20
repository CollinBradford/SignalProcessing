----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:18:45 07/18/2016 
-- Design Name: 
-- Module Name:    psudoData - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity psudoData is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           delay : in  STD_LOGIC_VECTOR (7 downto 0);
           rising_data : out  STD_LOGIC_VECTOR (31 downto 0);
           falling_data : out  STD_LOGIC_VECTOR (31 downto 0));
end psudoData;

architecture Behavioral of psudoData is
signal counter : unsigned(7 downto 0);
signal counter_f : unsigned(7 downto 0);
signal delayCounter : unsigned(7 downto 0);
signal unsDelay : unsigned(7 downto 0);

begin
	unsDelay <= unsigned(delay);
	process(clk) begin
		rising_data(7 downto 0) <= std_logic_vector(counter);
		rising_data(15 downto 8) <= std_logic_vector(counter);
		rising_data(23 downto 16) <= std_logic_vector(counter);
		rising_data(31 downto 24) <= std_logic_vector(counter);
		
		falling_data(7 downto 0) <= std_logic_vector(counter_f);
		falling_data(15 downto 8) <= std_logic_vector(counter_f);
		falling_data(23 downto 16) <= std_logic_vector(counter_f);
		falling_data(31 downto 24) <= std_logic_vector(counter_f);
		
		if(reset = '0') then
			if(rising_edge(clk)) then
				counter <= counter + 1;
			end if;
			
			if(falling_edge(clk)) then
				counter_f <= counter_f + 1;
			end if;
		else
			counter <= (others => '0');
			counter_f <= (others => '0');
		end if;
	end process;
	
end Behavioral;

