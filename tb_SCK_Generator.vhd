----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.07.2025 12:24:41
-- Design Name: 
-- Module Name: tb_SCK_Generator - BEHAVIOR
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
use IEEE.numeric_std.all;
--------------------------------------------------------------------------------------

entity tb_SCK_Generator is
--  Port ( );
end tb_SCK_Generator;
------------------------------------------------------------------------------------------------
architecture BEHAVIOR of tb_SCK_Generator is

    signal clk: std_logic := '0';
    signal rst: std_logic := '1';
    signal en : std_logic := '0';
    signal sck: std_logic;
    
    --Div parameter
    constant DIV_VALUE : integer := 2;
    
    
begin


    UUT: entity work.SCK_Generator
         generic map(
            DIV_VALUE => DIV_VALUE           
            )
         port map(
         
            en => en,
            clk => clk,
            rst => rst,
            sck => sck
         );
         
  
    clk_process: process
                begin
                while now < 2000 ns loop
                
                    clk <= '0'; wait for 5 ns;
                    clk <= '1'; wait for 5 ns;
                end loop;
                wait;
                end process;
                
-- Proceso de estímulo
    stim_proc : process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 50 ns;
        en <= '1';
        wait for 200 ns;
        en <= '0';
        wait for 150 ns;
        en <='1';
        wait for 100 ns;
        en <='0';

        wait;
    end process;


end BEHAVIOR;
