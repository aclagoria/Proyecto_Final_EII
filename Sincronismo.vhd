library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ffd_pkg.all;

entity sincronismo is
    
    port(
        clk       : in std_logic;
        rst       : in std_logic;
        
                         
        sinc_h    : out std_logic;
        sinc_v    : out std_logic;
        visible   : out std_logic; 
        fila      : out std_logic_vector(9 downto 0);
        columna   : out std_logic_vector(9 downto 0));
end sincronismo;


architecture solucion of sincronismo is

    subtype estado_horizontal is std_logic_vector(1 downto 0);
    subtype estado_vertical   is std_logic_vector(1 downto 0);
    subtype estado_cont_horizontal is std_logic_vector(9 downto 0);    
    subtype estado_cont_vertical   is std_logic_vector(9 downto 0);

    constant porch_izquierdo  : estado_horizontal  := "00";
    constant visible_columna  : estado_horizontal  := "01";
    constant sincro_columna   : estado_horizontal  := "11";
    constant porch_derecho    : estado_horizontal  := "10";    
    
    constant porch_superior   : estado_vertical    := "00";
    constant visible_fila     : estado_vertical    := "01";
    constant sincro_fila      : estado_vertical    := "11";
    constant porch_inferior   : estado_vertical    := "10";

    signal   E_act_h,E_sig_h        : estado_horizontal ;
    signal   E_act_v,E_sig_v        : estado_vertical   ;
    signal   cont_act_h,cont_sig_h  : estado_cont_horizontal ;
    signal   cont_act_v,cont_sig_v  : estado_cont_vertical   ;

    constant c_max                  : estado_cont_horizontal :="1100100000" ; --800
    constant c_izq_max              : estado_cont_horizontal :="0000010000" ; --16
    constant c_visible_max          : estado_cont_horizontal :="1010010000" ; --656
    constant c_sinc_max             : estado_cont_horizontal :="1011000000" ; --704

    constant f_max                  : estado_cont_vertical := "1000001101" ; --525
    constant f_sup_max              : estado_cont_vertical := "0000001010" ; --10
    constant f_visible_max          : estado_cont_vertical := "0111101010" ; --490
    constant f_sinc_max             : estado_cont_vertical := "100001011" ; --523
    


begin
    --Memoria de estado
    
    ME_horizontal: ffd  
    generic map(N=>2)  
    port map ( 
        rst=>rst, 
        D=>E_sig_h, 
        clk=>clk, 
        Q=>E_act_h); 

    ME_vertical  : ffd  
    generic map(N=>2)  
    port map ( 
        rst=>rst, 
        D=>E_sig_v, 
        clk=>clk, 
        Q=>E_act_v); 

    ME_cont_horizontal: ffd 
    generic map(N=>10) 
    port map (
        rst=>rst,
        D=>cont_sig_h,
        clk=>clk,
        Q=>cont_act_h);

    ME_cont_vertical  : ffd 
    generic map(N=>10) 
    port map (
        rst=>rst,
        D=>cont_sig_v,
        clk=>clk,
        Q=>cont_act_v);


    --Logica del estado siguiente
    LES:process(clk,cont_act_h,cont_act_v,E_act_h,E_act_v)
    begin
        
        if(clk'event and clk='1')then
            if (cont_act_h=c_max) then
                E_sig_h <= porch_izquierdo;
                cont_sig_h <=(others=>'0');
                cont_sig_v <=std_logic_vector(unsigned(cont_act_v)+1);
            elsif (cont_act_h=c_izq_max) then
                E_sig_h <= visible_columna;
            elsif (cont_act_h=c_visible_max) then
                E_sig_h <= sincro_columna;
            elsif (cont_act_h=c_sinc_max) then
                E_sig_h <= porch_derecho;
            elsif (cont_act_v=f_max) then
                E_sig_v <= porch_superior;
                cont_sig_v<=(others=>'0');
            elsif (cont_act_v=f_sup_max) then
                E_sig_v <= visible_fila;
            elsif (cont_act_v=f_visible_max) then
                E_sig_v <= sincro_fila;
            elsif (cont_act_v=f_sinc_max) then
                E_sig_v <= porch_inferior;              
            else
                cont_sig_h <= std_logic_vector(unsigned(cont_act_h)+1);
                E_sig_h<=E_act_h;
                cont_sig_v <= cont_act_v;
                E_sig_v<=E_act_v;
            end if ;

        else 
            cont_sig_h <= cont_act_h;
            cont_sig_v <= cont_act_v;
            E_sig_h<=E_act_h;
            E_sig_v<=E_act_v;

        end if;

    end process;


--logica de salida

sinc_v   <= '0'  when (E_act_v=sincro_fila) else '1'   ;
sinc_h   <= '0'  when (E_act_h=sincro_columna) else '1';
visible  <= '1'  when (E_act_v=visible_fila and E_act_h=visible_columna) else '0';
fila     <= cont_act_v ;
columna  <= cont_act_h ; 
   
end solucion;