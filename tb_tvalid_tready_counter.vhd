
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



ENTITY tb_tvalid_tready_counter IS
--  Port ( );
END tb_tvalid_tready_counter;

ARCHITECTURE BEHAVIOR OF tb_tvalid_tready_counter IS

CONSTANT clk_period: time := 10 ns;

SIGNAL clk,rst: STD_LOGIC := '0';

SIGNAL tvalid,tready: STD_LOGIC := '0';

SIGNAL full: STD_LOGIC := '0';


BEGIN


    uut: ENTITY work.tvalid_tready_counter
         
         PORT MAP(
                  clk => clk,
                  rst => rst,
                  tvalid => tvalid,
                  tready => tready,
                  full => full);
                 


    clk_pr: PROCESS
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
               tready <= '1';
               wait for clk_period*3;
               
               rst <= '0';
               wait for 10 ns;
               for i in 0 to 512 loop
                tvalid <= '1';
                wait for clk_period;
                tvalid <= '0';
                wait for clk_period *4;
              end loop;
              
              wait for 200 ns;
              
              wait;
              
              END PROCESS;
                 
                    
               

END BEHAVIOR;
