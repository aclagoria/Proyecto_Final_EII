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
    subtype E_Horizontal is std_logic_vector(1 downto 0);
    subtype E_Vertical   is std_logic_vector(1 downto 0);

    constant col_visible        : E_Horizontal  := "00";
    constant front_porch_h      : E_Horizontal  := "01"; 
    constant sincro_horizontal  : E_Horizontal  := "10";
    constant back_porch_h       : E_Horizontal  := "11"; 

    constant linea_visible       : E_Vertical  := "00";
    constant front_porch_v       : E_Vertical  := "01";
    constant sincro_vertical     : E_Vertical  := "10";
    constant back_porch_v        : E_Vertical  := "11";

    constant c_639  :std_logic_vector(9 downto 0):="1001111111";
    constant c_655  :std_logic_vector(9 downto 0):="1010001111";--655
    constant c_751  :std_logic_vector(9 downto 0):="1011101111";
    constant c_799  :std_logic_vector(9 downto 0):="1100011111";--799

    constant l_0    :std_logic_vector(9 downto 0):="0000000000";--0
    constant l_479  :std_logic_vector(9 downto 0):="0111011111";
    constant l_480  :std_logic_vector(9 downto 0):="0111100000";
    constant l_489  :std_logic_vector(9 downto 0):="0111101001";--489
    constant l_490  :std_logic_vector(9 downto 0):="0111101010";--490
    constant l_491  :std_logic_vector(9 downto 0):="0111101011";--491
    constant l_492  :std_logic_vector(9 downto 0):="0111101100";--492
    constant l_524  :std_logic_vector(9 downto 0):="1000001100";--524
        
    signal new_linea      : std_logic;
    signal vis_v          : std_logic;
    signal vis_h          : std_logic;
     
    signal E_h_sig        : std_logic_vector(1 downto 0);
    signal E_h_act        : std_logic_vector(1 downto 0);

    signal E_v_sig        : std_logic_vector(1 downto 0);
    signal E_v_act        : std_logic_vector(1 downto 0);

    signal cont_pxl_sig   : std_logic_vector(9 downto 0);
    signal cont_pxl_act   : std_logic_vector(9 downto 0);

    signal cont_linea_sig : std_logic_vector(9 downto 0);
    signal cont_linea_act : std_logic_vector(9 downto 0);
    

begin
    --me
memo_cont_pxl   : ffd generic map(N=>10) port map (rst=>rst, D=>cont_pxl_sig     ,clk =>clk ,Q=>cont_pxl_act);

memo_cont_linea : ffd generic map(N=>10) port map (rst=>rst, D=>cont_linea_sig   ,clk=>clk  ,Q=>cont_linea_act);

memo_E_lin      : ffd generic map(N=>2)  port map (rst=>rst, D=>E_v_sig          ,clk=>clk  ,Q=>E_v_act);

memo_E_col      : ffd generic map(N=>2)  port map (rst=>rst, D=>E_h_sig          ,clk=>clk  ,Q=>E_h_act);


    contador_pxl: process(cont_pxl_act)
    begin
        cont_pxl_sig<=cont_pxl_act;
        if (cont_pxl_act=c_799) then
           cont_pxl_sig<=(others=>'0');
           new_linea<='1';
        else
           cont_pxl_sig<=std_logic_vector(unsigned(cont_pxl_act)+1);
           new_linea<='0';
        end if;           
    end process;

    Horizontal:process(cont_pxl_act)
    begin
        E_h_sig<=E_h_act;
        if (cont_pxl_act=c_799 )     then 
            E_h_sig<=col_visible;

        elsif (cont_pxl_act=c_639)   then 
            E_h_sig<=front_porch_h;

        elsif (cont_pxl_act=c_655)   then               
           E_h_sig<=sincro_horizontal;

        elsif (cont_pxl_act=c_751)   then
            E_h_sig<=back_porch_h;

        end if ;

    end process;

    contador_linea: process(cont_linea_act,new_linea)
    begin
        cont_linea_sig<=cont_linea_act;
        if (new_linea='1') then 
            if (cont_linea_act=l_524) then
               cont_linea_sig<=(others=>'0');
            else
               cont_linea_sig<=std_logic_vector(unsigned(cont_linea_act)+1);
            end if;           
        end if ;
    end process;

    Vertical:process(cont_linea_act,cont_linea_sig)
    begin
        E_v_sig<=E_v_act;
        if  (cont_linea_act=l_524   and cont_linea_sig=l_0)   then 
            E_v_sig<=linea_visible;

        elsif (cont_linea_act>l_479 and cont_linea_sig=l_480) then 
            E_v_sig<=front_porch_v;

        elsif (cont_linea_act=l_489 and cont_linea_sig=l_490) then               
            E_v_sig<=sincro_vertical;

        elsif (cont_linea_act=l_491 and cont_linea_sig=l_492) then 
            E_v_sig<=back_porch_v;

        end if ;
    end process;

    --ls
    columna<=cont_pxl_act;
    fila<=cont_linea_act;
    sinc_h <='0' when (E_h_act=sincro_horizontal) else '1';
    sinc_v <='0' when (E_v_act=sincro_vertical)   else '1';
    vis_h  <='1' when (E_h_act=col_visible)       else '0';
    vis_v  <='1' when (E_v_act=linea_visible)     else '0';
    visible<='1' when (vis_v='1' and vis_h='1')   else '0';
        

end solucion;