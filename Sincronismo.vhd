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

    constant porch_delantero    : E_Horizontal  := "00";
    constant col_visible        : E_Horizontal  := "01";
    constant porch_trasero      : E_Horizontal  := "10"; 
    constant sincro_horizontal  : E_Horizontal  := "11";

    constant porch_superior      : E_Vertical  := "00";
    constant linea_visible       : E_Vertical  := "01";
    constant porch_inferior      : E_Vertical  := "10";
    constant sincro_vertical     : E_Vertical  := "11";

    constant c_799  :std_logic_vector(9 downto 0):="1100011111";--799
    constant c_0    :std_logic_vector(9 downto 0):="0000000000";--0
    constant c_15   :std_logic_vector(9 downto 0):="0000001111";--15
    constant c_16   :std_logic_vector(9 downto 0):="0000010000";--16
    constant c_655  :std_logic_vector(9 downto 0):="1010001111";--655
    constant c_656  :std_logic_vector(9 downto 0):="1010010000";--656
    constant c_703  :std_logic_vector(9 downto 0):="1010111111";--703
    constant c_704  :std_logic_vector(9 downto 0):="1011000000";--704

    constant l_524  :std_logic_vector(9 downto 0):="1000001100";--524
    constant l_0    :std_logic_vector(9 downto 0):="0000000000";--0
    constant l_9    :std_logic_vector(9 downto 0):="0000001001";--9
    constant l_10   :std_logic_vector(9 downto 0):="0000001010";--10
    constant l_489  :std_logic_vector(9 downto 0):="0111101001";--489
    constant l_490  :std_logic_vector(9 downto 0):="0111101010";--490
    constant l_491  :std_logic_vector(9 downto 0):="0111101011";--491
    constant l_492  :std_logic_vector(9 downto 0):="0111101100";--492

    signal new_pxl      : std_logic;
    signal new_pxl_act  : std_logic;
    signal vis_h        : std_logic;
        
    signal new_linea      : std_logic;
    signal new_linea_act  : std_logic;
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
    memo_cont_clk: process(clk,rst)
    begin
        if(rst='1') then
            cont_clk_act<="00";
        elsif(clk'event and clk='1') then
            cont_clk_act<=cont_clk;
        end if;
    end process;

    memo_cont_pxl: process(clk,rst)
    begin
        if(rst='1') then
            cont_pxl_act<=(others=>'0');
        elsif(clk'event and clk='1') then
            cont_pxl_act<=cont_pxl;
        end if;

    end process;

    memo_new_pxl: process(clk,rst)
    begin
        if(rst='1') then
            new_pxl_act<='0';
        elsif(clk'event and clk='1') then
            new_pxl_act<=new_pxl;
        end if;
    end process;

    memo_cont_linea: process(clk,rst)
    begin
        if(rst='1') then
            cont_linea_act<=(others=>'0');
        elsif(clk'event and clk='1') then
            cont_linea_act<=cont_linea;
        end if;
    end process;

    memo_new_linea: process(clk,rst)
    begin
        if(rst='1') then
            new_linea_act<='0';
        elsif(clk'event and clk='1') then
            new_linea_act<=new_linea;
        end if;
    end process;

    memo_E_col: process(clk,rst)
    begin
        if(rst='1') then
            E_h_act<=porch_delantero;
        elsif(clk'event and clk='1') then
            E_h_act<=E_h;
        end if;
    end process;

    memo_E_linea: process(clk,rst)
    begin
    if(rst='1') then
        E_v_act<=porch_superior;
    elsif(clk'event and clk='1') then
        E_v_act<=E_v;
    end if;
    end process;



    --les
    Contador_de_reloj: process(cont_clk_act)
    begin
        if(cont_clk_act="11")then
            cont_clk<="00";
            new_pxl<='1';
        else
            cont_clk<=std_logic_vector(unsigned(cont_clk_act)+1);
            new_pxl<='0';
        end if;
    end process;

    contador_pxl: process(cont_pxl_act,new_pxl)
    begin
        cont_pxl<=cont_pxl_act;
        new_linea<='0';
        if (new_pxl='1' and new_pxl_act='0') then
            if (cont_pxl_act=c_799) then
               cont_pxl<=(others=>'0');
               new_linea<='1';
            else
               cont_pxl<=std_logic_vector(unsigned(cont_pxl_act)+1);
            end if;           
        end if ;
    end process;

    Horizontal:process(cont_pxl_act,cont_pxl)
    begin
        E_h<=E_h_act;
        if (cont_pxl_act=c_799 and cont_pxl=c_0) then
            E_h<=porch_delantero;

        elsif (cont_pxl_act=c_15 and cont_pxl=c_16) then
            E_h<=col_visible;

        elsif (cont_pxl_act=c_655 and cont_pxl=c_656) then               
            E_h<=porch_trasero;

        elsif (cont_pxl_act=c_703 and cont_pxl=c_704) then
            E_h<=sincro_horizontal;
        end if ;

    end process;

    contador_linea: process(cont_linea_act,new_linea)
    begin
        cont_linea<=cont_linea_act;
        if (new_linea='1' and new_linea_act='0') then
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
            E_v<=porch_superior;
        elsif (cont_linea_act=l_9 and cont_linea=l_10) then
            E_v<=linea_visible;
        elsif (cont_linea_act=l_489 and cont_linea=l_490)then               
            E_v<=porch_inferior;
        elsif (cont_linea_act=l_491 and cont_linea=l_492) then
            E_v<=sincro_vertical;
        end if ;
    end process;

    --ls
    columna<=cont_pxl_act;
    fila<=cont_linea_act;
    sinc_h <='0' when (E_h_act=sincro_horizontal) else '1';
    sinc_v <='0' when (E_v_act=sincro_vertical) else '1';
    vis_h  <='1' when (E_h_act=col_visible) else '0';
    vis_v  <='1' when (E_v_act=linea_visible) else '0';
    visible<='1' when (vis_v='1' and vis_h='1')else '0';
        

end solucion;