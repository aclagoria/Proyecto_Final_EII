library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ffd_pkg.all;

entity sinc is
    
    port(
        clk_25Mhz : in std_logic;
        rst       : in std_logic;
        hab       : in std_logic;
                         
        sinc_h    : out std_logic;
        sinc_v    : out std_logic;
        visible   : out std_logic; 
        fila      : out std_logic_vector(9 downto 0);
        columna   : out std_logic_vector(9 downto 0));
end sinc;


architecture solucion of sinc is

    subtype estado_horizontal is std_logic_vector(1 downto 0);
    subtype estado_vertical   is std_logic_vector(1 downto 0);

    constant parche_izquierdo : estado_horizontal  := "00";
    constant visible_columna  : estado_horizontal  := "01";
    constant sincro_columna   : estado_horizontal  := "10";
    constant parche_derecho   : estado_horizontal  := "11";    
    
    constant parche_superior  : estado_vertical    := "00";
    constant visible_fila     : estado_vertical    := "01";
    constant sincro_fila      : estado_vertical    := "10";
    constant parche_inferior  : estado_vertical    := "11";

    signal   E_act_h,E_sig_h  : estado_horizontal ;
    signal   E_act_v,E_sig_v  : estado_vertical   ;

begin
    --Memoria de estado
    Memoria_horizontal: ffd generic map(N=>2) port map (rst=>rst,hab=>hab,D=>E_sig_h,clk=>clk_25Mhz,Q=>E_act_h);
    Memoria_vertical  : ffd generic map(N=>2) port map (rst=>rst,hab=>hab,D=>E_sig_v,clk=>clk_25Mhz,Q=>E_act_v);

    --Logica del estado siguiente


--logica de salida
sinc_h   <=     ;
sinc_v   <=     ;
visible  <=     ;
fila     <=     ;
columna  <=   ; 
   
end solucion;