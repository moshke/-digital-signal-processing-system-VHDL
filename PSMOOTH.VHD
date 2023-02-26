library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;

package Psmooth is	
function smooth(data: std_logic_vector)	return std_logic_vector;
end package Psmooth;

package body Psmooth is	
	function smooth(data: std_logic_vector) return std_logic_vector is
		variable tmp: std_logic_vector(44 downto 0);
		variable min: std_logic_vector(4 downto 0):= (others=>'1');
		variable max: std_logic_vector(4 downto 0):= (others=>'0');
		alias center: std_logic_vector(4 downto 0) is tmp(24 downto 20); --Center pixel
	begin
	
	tmp:= data;
	
	for i in 0 to 8 loop 
		
		 next when(i=4);
		 
		 if(tmp(44-(i*5) downto 40-(i*5)) < min) then 
		 min:= tmp(44-(i*5) downto 40-(i*5));
	    end if;
		 if(tmp(44-(i*5) downto 40-(i*5)) > max) then 
		 max:= tmp(44-(i*5) downto 40-(i*5));
		 end if;
	end loop;
	
	if (center < min) then center:= min;
	elsif (center > max) then center:= max;
	end if;
	
	return center; -- Return the center pixel
	end function smooth;
	end package body Psmooth;
	
	
	

