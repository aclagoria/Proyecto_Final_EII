library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ffd_pkg.all;


entity top is
    port(
        clk     : in  std_logic; -- pin #94  (12 MHz)
        blanco  : out std_logic; -- pin #7
        sinc_h  : out std_logic; -- pin #8
        sinc_v  : out std_logic; -- pin #9
        led_1   : out std_logic  -- pin #1
    );
end top;

architecture arch of top is
    component sincronismo is
    
        port(
            clk       : in std_logic;
            rst       : in std_logic;
            
                             
            sinc_h    : out std_logic;
            sinc_v    : out std_logic;
            visible   : out std_logic; 
            fila      : out std_logic_vector(9 downto 0);
            columna   : out std_logic_vector(9 downto 0)
        );
    end component;
    component pixel_pll is
        port (
            REFERENCECLK : in  std_logic; -- (12 MHz)
            PLLOUTCORE   : out std_logic; -- (25.13 MHz)
            PLLOUTGLOBAL : out std_logic; -- (25.13 MHz)
            RESET        : in  std_logic  -- Activo BAJO
        );
    end component;
    signal div1, div1_sig : std_logic_vector (24 downto 0);
    signal p_clk : std_logic; -- reloj de pixel desde pll (25.175 MHz)
begin
    U1 : sincronismo port map(
        rst       =>  '0' ,
        clk       => p_clk,

        sinc_h    =>sinc_h ,
        sinc_v    =>sinc_v ,
        visible   =>blanco
        );
    U2 : pixel_pll port map (
        REFERENCECLK => clk,
        PLLOUTGLOBAL => p_clk,
        RESET        => '1'
        );

    FF_DIV : ffd generic map (N=>25) port map (rst=>'0',d=>div1_sig,q=>div1,clk=>p_clk);
    div1_sig <= (others=>'0') when unsigned(div1) >= 25129999 else
                std_logic_vector(unsigned(div1) + 1);
    led_1 <= '1' when unsigned(div1) < 25130000/2 else '0';
end architecture;