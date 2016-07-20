
-- VHDL Instantiation Created from source file psudoData.vhd -- 14:48:27 07/18/2016
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT psudoData
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		delay : OUT std_logic_vector(7 downto 0);
		rising_data : OUT std_logic_vector(31 downto 0);
		falling_data : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	Inst_psudoData: psudoData PORT MAP(
		clk => ,
		reset => ,
		delay => ,
		rising_data => ,
		falling_data => 
	);


