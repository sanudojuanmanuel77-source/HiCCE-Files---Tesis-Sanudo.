

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_Components is
--  Port ( );
end tb_Components;

architecture BEHAVIOR of tb_Components is

    COMPONENT Synchonizer
              port(
                CLK: IN STD_LOGIC;
                RST: IN STD_LOGIC;
                ASYNC: IN STD_LOGIC;
                SYNC: OUT STD_LOGIC 
                );
       END COMPONENT;  

    COMPONENT SPI_FSM
            port(
            clk:        IN STD_LOGIC;
            rst:        IN STD_LOGIC;
            data_ready: IN STD_LOGIC;
            CONN:       IN STD_LOGIC;
            en:         OUT STD_LOGIC;
            cnv:        OUT STD_LOGIC;
            local_rst:  OUT STD_LOGIC;
            settle:     OUT STD_LOGIC
              );
    END COMPONENT SPI_FSM;
    
    COMPONENT SCK_Generator
               port(
               
        en : in  std_logic;
        clk: in  std_logic;
        rst: in  std_logic;
        sck: out std_logic
     );
     
     END COMPONENT SCK_Generator;
     
     
     COMPONENT Shift_Register
                
                generic(
                        N : integer := 18;
                        DATA_WIDTH: integer := 18
                        ); 
               port(
               en: in std_logic;
               clk: in std_logic;
               sck: in std_logic; --NO como clk real... nos BUFG signal
               rst: in std_logic;
               sdo: in std_logic;
               data_ready: out std_logic;
               data_out: out std_logic_vector(DATA_WIDTH -3 downto 0)
                );
     END COMPONENT Shift_Register;
     
     COMPONENT Step_FSM
                Port(
                CNV: in std_logic;
                rst: in std_logic;
                clk: in std_logic;
                STEP: out std_logic
       );
     
     END COMPONENT Step_FSM;
     
     --SEÑALES DE "ENTRADA/SALIDA"
       SIGNAL CONN,CONN2,CLK,RST,SDO,STEP,SETTLE,CNV: STD_LOGIC := '0';
       --SIGNAL ASYNC,SYNC: STD_LOGIC := '0';
       
       SIGNAL test_vector: STD_LOGIC_VECTOR(17 DOWNTO 0) := "011110000111100001";

     --SEÑALES "INTERNAS"
     
       SIGNAL SCK,EN,LOCAL_RST,DATA_READY: STD_LOGIC := '0';
       
       SIGNAL DATA_OUT: STD_LOGIC_VECTOR (15 DOWNTO 0) := (others => '0');
     
       CONSTANT CLK_PERIOD: TIME := 10 ns;
   
begin
    
    --COMPONTENTS INSTANTIATION 
    UU0:Synchonizer
        PORT MAP
            (CLK=>CLK,
             RST => RST,
             ASYNC => CONN,
             SYNC=> CONN2
             );
        
     UU1:SPI_FSM
        PORT MAP(
              CLK => CLK,
              RST => RST, -- rst general
              DATA_READY=>DATA_READY, -- input
              CONN => CONN2, -- to the world
              EN => EN, -- output, to sck, y shift.
              CNV => CNV, -- to the world and step_fsm
              LOCAL_RST =>LOCAL_RST, --output
              SETTLE => SETTLE --to the wordl
               );
       
    UU2:SCK_Generator
        PORT MAP(
                CLK => CLK,
                EN => EN, --INPUT FROM SPI_FSM
                RST => LOCAL_RST,
                SCK => SCK  
                );
                
    UU3:Step_FSM
        PORT MAP(
                CLK => CLK,
                RST => LOCAL_RST,
                CNV => CNV,
                STEP => STEP
                );
    
    UU4:Shift_Register
        PORT MAP(
                CLK => CLK,
                EN => EN,
                SCK => SCK,
                RST => LOCAL_RST,
                SDO => SDO,
                DATA_READY => DATA_READY,
                DATA_OUT => DATA_OUT
        
        );
    
    
    
    
CLK_GENERATION:PROCESS
         BEGIN
         
         WHILE now < 95000 ns LOOP
         
                CLK <= '0';
                WAIT FOR CLK_PERIOD/2;
                CLK <= '1';
                WAIT FOR CLK_PERIOD/2;
                END LOOP;
                WAIT;
          END PROCESS CLK_GENERATION;

    
    STIMULUS: PROCESS
              BEGIN
              
              --inital reset
                RST <= '1';
                wait for 100 ns; -- El reset usa el fast settle del Intan... 340 microsegundos...
                RST <= '0';
                 --DEMACIADO... 
                CONN <= '1'; -- Se estabece conexión con el servidor.
                             -- mientras CONN = '0' se fuerza IDLE.
                wait for 1020 ns;
                wait for 900 ns; -- 900 cnv time. 60 ns MSB time.
                wait for 60 ns;
                sdo <= test_vector(17); -- AD7982 puso el MSB en SDO 
                
                
                -- sdo <= test_vector(17); --EL MSB APARECE LUEGO DE QUE CNV BAJA, TRAS 40 ns WORST  CASE
                -- Recorremos cada bit y lo ponemos 21 ns después del flanco negativo
                for i in 16 downto 0 loop -- CLARO PORQ EL MSB YA ESTA DISPONIBLE AL PRIMER FLANCO
                 wait until falling_edge(sck);
                    wait for 21 ns;  
                    sdo <= test_vector(i);  --
                    end loop;
                    
                
                    wait for 20 ns;
                    wait for 900 ns;
                    sdo <= test_vector(17);
                    wait for 60 ns;
                    for i in 16 downto 0 loop -- CLARO PORQ EL MSB YA ESTA DISPONIBLE AL PRIMER FLANCO
                 wait until falling_edge(sck);
                    wait for 21 ns;  
                    sdo <= test_vector(i);  --
                    end loop;
                
                   wait for 50 ns;
                   CONN <= '0';
                   wait for 700 ns;
                   CONN <= '1';
                   
                   wait for 320 ns;
                wait for 900 ns; -- 900 cnv time. 60 ns MSB time.
                wait for 60 ns;
                sdo <= test_vector(17);
                
                 for i in 16 downto 0 loop -- CLARO PORQ EL MSB YA ESTA DISPONIBLE AL PRIMER FLANCO
                 wait until falling_edge(sck);
                    wait for 21 ns;  
                    sdo <= test_vector(i);  --
                    end loop;
                    wait for CLK_PERIOD;
                    wait;
                
                
              END PROCESS STIMULUS;


end BEHAVIOR;
