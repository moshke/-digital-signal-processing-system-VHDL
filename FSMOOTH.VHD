library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
use work.Psmooth.all;

entity Fsmooth is
port (	clk			:	in std_logic;
		rst			:	in std_logic;
		prev_row 	:	in std_logic_vector (1289 downto 0);
		curr_row 	:	in std_logic_vector (1289 downto 0);
		next_row 	:	in std_logic_vector (1289 downto 0);		
		
		proc_row	:	out std_logic_vector (1279 downto 0)
	);	
end entity Fsmooth;

architecture arc_filter of Fsmooth is
begin
	process(clk,rst)
	variable tmp: std_logic_vector (1279 downto 0) := (others=>'0');
	variable data_9_pixels:  std_logic_vector (44 downto 0);
	begin
		if (rst = '1') then 
			proc_row		<=	(others=>'0');
		elsif rising_edge (clk) then
			for i in 0 to 255 loop
				data_9_pixels:= prev_row((1289-5*i) downto(1285-5*(i+2))) & curr_row((1289-5*i) downto(1285-5*(i+2))) & next_row((1289-5*i) downto(1285-5*(i+2)));
				tmp((1279-5*i) downto (1275-5*i)):=  smooth(data_9_pixels);
				
			end loop;
			proc_row<= tmp;
		end if;
	end process;
end architecture arc_filter;