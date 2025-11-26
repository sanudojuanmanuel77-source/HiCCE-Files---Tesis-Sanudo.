
LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY tb_full_y_dummy IS
--  Port ( );
END tb_full_y_dummy;

ARCHITECTURE BEHAVIOR OF tb_full_y_dummy IS

CONSTANT N: INTEGER := 4;
CONSTANT DW: INTEGER := 16;

CONSTANT clk_period: time := 10 ns;


    --Functional Signals
SIGNAL clk,rst   : STD_LOGIC := '0';

    --Glue FSM signals INYECTION SIGNLAS
SIGNAL data_ready: STD_LOGIC_VECTOR (N-1 DOWNTO 0) := (OTHERS => '0');
SIGNAL data_out  : STD_LOGIC_VECTOR(N*DW -1 DOWNTO 0):= (OTHERS => '0');   

SIGNAL m_tready,m_tvalid: STD_LOGIC_VECTOR (N-1 DOWNTO 0) := (OTHERS => '0');
SIGNAL m_tdata:STD_LOGIC_VECTOR( N*DW -1 DOWNTO 0 ) := (OTHERS => '0');

    
    --tvalid tready counter SIGNALS
SIGNAL tvalid,tready,full: STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');

    -- MUX NOT Singals
SIGNAL sel,input,output: STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS =>'0');

-- FIFOs

-- Interface de salida de la FIFO (lado M_AXIS). CUATRO FIFO
  SIGNAL f_tvalid    : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
  SIGNAL f_tdata     : STD_LOGIC_VECTOR(N*DW -1  DOWNTO 0);
  SIGNAL f_tready    : STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');  -- lo maneja el consumidor del TB
  SIGNAL f_tcount_data     : STD_LOGIC_VECTOR(N*32 -1 DOWNTO 0);
  SIGNAL aresetn  : STD_LOGIC :='0';

-- valve FSM

SIGNAL last: STD_LOGIC := '0';
SIGNAL pulses:   STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
SIGNAL       enables:  STD_LOGIC_VECTOR (3 DOWNTO 0);


--SWITCH signals

SIGNAL switch_s_axis_tvalid: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL switch_s_axis_tready: STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '1');
SIGNAL switch_s_axis_tdata: STD_LOGIC_VECTOR(63 DOWNTO 0);

SIGNAL switch_m_axis_tvalid: STD_LOGIC_VECTOR(0 DOWNTO 0); --porq asi esta definido el IP
SIGNAL switch_m_axis_tready: STD_LOGIC_VECTOR(0 DOWNTO 0); 
SIGNAL switch_m_axis_tdata: STD_LOGIC_VECTOR(15 DOWNTO 0);

-- not used
SIGNAL s_req_suppress: STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
SIGNAL s_decode_err :  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');

COMPONENT axis_data_fifo_0
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
  );
END COMPONENT;

COMPONENT axis_switch_0
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axis_tready : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axis_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axis_tready : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axis_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_req_suppress : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_decode_err : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) 
  );
END COMPONENT;

COMPONENT axis_data_fifo_FINAL
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) 
  );
END COMPONENT;









-- FINAL FIFO

SIGNAL final_m_tvalid,final_m_tready: STD_LOGIC;
SIGNAL final_m_tdata: STD_LOGIC_VECTOR(15 DOWNTO 0);


SIGNAL switch_m_tvalid_adaptation_1bit,switch_m_tready_adaptation_1bit: STD_LOGIC ;

-- alias = referencias de 1 bit a los puertos (0 downto 0)
alias sw_m_tvalid : std_logic is switch_m_axis_tvalid(0);
alias sw_m_tready : std_logic is switch_m_axis_tready(0);
----- FSMSSS
--- NUEVO --- NUEVO spi fsm
SIGNAL CONN : STD_LOGIC:= '0';
SIGNAL CNV,enables_spi,LOCAL_RST,settle: STD_LOGIC_VECTOR(3 DOWNTO 0):=(OTHERS =>'0');
--
-- SHIFT REG
SIGNAL DATA_READY_shift: STD_LOGIC_VECTOR(3 DOWNTO 0):= (OTHERS =>'0');
SIGNAL data_out_prev:  STD_LOGIC_VECTOR(N*DW -1 DOWNTO 0):= (OTHERS => '0'); 
SIGNAL SDO: STD_LOGIC_VECTOR(3 DOWNTO 0):=(OTHERS =>'0');

