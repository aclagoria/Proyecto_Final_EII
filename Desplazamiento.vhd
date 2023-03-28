library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ffd_pkg.all;

entity desplazamiento is
    
    port(
        clk: in std_logic;
        rst: in std_logic;
        sinc_v: in std_logic;
        celda_offset: out std_logic_vector(3 downto 0)
        );
end desplazamiento;

architecture solucion of desplazamiento is

    constant c_max:std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(29,6));

    signal sinc_v_sig, sinc_v_act: std_logic_vector(0 downto 0);
    signal cont60_sig, cont60_act: std_logic_vector(5 downto 0);
    signal c_off_sig, c_off_act:std_logic_vector(3 downto 0);

begin

    FFSV:ffd generic map(N=>sinc_v_sig'length) port map (rst=>rst, D=>sinc_v_sig  ,clk =>clk ,Q=>sinc_v_act);

    FFDCONT:ffd generic map(N=>cont60_sig'length) port map (rst=>rst,D=>cont60_sig,clk =>clk ,Q=>cont60_act);

    FCOFFSET:ffd generic map(N=>c_off_sig'length) port map (rst=>rst, D=>c_off_sig  ,clk =>clk ,Q=>c_off_act);

    sinc_v_sig <= (0=>sinc_v);

    CONTADOR:process(all)
    begin
        cont60_sig<=cont60_act;
        c_off_sig<=c_off_act;
        if (sinc_v_act ="1" and sinc_v_sig = "0") then
            if(cont60_act = c_max)then
                cont60_sig<=(others=>'0');
                c_off_sig<=std_logic_vector(unsigned(c_off_act)+1);
            else 
                cont60_sig<=std_logic_vector(unsigned(cont60_act)+1);
            end if;
        end if;
    end process;

celda_offset<=c_off_act;
end solucion;