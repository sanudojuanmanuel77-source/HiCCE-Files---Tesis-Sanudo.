

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_SYS_RESET is
--  Port ( );
end tb_SYS_RESET;

architecture BEHAVIOR of tb_SYS_RESET is

COMPONENT proc_sys_reset_0
  PORT (
    slowest_sync_clk : IN STD_LOGIC;
    ext_reset_in : IN STD_LOGIC;
    aux_reset_in : IN STD_LOGIC;
    mb_debug_sys_rst : IN STD_LOGIC;
    dcm_locked : IN STD_LOGIC;
    mb_reset : OUT STD_LOGIC;
    bus_struct_reset : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    peripheral_reset : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    interconnect_aresetn : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    peripheral_aresetn : OUT STD_LOGIC_VECTOR(0 DOWNTO 0) 
  );
END COMPONENT;

SIGNAL slowest_sync_clk,ext_reset_in,aux_reset_in,mb_debug_sys_rst,dcm_locked,mb_reset: STD_LOGIC := '0'; 

SIGNAL bus_struct_reset,peripheral_reset,interconnect_aresetn,peripheral_aresetn: STD_LOGIC_VECTOR(0 DOWNTO 0):= (OTHERS => '0'); 

CONSTANT clk_period: time := 10 ns;

begin

uut: proc_sys_reset_0 
    PORT MAP(
             slowest_sync_clk => slowest_sync_clk,
             ext_reset_in => ext_reset_in,
             aux_reset_in => aux_reset_in,
             mb_debug_sys_rst => mb_debug_sys_rst,
             dcm_locked => dcm_locked,
             mb_reset => mb_reset,
             bus_struct_reset => bus_struct_reset,
             peripheral_reset => peripheral_reset,
             interconnect_aresetn => interconnect_aresetn,
             peripheral_aresetn => peripheral_aresetn
            );
            
            
           clk_generation: PROCESS
                    BEGIN
                    WHILE now < 6000 ns LOOP
                    
                        slowest_sync_clk <= '0';
                        WAIT FOR clk_period/2;
                        slowest_sync_clk <= '1';
                        WAIT FOR clk_period/2;
                    END LOOP;
                    WAIT;
                    END PROCESS clk_generation;
                     
    STIMULIS: PROCESS
              BEGIN
               dcm_locked <= '1';
              ext_reset_in <= '1';
            
              wait for 50 ns;
             
              
              wait for 1000 ns;
              ext_reset_in <= '0';
              wait for clk_period;
              ext_reset_in <= '1';
              wait for 600ns;
              -- ext_reset_in <= '1';
               
            wait for 50 ns;
            aux_reset_in <= '1';
            wait for clk_period;
            aux_reset_in <= '0';
            wait for 600 ns;
           -- aux_reset_in <= '0';
            wait;
            
            END PROCESS;


end BEHAVIOR;