-- sck
SIGNAL SCK: STD_LOGIC_VECTOR(3 DOWNTO 0):=(OTHERS =>'0');

--step fms
SIGNAL STEP: STD_LOGIC_VECTOR(3 DOWNTO 0):=(OTHERS =>'0');

--SYNCRHO
SIGNAL SYNC:STD_LOGIC_VECTOR(3 DOWNTO 0):=(OTHERS =>'0');

type slv16_array_t is array (0 to 3) of std_logic_vector(17 downto 0);
constant CONST : slv16_array_t := (
  0 => B"000000000000010101",  -- A
  1 => B"000000000000010111",  -- B
  2 => B"000000000000011001",  -- C
  3 => B"000000000000011011"   -- D
);


SIGNAL producto_logico: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
BEGIN



switch_m_tvalid_adaptation_1bit <=  sw_m_tvalid AND enables(0); -- t valid es output.

--switch_m_tready_adaptation_1bit <= switch_m_axis_tready(0); -- t ready es input
    
    sw_m_tready <=  switch_m_tready_adaptation_1bit; --FINAL FIFO CONTROLA T READY DEL SWITCH.
   

-- Glue FSM Module
 
Glue_gen: FOR i IN 0 TO N-1 GENERATE
    
        glue_FSM: entity work.Glue_FSM_ShiftReg_To_FIFO_AXI_Stream
                 PORT MAP(
                          clk => clk,
                          rst => rst,
                          data_ready => data_ready_shift(i),
                          data_out => data_out_prev((i+1)*DW-1 DOWNTO i*DW),
                          m_axis_tvalid => m_tvalid(i),
                          m_axis_tready => m_tready(i),
                          m_axis_tdata => m_tdata((i+1)*DW -1 DOWNTO i*DW)  
                            );
END GENERATE;                           
        
SPI: FOR i IN 0 TO N-1 GENERATE

SPI_XX: ENTITY work.SPI_FSM
        
            PORT MAP(
              CLK => CLK,
              RST => RST, -- rst general
              DATA_READY=>DATA_READY_shift(i), -- input
              CONN => SYNC(i), -- to the world
              EN =>enables_spi(i), -- output, to sck, y shift.
              CNV => CNV(i), -- to the world and step_fsm
              LOCAL_RST =>LOCAL_RST(i), --output
              SETTLE => SETTLE(i) --to the wordl
               );
END GENERATE;

SHIFT: FOR i IN 0 TO N-1 GENERATE

SHIT_REG: ENTITY work.Shift_Register
PORT MAP(
                CLK => CLK,
                EN => enables_spi(i),
                SCK => SCK(i),
                RST => LOCAL_RST(i),
                SDO => SDO(i),
                DATA_READY => DATA_READY_shift(i),
                DATA_OUT => data_out_prev((i+1)*DW-1 DOWNTO i*DW)
        
        );
END GENERATE;

SCK_GEN: FOR i in 0 TO N-1 GENERATE

SKC_GENER: ENTITY work.SCK_Generator
PORT MAP(
                CLK => CLK,
                EN => enables_spi(i), --INPUT FROM SPI_FSM
                RST => LOCAL_RST(i),
                SCK => SCK(i)  
                );
   END GENERATE;

STEPP: FOR i IN 0 TO N-1 GENERATE

Stepo: ENTITY work.Step_FSM


    PORT MAP(
                CLK => CLK,
                RST => LOCAL_RST(i),
                CNV => CNV(i),
                STEP => STEP(i)
                );
    END GENERATE;



    --Component tvalid, t ready counter
    
counter: FOR i IN 0 TO N-1 GENERATE

tv_tr_counter:ENTITY work.tvalid_tready_counter

         GENERIC MAP (count => 128) 
        
        PORT MAP ( 
                  clk => clk,
                  rst => rst,
                   tvalid => m_tvalid(i),
                   tready => m_tready(i),
                   full => full(i)
                   );
  
  END GENERATE;
  
  
  SYNCHRO: FOR i IN 0 TO N-1 GENERATE
  
  SINCRO: ENTITY work.Synchonizer
  PORT MAP
            (CLK=>CLK,
             RST => RST,
             ASYNC => CONN,
             SYNC=> SYNC(i)
             );
    END GENERATE;
  
 dummy: FOR i IN 0 TO N-1 GENERATE

