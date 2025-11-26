

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity tb_Intan_ADC_FSM is
--  Port ( );
end tb_Intan_ADC_FSM;

architecture BEHAVIOR of tb_Intan_ADC_FSM is

SIGNAL clk,rst,cnv,sdo,en,sck: STD_LOGIC := '0';

CONSTANT CLK_PERIOD: time := 10ns;
constant SCK_PERIOD: time := 60 ns;

begin

       UUT: entity work.Intan_ADC_FSM
       
        port map (
                clk=>clk,
                clr =>rst,
                sck=>sck,
                cnv=>cnv,
                en=>en,
                sdo=>sdo);

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
                    
    
stim_proc : process
    begin
        -- Reset inicial
        rst <= '1';
        sdo <= 'Z';
        wait for 50 ns;
        rst <= '0';
        sdo <= 'Z';
        wait for 10 ns;
        
        cnv <= '1';
        wait for 400 ns;
        cnv <= '0';
        sck <= '0';
        wait for 20 ns;
        en <= '1';
        
       -- Generar 18 pulsos de SCK
    for i in 0 to 17 loop
        sck <= '0';
        wait for SCK_PERIOD/2;
        sck <= '1';
        wait for SCK_PERIOD/2;
    end loop;
        sck <= '0';
        
       en <= '0';
       
       wait for 20 ns;
       
       cnv <= '1';
        wait for 400 ns;
        cnv <= '0';
        sck <= '0';
        wait for 20 ns;
        en <= '1';
        
       -- Generar 18 pulsos de SCK
    for i in 0 to 17 loop
        sck <= '0';
        wait for SCK_PERIOD/2;
        sck <= '1';
        wait for SCK_PERIOD/2;
    end loop;
    sck <= '0';
    wait for 20 ns;
    
    cnv <= '1';
        wait for 400 ns;
        cnv <= '0';
        sck <= '0';
        wait for 20 ns;
        en <= '1';
        
       -- Generar 18 pulsos de SCK
    for i in 0 to 17 loop
        sck <= '0';
        wait for SCK_PERIOD/2;
        sck <= '1';
        wait for SCK_PERIOD/2;
    end loop;
    sck <= '0';
    wait for 20 ns;
    
    wait;
end process;

end BEHAVIOR;
