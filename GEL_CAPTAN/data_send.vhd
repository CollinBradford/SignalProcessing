----------------------------------------------------------------------------------
-- Company: Fermilab
-- Engineer: Collin Bradford
-- 
-- Create Date:    10:14:49 07/08/2016 
-- Design Name: 
-- Module Name:    data_send - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_send is
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           din : in  STD_LOGIC_VECTOR (63 downto 0);
           empty : in  STD_LOGIC;
           b_enable : in  STD_LOGIC;
           throttle : in  STD_LOGIC;
           b_data : out  STD_LOGIC_VECTOR (63 downto 0);
           b_data_we : out  STD_LOGIC);
end data_send;

architecture Behavioral of data_send is

signal count_delay : unsigned(2 downto 0);

begin
	
	process(clk, b_enable, throttle) 
	begin
		if(rst = '0') then
			if(empty = '0') then
				if(rising_edge(clk)) then
					b_data_we <= '0';
					
					count_delay <= count_delay + 1;
					if(count_delay = 5) then
						count_delay <= (others => '0');
						b_data_we <= '1';
					end if;
				end if;
			end if;
		else--reset code here
		end if;
	end process;
	
	b_data <= din;
	
end Behavioral;