Dummies:ENTITY work.Intan_ADC_FSM
        
       GENERIC MAP (DATA =>CONST(i)
                    )
       
        PORT MAP ( 
                  clk => clk,
                  clr => rst,
                   cnv => CNV(i),
                   sdo => sdo(i),
                   en => enables_spi(i),
                   sck =>sck(i)
                   );
  
  END GENERATE;       
             
--final_counter: ENTITY work.tvalid_tready_counter

--            GENERIC MAP (count => 512)
            
  --          PORT MAP (
    --                clk => clk,
      --              rst => rst,
        --            tvalid =>switch_m_tvalid_adaptation_1bit, --PROBLEMA POR SER VECTOR DE 0 A 0...
          --          tready => switch_m_tready_adaptation_1bit,
            --        full => last
              --      );
new_final_conter: ENTITY work.Counter_final
            PORT MAP(
                     clk => clk,
                     rst=> rst,
                     t_va => switch_m_tvalid_adaptation_1bit,
                     t_re => switch_m_tready_adaptation_1bit,
                     t_la => last
                    ) ;                

Mux_gen: FOR i IN 0 TO N-1 GENERATE

--MUX_not: ENTITY work.MUX_NOT

  --  PORT MAP ( 
    --          IT => f_tvalid(i), -- comes from tvalid of fifos
      --        OT => switch_s_axis_tvalid(i), -- va al t valid del SWITCH
        --      sel => enables(i) -- comes from valve FSM.
       -- );
               
END GENERATE;

        producto_logico <= f_tvalid AND enables;

--



    --FIFO  DECLARATION
    aresetn <= not rst;
 
gen_fifo: FOR i IN 0 TO N -1 GENERATE 
    
axis_data_fifo_0_inst : axis_data_fifo_0
    PORT MAP (
      s_axis_aclk    => clk,
      s_axis_aresetn => aresetn,

      -- entrada (S_AXIS) desde  master
      s_axis_tvalid  => m_tvalid(i),
      s_axis_tready  => m_tready(i),       -- ESTA línea "genera" el ready del UUT
      s_axis_tdata   => m_tdata((i+1)*DW-1 DOWNTO i*DW),

      -- salida (M_AXIS) hacia el consumidor del TB
      m_axis_tvalid  => f_tvalid(i),
      m_axis_tready  => f_tready(i),
      m_axis_tdata   => f_tdata((i+1)*DW -1 DOWNTO i*DW),
      
      axis_wr_data_count => f_tcount_data((i+1)*32 -1 DOWNTO i*32)
    );

END GENERATE;

 valve: ENTITY work.valve_FSM
    
    
    GENERIC MAP(
          ports => 4
          )
    
  PORT MAP(
            clk=> clk,
            rst =>rst,
            pulses => full,
            last => last,
            enables=>enables
            
   );
   
   
   
   SWITCH: axis_switch_0
  PORT MAP (
    aclk => clk,
    aresetn => aresetn,
    s_axis_tvalid => producto_logico,
    s_axis_tready => f_tready,
    s_axis_tdata => f_tdata,
    m_axis_tvalid => switch_m_axis_tvalid,
    m_axis_tready => switch_m_axis_tready,
    m_axis_tdata => switch_m_axis_tdata,
    s_req_suppress => s_req_suppress,
    s_decode_err => s_decode_err
  );

final_FIFO : axis_data_fifo_FINAL
  PORT MAP (
    s_axis_aresetn => aresetn,
    s_axis_aclk => clk,
    s_axis_tvalid => switch_m_tvalid_adaptation_1bit,
    s_axis_tready => switch_m_tready_adaptation_1bit,
    s_axis_tdata => switch_m_axis_tdata,
    m_axis_tvalid => final_m_tvalid,
    m_axis_tready => final_m_tready,
    m_axis_tdata => final_m_tdata
  );



    clk_generation: PROCESS
                    BEGIN
                    WHILE now < 3 ms LOOP
                    
                        clk <= '0';
                        WAIT FOR clk_period/2;
                        clk <= '1';
                        WAIT FOR clk_period/2;
                    END LOOP;
                    WAIT;
                    END PROCESS clk_generation;
                  
                        
        stimulus: PROCESS
                   BEGIN
                   rst <= '1';
                   wait for 500 ns;
                   rst <= '0';
                   wait for 3 us;
                   CONN <= '1';
                   wait for 2 us;
                   wait for 5000 ns;
                   wait;
                   end process;
               
               
  

END BEHAVIOR;
