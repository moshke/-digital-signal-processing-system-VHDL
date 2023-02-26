library ieee;
use ieee.std_logic_1164.all;

entity buffer_three_rows is
port 
(	clk			: in std_logic;
	rst			: in std_logic;
	push		: in std_logic;
	new_row		: in std_logic_vector (1279 downto 0);
	
	prev_row 	: out std_logic_vector (1289 downto 0);
	curr_row 	: out std_logic_vector (1289 downto 0);
	next_row 	: out std_logic_vector (1289 downto 0)
);	
end entity buffer_three_rows;

architecture arc_buffer_three_rows of buffer_three_rows is
signal 	prev_row_s 	: std_logic_vector (1289 downto 0)	:=	(others => '0');
signal	curr_row_s	: std_logic_vector (1289 downto 0)	:=	(others => '0');
signal	next_row_s 	: std_logic_vector (1289 downto 0)	:=	(others => '0');

begin
	process(clk, rst) is
	begin
		if (rst= '1') then
			prev_row_s<= (others => '0'); 	
			curr_row_s<= (others => '0');
			next_row_s<= (others => '0');
		
		elsif rising_edge(clk) then	
			if (push = '1') then
				prev_row_s<= curr_row_s; 	
				curr_row_s<= next_row_s;
				next_row_s<= new_row(1279 downto 1275) & new_row & new_row(4 downto 0);		
			end if;
		end if;
	end process;
	prev_row<= prev_row_s;
	curr_row<= curr_row_s;
	next_row<= next_row_s;
	
end architecture arc_buffer_three_rows;




