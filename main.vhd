----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:02:55 11/26/2016 
-- Design Name: 
-- Module Name:    main - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
	port(
		CLK : in std_logic;
		RST : in std_logic;
		Hs  : out std_logic;
		Vs  : out std_logic;
		oRed: out std_logic_vector(2 downto 0);
		oGreen: out std_logic_vector(2 downto 0);
		oBlue: out std_logic_vector(2 downto 0)
	);
end main;

architecture Behavioral of main is
component VGAController is
	port (
		Hs : out std_logic;
		Vs : out std_logic;
		oRed  : out std_logic_vector(2 downto 0);
		oGreen: out std_logic_vector(2 downto 0);
		oBlue : out std_logic_vector(2 downto 0);
		RST : in std_logic;
		CLK: in std_logic		--50M ±÷” ‰»Î
	);
end component;
begin
	VGAControl : VGAController port map (
		Hs,Vs,oRed,oGreen,oBlue,RST,CLK);

end Behavioral;

