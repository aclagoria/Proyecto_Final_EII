library IEEE;
use IEEE.std_logic_1164.all;
use std.env.finish;

entity sincronismo_tb is
end sincronismo_tb;

architecture tb of sincronismo_tb is

    -- Declaracion de componente a probar
    component sincronismo is
        port(
            rst        : in std_logic; 
            clk        : in std_logic;

            sinc_h    : out std_logic;
            sinc_v    : out std_logic;
            visible   : out std_logic; 
            fila      : out std_logic_vector(9 downto 0);    
            columna   : out std_logic_vector(9 downto 0));
    
    end component;
    -- Declaraciones
    -- Constantes
    constant T        : time  := 10 ns;
    
    --señales
   signal rst_in        : std_logic; 
   signal clk_in        : std_logic;
   signal sinc_h_in     : std_logic;
   signal sinc_v_in     : std_logic;
   signal visible_in    : std_logic; 
   signal fila_in       : std_logic_vector(9 downto 0);    
   signal columna_in    : std_logic_vector(9 downto 0);

   begin
    DUT:sincronismo port map(
        rst       =>rst_in    ,
        clk       =>clk_in    ,
        sinc_h    =>sinc_h_in ,
        sinc_v    =>sinc_v_in ,
        visible   =>visible_in,
        fila      =>fila_in   ,  
        columna   =>columna_in);
    
    reloj:process
     begin
        clk_in <= '0';
        wait for T;
        clk_in <= '1';
        wait for T;
    end process;

    estimulo: process
    begin
        --reset
        rst_in <= '1';
        wait for T ;
        rst_in <= '0';
        wait for 2.5 ms ; 
        finish;
    end process;




end tb;