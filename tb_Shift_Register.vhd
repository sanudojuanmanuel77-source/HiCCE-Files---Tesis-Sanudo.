-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.07.2025 15:55:03
-- Design Name: 
-- Module Name: tb_Shift_Register - BEHAVIOR
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


entity tb_Shift_Register is
--  Port ( );
end tb_Shift_Register;

architecture BEHAVIOR of tb_Shift_Register is

    signal clk: std_logic := '0';
    signal sck: std_logic := '0';
    signal rst: std_logic := '1';
    signal en:  std_logic :='0';
    signal sdo: std_logic := '0';
    signal data_ready: std_logic;
    signal data_out: std_logic_vector(17 downto 0);
    
    constant CLK_PERIOD: time := 10ns;
    constant SCK_PERIOD: time := 60 ns;

    --vector de prueba
    
    signal test_vector: std_logic_vector(17 downto 0) := "011110000111100001";
begin

    UUT: entity work.Shift_Register
        generic map(
           N => 18,
           DATA_WIDTH => 18
           )
        port map(
         en => en,
         sck => sck,
         clk => clk,
         rst => rst,
         sdo => sdo,
         data_ready => data_ready,
         data_out => data_out
        );
        
        
        
        clk_process: process
                    begin
                    while now < 6000 ns loop
                        clk <= '0';
                        wait for CLK_PERIOD/2;
                        clk <='1';
                        wait for CLK_PERIOD/2;
                     end loop;
                     wait;
                    end process;
                    
                    
         sck_genenartion: process
                          begin
                          while now < 6000 ns loop
                          sck <='0';
                          wait for sck_period/2;
                          sck <= '1';
                          wait for sck_period/2;
                          end loop;
                          end process;
                      
                          
        -- Proceso de estímulo
    stim_proc : process
    begin
        -- Reset inicial
        rst <= '1';
        sdo <= 'Z';
        wait for 50 ns;
        rst <= '0';
        sdo <= '0';
        wait for 10 ns;

        -- Activamos enable
        en <= '1';
        sdo <= test_vector(17); 
       -- sdo <= test_vector(17); --EL MSB APARECE LUEGO DE QUE CNV BAJA, TRAS 40 ns WORST  CASE
        wait for 35 ns;
        -- Recorremos cada bit y lo ponemos 21 ns después del flanco negativo
        for i in 16 downto 0 loop -- CLARO PORQ EL MSB YA ESTA DISPONIBLE AL PRIMER FLANCO
            wait until falling_edge(sck);
            wait for 21 ns;  
            sdo <= test_vector(i);  --
        end loop;
        wait for 50 ns;
        -- Desactivamos enable y finalizamos
        en <= '0';

        wait for 100 ns;
         -- Activamos enable
        en <= '1';
        sdo <= test_vector(17); 
       -- sdo <= test_vector(17); --EL MSB APARECE LUEGO DE QUE CNV BAJA, TRAS 40 ns WORST  CASE
        wait for 35 ns;
        -- Recorremos cada bit y lo ponemos 21 ns después del flanco negativo
        for i in 16 downto 0 loop -- CLARO PORQ EL MSB YA ESTA DISPONIBLE AL PRIMER FLANCO
            wait until falling_edge(sck);
            wait for 21 ns;  
            sdo <= test_vector(i);  --
        end loop;
        wait for 50 ns;
        en <= '0';
        
        wait for 100 ns;


        wait;
    end process;
                    
end BEHAVIOR;
