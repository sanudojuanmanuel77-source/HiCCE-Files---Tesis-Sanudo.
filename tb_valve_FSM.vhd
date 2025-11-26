
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_valve_FSM is
--  Port ( );
end tb_valve_FSM;

architecture BEHAVIOR of tb_valve_FSM is

CONSTANT clk_period: time := 10 ns;

SIGNAL clk,rst,last: STD_LOGIC := '0';

SIGNAL pulses: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";

SIGNAL enables: STD_LOGIC_VECTOR(3 DOWNTO 0);

begin


    uut: ENTITY work.valve_FSM 
           PORT MAP(
                    clk => clk,
                    rst=>rst,
                    last => last,
                    pulses => pulses,
                    enables => enables
                    );
          
          
        clk_gen: PROCESS
                 BEGIN
                    
                  WHILE now < 90000 ns LOOP
                    clk <= '0';
                    WAIT FOR clk_period/2;
                    clk <= '1';
                    WAIT FOR clk_period/2;
                 END LOOP;
                 WAIT;
                 END PROCESS;
                 
       stimulus: PROCESS
                 BEGIN
                 
                 rst <= '1';
                 wait for clk_period*3;
                 rst <= '0';
                 wait for clk_period*3;
                 
                 wait for 50 ns;
                 
                 pulses(1) <= '1';
                 wait for clk_period;
                 pulses(1) <= '0';
                 wait for 50 ns;
                 
                 pulses(3) <= '1';
                 wait for clk_period;
                 pulses(3) <= '0';
                 wait for 50 ns;
                 
                 pulses(0) <= '1';
                 wait for clk_period;
                 pulses(0) <= '0';
                 wait for 50 ns;
                 
                 pulses(2) <= '1';
                 wait for clk_period;
                 pulses(2) <= '0';
                 wait for 50 ns;
                 
                 wait for 300 ns;
                 
                 last <= '1';
                 wait for clk_period;
                 last <= '0';
                 
                 wait for 300 ns;
                 
                  
                 wait for 50 ns;
                 
                 pulses(1) <= '1';
                 wait for clk_period;
                 pulses(1) <= '0';
                 wait for 50 ns;
                 
                 pulses(3) <= '1';
                 wait for clk_period;
                 pulses(3) <= '0';
                 wait for 50 ns;
                 
                 pulses(0) <= '1';
                 wait for clk_period;
                 pulses(0) <= '0';
                 wait for 50 ns;
                 
                 pulses(2) <= '1';
                 wait for clk_period;
                 pulses(2) <= '0';
                 wait for 50 ns;
                 
                 wait for 300 ns;
                 
                 last <= '1';
                 wait for clk_period;
                 last <= '0';
                 
                 wait;
                 END PROCESS;

end BEHAVIOR;
