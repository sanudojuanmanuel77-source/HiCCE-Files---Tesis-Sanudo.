
LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY tb_FIFO_Switch IS
--  Port ( );
END tb_FIFO_Switch;

ARCHITECTURE BEHAVIOR OF tb_FIFO_Switch IS

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
                          data_ready => data_ready(i),
                          data_out => data_out((i+1)*DW-1 DOWNTO i*DW),
                          m_axis_tvalid => m_tvalid(i),
                          m_axis_tready => m_tready(i),
                          m_axis_tdata => m_tdata((i+1)*DW -1 DOWNTO i*DW)  
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

MUX_not: ENTITY work.MUX_NOT

    PORT MAP ( 
              IT => f_tvalid(i), -- comes from tvalid of fifos
              OT => switch_s_axis_tvalid(i), -- va al t valid del SWITCH
              sel => enables(i) -- comes from valve FSM.
        );
               
END GENERATE;


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
    s_axis_tvalid => switch_s_axis_tvalid,
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
                  
                        

 --   Stimulus_RST:PROCESS
   --                 BEGIN
               
     --               rst <= '1';
       --             WAIT FOR 100 ns;
         --           rst <= '0';
           --         WAIT;
             --  END PROCESS;
     
     Stimulus_GLUE1: PROCESS
                     BEGIN
                     rst <= '1';
                     wait for 100 ns;
                     rst <= '0';
                 
                     WAIT FOR 500 ns;
                     
                     FOR i IN 1 TO 128 LOOP
                     
                     data_out(15 DOWNTO 0) <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,DW));
                     data_ready(0) <= '1';
                     WAIT UNTIL (rising_edge(clk));
                     data_ready(0) <= '0';
                     
                     WAIT FOR 2083 ns; -- 480 KSPS... t adq + t conv + t read
                     
                     END LOOP;
                     
                     WAIT;
                     END PROCESS;
          
          Stimulus_GLUE2: PROCESS
                     BEGIN
                     
                     WAIT FOR 500 ns;
                     
                     FOR i IN 129 TO 256 LOOP
                     
                     data_out(31 DOWNTO 16) <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,DW));
                     data_ready(1) <= '1';
                     WAIT UNTIL (rising_edge(clk));
                     data_ready(1) <= '0';
                     
                     WAIT FOR 2083 ns; -- 480 KSPS... t adq + t conv + t read
                     
                     END LOOP;
                     WAIT;
                     END PROCESS;
          
          Stimulus_GLUE3: PROCESS
                     BEGIN
                     
                     WAIT FOR 500 ns;
                     
                     FOR i IN 257 TO 384 LOOP
                     
                     data_out(47 DOWNTO 32) <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,DW));
                     data_ready(2) <= '1';
                     WAIT UNTIL (rising_edge(clk));
                     data_ready(2) <= '0';
                     
                     WAIT FOR 2083 ns; -- 480 KSPS... t adq + t conv + t read
                     
                     END LOOP;
                     WAIT;
                     END PROCESS;
              
              
              Stimulus_GLUE4: PROCESS
                     BEGIN
                     
                     WAIT FOR 500 ns;
                     
                     FOR i IN 385 TO 512 LOOP
                     
                     data_out(63 DOWNTO 48) <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,DW));
                     data_ready(3) <= '1';
                     WAIT UNTIL (rising_edge(clk));
                     data_ready(3) <= '0';
                     
                     WAIT FOR 2083 ns; -- 480 KSPS... t adq + t conv + t read
                     
                     END LOOP;
                     WAIT;
                     END PROCESS;
               
               
    --           Monitor_OUT: process
--begin
 -- wait until rising_edge(clk);
 -- if final_m_tvalid = '1' and final_m_tready = '1' then
  --  report "FINAL OUT = " & integer'image(to_integer(unsigned(final_m_tdata)));
 -- end if;
--end process;

END BEHAVIOR;
