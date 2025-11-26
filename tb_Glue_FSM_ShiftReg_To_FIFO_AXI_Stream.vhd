

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_Glue_FSM_ShiftReg_To_FIFO_AXI_Stream is
--  Port ( );
end tb_Glue_FSM_ShiftReg_To_FIFO_AXI_Stream;

architecture BEHAVIOR of tb_Glue_FSM_ShiftReg_To_FIFO_AXI_Stream is

CONSTANT clk_period: TIME := 10 ns;

SIGNAL clk,rst: STD_LOGIC:= '0';
signal aresetn  : std_logic := '0';

SIGNAL data_ready: STD_LOGIC := '0';
SIGNAL data_ouT: STD_LOGIC_VECTOR(15 DOWNTO 0):= (OTHERS => '0');
SIGNAL m_tready: STD_LOGIC := '0';

SIGNAL m_tvalid: STD_LOGIC;
SIGNAL m_tdata: STD_LOGIC_VECTOR(15 DOWNTO 0);



-- Interface de salida de la FIFO (lado M_AXIS)
  signal f_tvalid    : std_logic;
  signal f_tdata     : std_logic_vector(15 downto 0);
  signal f_tready    : std_logic := '0';  -- lo maneja el consumidor del TB
  SIGNAL f_tcount_data     : STD_LOGIC_VECTOR(31 DOWNTO 0);
begin

        
        UUT: entity work.Glue_FSM_ShiftReg_To_FIFO_AXI_Stream
                PORT MAP(
                          clk => clk,
                          rst => rst,
                          data_ready => data_ready,
                          data_out => data_out,
                          m_axis_tvalid => m_tvalid,
                          m_axis_tready => m_tready,
                          m_axis_tdata => m_tdata  
                            );
        --
        --FIFO DECLARATION                
          aresetn <= not rst;
          
          
    axis_data_fifo_0_inst : entity work.axis_data_fifo_0
    port map (
      s_axis_aclk    => clk,
      s_axis_aresetn => aresetn,

      -- entrada (S_AXIS) desde tu master
      s_axis_tvalid  => m_tvalid,
      s_axis_tready  => m_tready,       -- ESTA línea "genera" el ready del UUT
      s_axis_tdata   => m_tdata,

      -- salida (M_AXIS) hacia el consumidor del TB
      m_axis_tvalid  => f_tvalid,
      m_axis_tready  => f_tready,
      m_axis_tdata   => f_tdata,
      
      axis_wr_data_count => f_tcount_data
    );


     clk_gen:process
            begin
            while now < 30000 ns loop
             
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
            end loop;
            wait;
            end process;
            
            
            stimulus:process
                      begin
                      rst <= '1';
                      wait for clk_period * 3;
                      rst <= '0';
                      wait for 50 ns;
                      data_out <= "1111000011110000";
                      data_ready <= '1';
                      wait for clk_period;
                      data_ready <= '0';
                     -- wait for 50 ns;
                    --  m_axis_tready <= '1';
                    --  wait for clk_period;
                    --  m_axis_tready <= '0';
                      
                      wait for 500 ns;
                      data_out <= "1111111111111111";
                       data_ready <= '1';
                      wait for clk_period;
                      data_ready <= '0';
                      wait for 10 ns;
                   --   m_axis_tready <= '1';
                    --  wait for clk_period;
                     -- m_axis_tready <= '0';
                      
                       wait for 500 ns;
                       data_out <= "0000000000000001";
                       data_ready <= '1';
                     --  m_axis_tready <= '1';
                       wait for clk_period;
                       data_ready <= '0';
                     --  m_axis_tready <= '0';
                       wait for clk_period;
                       
                       
                      wait;
                      end process;
           
           
           
           sink : process
  begin
    -- espera un rato antes de empezar a leer
    wait for 6000 ns;

    -- lee tres palabras, una por vez con pausas
    for i in 0 to 2 loop
      -- espera a que la FIFO tenga dato válido
      wait until rising_edge(clk) and (f_tvalid = '1');
      -- acepta el dato este ciclo
      f_tready <= '1';
      wait until rising_edge(clk);
      f_tready <= '0';

      -- pausa entre lecturas (simula backpressure)
      wait for 300 ns;
    end loop;

    wait;
  end process;


end BEHAVIOR;
