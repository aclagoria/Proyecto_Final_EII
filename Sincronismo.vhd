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

    constant c_0    :std_logic_vector(9 downto 0):="0000000000";--0
    constant c_639  :std_logic_vector(9 downto 0):="1001111111";
    constant c_640  :std_logic_vector(9 downto 0):="1010000000";
    constant c_655  :std_logic_vector(9 downto 0):="1010001111";--655
    constant c_656  :std_logic_vector(9 downto 0):="1010010000";--656
    constant c_751  :std_logic_vector(9 downto 0):="1011101111";
    constant c_752  :std_logic_vector(9 downto 0):="1011110000";
    constant c_799  :std_logic_vector(9 downto 0):="1100011111";--799

    constant l_0    :std_logic_vector(9 downto 0):="0000000000";--0
    constant l_479  :std_logic_vector(9 downto 0):="0111011111";
    constant l_480  :std_logic_vector(9 downto 0):="0111100000";
    constant l_489  :std_logic_vector(9 downto 0):="0111101001";--489
    constant l_490  :std_logic_vector(9 downto 0):="0111101010";--490
    constant l_491  :std_logic_vector(9 downto 0):="0111101011";--491
    constant l_492  :std_logic_vector(9 downto 0):="0111101100";--492
    constant l_524  :std_logic_vector(9 downto 0):="1000001100";--524

    signal new_pxl      : std_logic_vector(0 downto 0);
    signal vis_h        : std_logic;
        
    signal new_linea      : std_logic_vector(0 downto 0);
    signal vis_v          : std_logic;


    signal cont_clk     : std_logic_vector(1 downto 0);
    signal cont_clk_act : std_logic_vector(1 downto 0) ;
     
    signal E_h     : std_logic_vector(1 downto 0);
    signal E_h_act : std_logic_vector(1 downto 0);

    signal E_v     : std_logic_vector(1 downto 0);
    signal E_v_act : std_logic_vector(1 downto 0);

    signal cont_pxl     : std_logic_vector(9 downto 0);
    signal cont_pxl_act : std_logic_vector(9 downto 0);

    signal cont_linea     : std_logic_vector(9 downto 0);
    signal cont_linea_act : std_logic_vector(9 downto 0);
    

begin
    --me
memo_cont_clk: ffd generic map(N=>2) port map (rst=>rst,D=>cont_clk,clk=>clk,Q=>cont_clk_act);
memo_cont_pxl: ffd generic map(N=>10) port map (rst=>rst,D=>cont_pxl,clk=>clk,Q=>cont_pxl_act);
memo_cont_linea: ffd generic map(N=>10) port map (rst=>rst,D=>cont_linea,clk=>clk,Q=>cont_linea_act);
memo_E_lin: ffd generic map(N=>2) port map (rst=>rst,D=>E_v,clk=>clk,Q=>E_v_act);
memo_E_col: ffd generic map(N=>2) port map (rst=>rst,D=>E_h,clk=>clk,Q=>E_h_act);

    --les
    Contador_de_reloj: process(cont_clk_act,rst)
    begin
        if(rst='1')then
            cont_clk<="00";
        elsif(cont_clk_act="11")then
            cont_clk<="00";
            new_pxl(0)<='1';
        else
            cont_clk<=std_logic_vector(unsigned(cont_clk_act)+1);
            new_pxl(0)<='0';
        end if;
    end process;

    contador_pxl: process(cont_pxl_act,new_pxl)
    begin
        cont_pxl<=cont_pxl_act;
        new_linea(0)<='0';
        if (new_pxl(0)='1') then 
            if (cont_pxl_act=c_799) then
               cont_pxl<=(others=>'0');
               new_linea(0)<='1';
            else
               cont_pxl<=std_logic_vector(unsigned(cont_pxl_act)+1);
            end if;           
        end if ;
    end process;

    Horizontal:process(cont_pxl_act,cont_pxl)
    begin
        E_h<=E_h_act;
        if (cont_pxl_act=c_799 and cont_pxl=c_0) then
            E_h<=col_visible;

        elsif (cont_pxl_act=c_639 and cont_pxl=c_640) then
            E_h<=front_porch_h;

        elsif (cont_pxl_act=c_655 and cont_pxl=c_656) then               
           E_h<=sincro_horizontal;

        elsif (cont_pxl_act=c_751 and cont_pxl=c_752) then
            E_h<=back_porch_h;

        end if ;

    end process;

    contador_linea: process(cont_linea_act,new_linea)
    begin
        cont_linea<=cont_linea_act;
        if (new_linea(0)='1') then 
            if (cont_linea_act=l_524) then
               cont_linea<=(others=>'0');
            else
               cont_linea<=std_logic_vector(unsigned(cont_linea_act)+1);
            end if;           
        end if ;
    end process;

    Vertical:process(cont_linea,cont_linea_act)
    begin
        E_v<=E_v_act;
        if (cont_linea_act=l_524 and cont_linea=l_0) then
            E_v<=linea_visible;

        elsif (cont_linea_act=l_479 and cont_linea=l_480) then
            E_v<=front_porch_v;

        elsif (cont_linea_act=l_489 and cont_linea=l_490)then               
            E_v<=sincro_vertical;

        elsif (cont_linea_act=l_491 and cont_linea=l_492) then
            E_v<=back_porch_v;

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