----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.07.2025 14:49:01
-- Design Name: 
-- Module Name: tb_SPI_FSM - BEHAVIOR
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_SPI_FSM is
--  Port ( );
end tb_SPI_FSM;

architecture BEHAVIOR of tb_SPI_FSM is

SIGNAL clk,rst,cnv,en,settle,local_rst,data_ready,CONN : STD_LOGIC := '0';

CONSTANT CLK_PERIOD: time := 10ns;


begin

    UUT: entity work.SPI_FSM
           port map (
                    clk => clk,
                    rst=> rst,
                    conn=>conn,
                    cnv=>cnv,
                    en=>en,
                    settle => settle,
                    data_ready=>data_ready,
                    local_rst=>local_rst
                    );


    clk_generation:process
                   begin
                   while now < 15000 ns loop
                         clk <= '0';
                         wait for CLK_PERIOD/2;
                         clk <= '1';
                         wait for CLK_PERIOD/2;
                         end loop;
                         wait;
                   end process;
                   
                   
     stimulus: process
               begin
               rst <= '1';
               wait for 70 ns;
               rst <= '0';
               wait for 1100 ns;
               conn <= '1';
               wait for 1000 ns;
               wait for 1100 ns;
               data_ready <= '1';
               wait for clk_period;
               data_ready <= '0';
               wait for 2040 ns;
               data_ready <='1';
               wait for clk_period;
               data_ready <='0';
               wait for 2040 ns;
                data_ready <='1';
               wait for clk_period;
               data_ready <='0';
               wait for 2040 ns;
                data_ready <='1';
               wait for clk_period;
               data_ready <='0';
               wait for 500 ns;
               conn <= '0';
               wait for 400 ns;
               conn <='1';
               wait for 2040 ns;
                data_ready <='1';
               wait for clk_period;
               data_ready <='0';
               wait for 2040 ns;
              
               
               
               
               
               wait;
               end process;
               
              
                   
                   

end BEHAVIOR;
