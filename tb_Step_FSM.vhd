

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


---------------------------------------------------------------
ENTITY tb_Step_FSM IS
--  Port ( );
END tb_Step_FSM;
-----------------------------------------------------------------
ARCHITECTURE BEHAVIOR OF tb_Step_FSM IS

    SIGNAL cnv: std_logic := '0';
    SIGNAL rst: std_logic := '0';
    SIGNAL clk :std_logic := '0';
    SIGNAL STEP: std_logic;
    
    CONSTANT clk_period: time := 10 ns;
    

BEGIN

    UUT: entity work.Step_FSM
            port map (
            cnv  => CNV,
            rst => rst,
            clk => clk,
            STEP => STEP
            );
            
clk_generation: process
          begin
          while now < 6000 ns loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
          end loop;
          wait;
          end process;
          
     stimulus: process
               begin
               rst <= '1';
               wait for 30 ns;
               rst <= '0';
               wait for 60 ns;
               rst <= '0';
               wait for 230 ns;
               cnv <= '1';
               wait for 1500 ns;
               cnv <= '0';
               wait for 400 ns;
               cnv <= '1';
               wait for 50 ns;
               rst <= '1';
               wait for 20 ns;
               rst <= '0';
               
               wait;
             end process;
             
     


end BEHAVIOR;
