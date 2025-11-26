
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stream_tlaster is
    port (
        clk           : in  std_logic;                                 -- AXI-Stream clock
        start         : in  std_logic;                                 -- Al activar, se empieza a enviar datos al master AXI-Stream
        count         : in  unsigned(24 downto 0);                     -- Número de registros de datos a enviar antes de asertar tlast

        -- Master AXI-Stream signals
        m_axis_tdata  : out std_logic_vector(15 downto 0);
        m_axis_tvalid : out std_logic;
        m_axis_tlast  : out std_logic;
        m_axis_tready : in  std_logic;

        -- Slave AXI-Stream signals
        s_axis_tdata  : in  std_logic_vector(15 downto 0);
        s_axis_tvalid : in  std_logic;
        s_axis_tready : out std_logic
    );
end entity stream_tlaster;

architecture rtl of stream_tlaster is

    -- Definición de estados
    type state_type is (IDLE, RUNNING, WAIT_FOR_TREADY);
    signal state : state_type := IDLE;

    -- Contador interno para los flancos de subida de s_axis_tvalid
    signal valid_count : unsigned(24 downto 0) := (others => '0');

    -- Señal interna para detectar el flanco de subida de s_axis_tvalid
    signal s_axis_tvalid_prev : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            case state is

                when IDLE =>
                    -- Reset de todas las señales
                    valid_count         <= (others => '0');
                    s_axis_tvalid_prev  <= '0';
                    m_axis_tlast        <= '0';
                    m_axis_tvalid       <= '0';
                    s_axis_tready       <= '1';  -- Se mantiene tready activo para que la fuente genere datos

                    -- Transición a RUNNING cuando se activa 'start'
                    if start = '1' then
                        state <= RUNNING;
                    end if;

                when RUNNING =>
                    -- Se transmiten los datos y señales de control
                    m_axis_tdata  <= s_axis_tdata;
                    m_axis_tvalid <= s_axis_tvalid;
                    s_axis_tready <= m_axis_tready;

                    -- Detección de flanco de subida en s_axis_tvalid
                    if (s_axis_tvalid_prev = '0' and s_axis_tvalid = '1') then
                        valid_count <= valid_count + 1;
                        -- Si se alcanza el número deseado de transferencias, se aserta tlast
                        if valid_count = count - 1 then
                            m_axis_tlast <= '1';
                            state       <= WAIT_FOR_TREADY;
                        else
                            m_axis_tlast <= '0';
                        end if;
                    else
                        m_axis_tlast <= '0';
                    end if;

                    -- Actualización del registro de s_axis_tvalid
                    s_axis_tvalid_prev <= s_axis_tvalid;

                when WAIT_FOR_TREADY =>
                    -- Para cumplir con la especificación AXI-Stream, se desactivan tvalid y tlast solo cuando m_axis_tready es '1'
                    if m_axis_tready = '1' then
                        m_axis_tlast  <= '0';
                        m_axis_tvalid <= '0';
                        state         <= IDLE;
                    end if;

            end case;
        end if;
    end process;

end architecture rtl;
