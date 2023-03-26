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

            visible             : in std_logic; 
            fila                : in std_logic_vector(9 downto 0);
            columna             : in std_logic_vector(9 downto 0);
            
            celda               : out std_logic_vector(2 downto 0);
            fila_celda          : out std_logic_vector(2 downto 0);
            columna_celda       : out std_logic_vector(2 downto 0);
            en_caracter         : out std_logic                   ;
            
            celda_marco_sup     : out std_logic_vector(4 downto 0);
            fila_marco_sup      : out std_logic_vector(2 downto 0);  
            columna_marco_sup   : out std_logic_vector(2 downto 0);
            en_marco_sup        : out std_logic                   ;
            
            celda_marco_inf     : out std_logic_vector(4 downto 0);
            fila_marco_inf      : out std_logic_vector(2 downto 0);
            columna_marco_inf   : out std_logic_vector(2 downto 0);
            en_marco_inf        : out std_logic                   
            );
    end component;

    component Texto_fijo is
        port(
        celda           : in std_logic_vector  (2 downto 0);
        celda_marco_sup : in std_logic_vector(4 downto 0);
        celda_marco_inf : in std_logic_vector(4 downto 0);

        dir             : out std_logic_vector (7 downto 0);
        dir_ms          : out std_logic_vector (7 downto 0);
        dir_mi          : out std_logic_vector (7 downto 0)
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
                dato              : in std_logic_vector (63 downto 0);
                fila_celda        : in std_logic_vector(2 downto 0);
                columna_celda     : in std_logic_vector(2 downto 0);
                en_caracter       : in std_logic;                   

                dato_ms           : in std_logic_vector (63 downto 0);
                fila_marco_sup    :in std_logic_vector(2 downto 0);
                columna_marco_sup :in std_logic_vector(2 downto 0); 
                en_marco_sup      : in std_logic;                   

                dato_mi           : in std_logic_vector (63 downto 0);
                fila_marco_inf    :in std_logic_vector(2 downto 0);                      
                columna_marco_inf : in std_logic_vector(2 downto 0);
                en_marco_inf      : in std_logic;                   
                
                pixel             : out std_logic
            );
    end component;

--fin de agregado
    signal div1, div1_sig : std_logic_vector (24 downto 0);
    signal p_clk : std_logic; -- reloj de pixel desde pll (25.175 MHz)
--agregado 1
    signal visible             : std_logic; 
    signal fila                : std_logic_vector(9 downto 0);    
    signal columna             : std_logic_vector(9 downto 0);
    signal celda               : std_logic_vector(2 downto 0);
    signal fila_celda          : std_logic_vector(2 downto 0);
    signal columna_celda       : std_logic_vector(2 downto 0);
    signal en_caracter         : std_logic;
    signal dir                 : std_logic_vector (7 downto 0);
    signal dato                : std_logic_vector (63 downto 0);

    signal celda_marco_sup     : std_logic_vector(4 downto 0);
    signal fila_marco_sup      : std_logic_vector(2 downto 0);
    signal columna_marco_sup   : std_logic_vector(2 downto 0);
    signal en_marco_sup        : std_logic;
    signal dir_ms              : std_logic_vector (7 downto 0);
    signal dato_ms             : std_logic_vector (63 downto 0);

    signal celda_marco_inf     : std_logic_vector(4 downto 0);
    signal fila_marco_inf      : std_logic_vector(2 downto 0);
    signal columna_marco_inf   : std_logic_vector(2 downto 0);
    signal en_marco_inf        : std_logic;
    signal dir_mi              : std_logic_vector (7 downto 0);
    signal dato_mi             : std_logic_vector (63 downto 0);
    

--fin agregado 1

begin
    Sinc: sincronismo port map(
        rst       =>  '0' ,
        clk       => p_clk,

        sinc_h    =>sinc_h ,
        sinc_v    =>sinc_v ,
                
        visible   =>visible,
        fila      =>fila,
        columna   =>columna
        );
        
    Reloj: pixel_pll port map (
        REFERENCECLK => clk,
        PLLOUTGLOBAL => p_clk,
        RESET        => '1'
        );
-- inicio agregado 2
    Zonas: grilla port map(
        visible           => visible ,
        fila              => fila    ,
        columna           => columna , 

        celda             => celda         ,
        fila_celda        => fila_celda    ,
        columna_celda     => columna_celda ,
        en_caracter       => en_caracter   ,

        celda_marco_sup   => celda_marco_sup  ,
        fila_marco_sup    => fila_marco_sup   ,
        columna_marco_sup => columna_marco_sup,
        en_marco_sup      => en_marco_sup     , 

        celda_marco_inf   => celda_marco_inf   ,
        fila_marco_inf    => fila_marco_inf    ,
        columna_marco_inf => columna_marco_inf , 
        en_marco_inf      => en_marco_inf   
        );   

    Programacion: Texto_fijo port map(
       celda           => celda ,
       celda_marco_sup => celda_marco_sup,  
       celda_marco_inf => celda_marco_inf,  

       dir             => dir,
       dir_mi          => dir_mi,
       dir_ms          => dir_ms
       );

    Txt_Centro: tabla_caracteres port map(
        dir     =>dir,

        dato    =>dato
        );
        

    Impresion: Imp_pantalla port map(
        dato              =>dato,
        fila_celda        =>fila_celda    ,
        columna_celda     =>columna_celda ,
        en_caracter       =>en_caracter   ,

        dato_ms           =>dato_ms,
        fila_marco_sup    =>fila_marco_sup   , 
        columna_marco_sup =>columna_marco_sup,  
        en_marco_sup      =>en_marco_sup  ,

        dato_mi           =>dato_mi,
        fila_marco_inf    =>fila_marco_inf   ,
        columna_marco_inf =>columna_marco_inf,
        en_marco_inf      =>en_marco_inf  ,

        pixel             =>blanco
        );

    Txt_Sup: tabla_caracteres port map(
        dir    =>dir_ms,

        dato   =>dato_ms
        );
    Txt_Inf: tabla_caracteres port map(
        dir    =>dir_mi,

        dato   =>dato_mi
        );
-- fin gregado 2

    FF_DIV : ffd generic map (N=>25) port map (rst=>'0',d=>div1_sig,q=>div1,clk=>p_clk);
    div1_sig <= (others=>'0') when unsigned(div1) >= 25129999 else
                std_logic_vector(unsigned(div1) + 1);
    led_1 <= '1' when unsigned(div1) < 25130000/2 else '0';
end architecture;