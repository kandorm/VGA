----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:06:08 11/26/2016 
-- Design Name: 
-- Module Name:    VGAController - Behavioral 
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGAController is
	port (
		Hs : out std_logic;
		Vs : out std_logic;
		oRed  : out std_logic_vector(2 downto 0);
		oGreen: out std_logic_vector(2 downto 0);
		oBlue : out std_logic_vector(2 downto 0);
		RST : in std_logic;
		CLK: in std_logic		--50M时钟输入
	);
end VGAController;

architecture Behavioral of VGAController is

signal CLK_2 : std_logic;
signal rt, gt, bt : std_logic_vector(2 downto 0);
signal hst, vst : std_logic;
signal x : std_logic_vector(9 downto 0);  --x坐标
signal y : std_logic_vector(8 downto 0);	--y坐标
begin
	-----------------二分频---------------------
	process(CLK)
	begin
		if(CLK'event and CLK='1') then
			CLK_2 <= not CLK_2;
		end if;
	end process;
	----------------行区间像素数（含消隐区）----------------
	process(CLK_2, RST)
	begin
		if(RST='0')then
			x <= (others => '0');
		elsif(CLK_2'event and CLK_2='1')then
			if(x = 799)then
				x <= (others => '0');
			else
				x <= x + 1;
			end if;
		end if;
	end process;
	----------------场区间行数（含消隐区）----------------
	process(CLK_2, RST)
	begin
		if(RST='0')then
			y <= (others => '0');
		elsif(CLK_2'event and CLK_2='1')then
			if(x=799)then
				if(y=524)then
					y <= (others => '0');
				else
					y <= y + 1;
				end if;
			end if;
		end if;
	end process;
	---------------行同步信号产生------------------------
	process(CLK_2, RST)
	begin
		if(RST = '0')then
			hst <= '1';
		elsif(CLK_2'event and CLK_2='1')then
			if(x >= 656 and x < 752)then
				hst <= '0';
			else
				hst <= '1';
			end if;
		end if;		
	end process;
	---------------场同步信号产生-----------------------
	process(CLK_2, RST)
	begin
		if(RST = '0')then
			vst <= '1';
		elsif(CLK_2'event and CLK_2='1')then
			if(y >= 490 and y < 492)then
				vst <= '0';
			else
				vst <= '1';
			end if;
		end if;
	end process;
	--------------行同步信号输出-----------------------
	process(CLK_2, RST)
	begin
		if(RST = '0')then
			Hs <= '0';
		elsif(CLK_2'event and CLK_2='1')then
			Hs <= hst;
		end if;
	end process;
	--------------场同步信号输出---------------------
	process(CLK_2, RST)
	begin
		if(RST = '0')then
			Vs <= '0';
		elsif(CLK_2'event and CLK_2='1')then
			Vs <= vst;
		end if;
	end process;
	-----------------------------------------------
	-----------------------------------------------
	process(RST, CLK_2, x, y)
	begin
		if(RST = '0')then
			rt <= "000";
			gt <= "000";
			bt <= "000";
		elsif(CLK_2'event and CLK_2='1')then
			if(x > 0 and x < 213)then
				rt <= "000";
				bt <= "111";
			elsif(x >= 213 and x<426)then
				rt <= "111";
				bt <= "000";
			else
				rt <= "111";
				bt <= "111";
			end if;
			
			if(y < 240)then
				gt <= "111";
			else
				gt <= "000";
			end if;
		end if;
	end process;
	-------------------色彩输出-----------------------
	process(hst, vst, rt, gt, bt)
	begin
		if(hst = '1' and vst = '1')then
			oRed <= rt;
			oGreen <= gt;
			oBlue <= bt;
		else
			oRed <= (others => '0');
			oGreen <= (others => '0');
			oBlue <= (others => '0');
		end if;
	end process;
end Behavioral;