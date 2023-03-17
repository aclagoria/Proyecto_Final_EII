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
            clk        : in std_logic; --frecuencia de trabajo 104 MHz-->T= 9.615384615// voy a probar con 100MHZ T=10 ns

            sinc_h    : out std_logic;
            sinc_v    : out std_logic;
            visible   : out std_logic; 
            fila      : out std_logic_vector(9 downto 0);    
            columna   : out std_logic_vector(9 downto 0));
    
    end component;
    -- Declaraciones
    -- Constantes
    constant T_L        : time  := 5 ns;
    
    --señales
   signal rst_in        : std_logic; 
   signal clk_in        : std_logic;
   
   signal sinc_h_out     : std_logic;
   signal sinc_v_out     : std_logic;
   signal visible_out    : std_logic; 
   signal fila_out       : std_logic_vector(9 downto 0);    
   signal columna_out    : std_logic_vector(9 downto 0);

   begin
    DUT:sincronismo port map(
        rst       =>rst_in     ,
        clk       =>clk_in     ,

        sinc_h    =>sinc_h_out  ,
        sinc_v    =>sinc_v_out  ,
        visible   =>visible_out ,
        fila      =>fila_out    ,  
        columna   =>columna_out );
    
    reloj:process
     begin
        clk_in <= '0';
        wait for T_L;
        clk_in <= '1';
        wait for T_L;
    end process;

    estimulo: process
    begin
        --reset
        rst_in <= '1';
        wait for 2*T_L ;
        rst_in <= '0';
        wait for  32 ms; 
        finish;
    end process;




end tb;