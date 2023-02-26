library ieee;
use ieee.std_logic_1164.all;

entity tb is
end entity;

architecture behavior of tb is
    -- Clock period of 12ns
    constant clk_pulse : time := 10 ns;
    
    -- Signal to drive the clock
    signal clk : std_logic := '0';
    
    -- Reset signal
    signal rst : std_logic;
    
    -- Start signal
    signal start : std_logic;
    
    -- Output of the entity under test
    signal done : std_logic;
    
begin
    -- Generate a clock signal with a 10ns period
    clk_process : process
    begin
        clk <= '0';
        wait for clk_pulse / 2;
        clk <= '1';
        wait for clk_pulse / 2;
    end process clk_process;
    
    -- Instantiate the entity under test
    dut : entity work.top
        port map (
            clk => clk,
            rst => rst,
            start => start,
            done => done
        );
    
    -- Stimulus process
    stim_process : process
    begin
        -- Assert reset for one clock cycle
        rst <= '1';
        wait for clk_pulse;
        rst <= '0';
        
        -- Wait for 10 clock cycles
        for i in 1 to 10 loop
            wait for clk_pulse;
        end loop;
        
        -- Assert the start signal for one clock cycle
        start <= '1';
        wait for clk_pulse;
        start <= '0';
   
        -- Wait for 265 more clock cycles
        for i in 1 to 265 loop
            wait for clk_pulse;
        end loop;
    end process;
end architecture;
