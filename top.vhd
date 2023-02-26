library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity top is
port 
(	clk		:	in std_logic;
	rst		:	in std_logic;
	start	:	in std_logic;
	
	done	:	out std_logic
);

attribute altera_chip_pin_lc: string;
attribute altera_chip_pin_lc of clk		: signal is "Y2";
attribute altera_chip_pin_lc of rst		: signal is "AB28";
attribute altera_chip_pin_lc of start	: signal is "AC28";
attribute altera_chip_pin_lc of done	: signal is "E21";
end entity top;

architecture arc_top of top is
component fsm is
port 
(		clk			: 	in std_logic;
		rst			: 	in std_logic;
		start		: 	in std_logic;
		
		push		: 	out std_logic;
		done		: 	out std_logic;
		write_en	: 	out std_logic;
		read_address : 	out std_logic_vector (7 downto 0);
		write_address: 	out std_logic_vector (7 downto 0)
);	
end component fsm;

component buffer_three_rows is
port 
(	clk			: in std_logic;
	rst			: in std_logic;
	push		: in std_logic;
	new_row		: in std_logic_vector (1279 downto 0);
	
	prev_row 	: out std_logic_vector (1289 downto 0);
	curr_row 	: out std_logic_vector (1289 downto 0);
	next_row 	: out std_logic_vector (1289 downto 0)
);
end component buffer_three_rows;

component Fsmooth is
port 
(		clk			:	in std_logic;
		rst			:	in std_logic;
		prev_row 	:	in std_logic_vector (1289 downto 0);
		curr_row 	:	in std_logic_vector (1289 downto 0);
		next_row 	:	in std_logic_vector (1289 downto 0);		
		
		proc_row	:	out std_logic_vector (1279 downto 0)
	);	
end component Fsmooth;

component ROM is 
	generic (init_ROM_name : string);
	port(
		aclr	: in std_logic  := '0';
		address	: in std_logic_vector (7 DOWNTO 0);
		clock	: in std_logic  := '1';
		q		: out std_logic_vector (1279 DOWNTO 0)
		);
end component;
	
component RAM is
	generic(inst_name: string);
	port
	(
		aclr	: in std_logic:= '0';
		address	: in std_logic_vector (7 DOWNTO 0);
		clock	: in std_logic:= '1';
		data	: in std_logic_vector(1279 DOWNTO 0);
		wren	: in std_logic;
		q		: out std_logic_vector(1279 DOWNTO 0)
	);
end component;

	type mem_row is array (natural range <>) of std_logic_vector(1279 downto 0); 	
	type buf_row is array (natural range <>) of std_logic_vector(1289 downto 0); 
	---------------------------------------
	constant mif_file_name_format: string := "x.mif";
	type ROM_str_arr is array (0 to 2) of string(mif_file_name_format'range);
	constant ROM_arr : ROM_str_arr := ("r.mif", "g.mif", "b.mif");
	------------------------------------------
	constant RAM_file_name_format: string := "xRAM";
	type     RAM_str_arr is array (0 to 2) of string(RAM_file_name_format'range);
	constant RAM_arr : RAM_str_arr := ("rRAM", "gRAM", "bRAM");
	------------------------------------------
	signal s_push,s_write_en: std_logic;
	signal s_read_address,s_write_address: std_logic_vector(7 downto 0);
	signal s_prev_row,s_curr_row,s_next_row: buf_row(2 downto 0);
	signal s_proc_row,s_new_row: mem_row(2 downto 0);
begin

u1:	fsm
port map
(	clk=> clk,
	rst=> rst,
	start=>	start,
	push=> s_push,
	done=> done,
	write_en=> s_write_en,
	read_address=> s_read_address,
	write_address=> s_write_address
);

L1: for i in 0 to 2 generate
	u2: buffer_three_rows
	port map 
	(	clk=> clk,
		rst => rst,
		push=> s_push,
		new_row=> s_new_row(i),
		prev_row=> s_prev_row(i),
		curr_row=> s_curr_row(i),
		next_row=> s_next_row(i)
	);
end generate L1;

L2: for i in 0 to 2 generate
	u3: Fsmooth
	port map (
		clk=> clk,
		rst=> rst,
		prev_row=> s_prev_row(i),
		curr_row=> s_curr_row(i),
		next_row=> s_next_row(i),
		proc_row=> s_proc_row(i)
		);
end generate L2;

L3: for i in 0 to 2 generate
	u4: entity work.ROM_256_1280
	generic map(
	init_ROM_name=> ROM_arr(i)
	)
	port map
	(
		aclr=> rst,
		address=> s_read_address,
		clock=> clk,
		q => s_new_row(i)

	);
end generate L3;

L4: for i in 0 to 2 generate
	u5: entity work.RAM_256_1280
	generic map(
	inst_name=> RAM_arr(i)
	)
	port map 
	(
		aclr=> rst,	
		address=> s_write_address,
		clock=>	clk,
		data=> s_proc_row(i),
		wren=> s_write_en,	
		q=>	open
	);
end generate L4;
end architecture arc_top;