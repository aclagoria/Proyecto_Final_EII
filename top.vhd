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
--inicio de agregado
    component grilla is
        port(

            visible   : in std_logic; 
            fila      : in std_logic_vector(9 downto 0);
            columna   : in std_logic_vector(9 downto 0);

            celda           : out std_logic_vector(2 downto 0);
            fila_celda      : out std_logic_vector(2 downto 0);
            columna_celda   : out std_logic_vector(2 downto 0);
            en_caracter     : out std_logic                   
            );
    end component;

    component Texto_fijo is
        port(
        celda           : in std_logic_vector  (2 downto 0);
        dir             : out std_logic_vector (7 downto 0)
        );
    end component;
    
    component tabla_caracteres is 
        port(
        dir  : in std_logic_vector (7 downto 0);
        dato : out std_logic_vector (63 downto 0)
        );
    end component;
    
    component Imp_pantalla is
            port(
            dato            : in std_logic_vector (63 downto 0);
            fila_celda      : in std_logic_vector(2 downto 0);
            columna_celda   : in std_logic_vector(2 downto 0);
            en_caracter     : in std_logic;                   
    
            pixel           : out std_logic
            );
    end component;

--fin de agregado
    signal div1, div1_sig : std_logic_vector (24 downto 0);
    signal p_clk : std_logic; -- reloj de pixel desde pll (25.175 MHz)
--agregado 1
    signal visible        : std_logic; 
    signal fila           : std_logic_vector(9 downto 0);    
    signal columna        : std_logic_vector(9 downto 0);
    signal celda          : std_logic_vector(2 downto 0);
    signal fila_celda     : std_logic_vector(2 downto 0);
    signal columna_celda  : std_logic_vector(2 downto 0);
    signal en_caracter    : std_logic;
    signal dir            : std_logic_vector (7 downto 0);
    signal dato           : std_logic_vector (63 downto 0);
    
--fin agregado 1

begin
    U1 : sincronismo port map(
        rst       =>  '0' ,
        clk       => p_clk,

        sinc_h    =>sinc_h ,
        sinc_v    =>sinc_v ,
        visible   =>visible
        );
    U2 : pixel_pll port map (
        REFERENCECLK => clk,
        PLLOUTGLOBAL => p_clk,
        RESET        => '1'
        );
-- inicio agregado 2
    U3: grilla port map(
        visible         =>visible ,
        fila            =>fila    ,
        columna         =>columna ,
        celda           =>celda         ,
        fila_celda      =>fila_celda    ,
        columna_celda   =>columna_celda ,
        en_caracter     =>en_caracter   
        );   

    U4:Texto_fijo port map(
        celda           =>celda ,
        dir             =>dir
        );
       
    U5: tabla_caracteres port map(
        dir     =>dir,
        dato    =>dato
        );
        

    U6: Imp_pantalla port map(
        dato            =>dato,
        fila_celda      =>fila_celda    ,
        columna_celda   =>columna_celda ,
        en_caracter     =>en_caracter   ,
        pixel           =>blanco
        );

-- fin agregado 2

    FF_DIV : ffd generic map (N=>25) port map (rst=>'0',d=>div1_sig,q=>div1,clk=>p_clk);
    div1_sig <= (others=>'0') when unsigned(div1) >= 25129999 else
                std_logic_vector(unsigned(div1) + 1);
    led_1 <= '1' when unsigned(div1) < 25130000/2 else '0';
end architecture;