library IEEE;
use IEEE.std_logic_1164.all;
use std.env.finish;
use IEEE.numeric_std_unsigned.all;

entity sincronismo_tb is
end sincronismo_tb;

architecture tb of sincronismo_tb is

    -- Declaracion de componente a probar
    component sincronismo is
        port(
            rst        : in std_logic; 
            clk        : in std_logic; -- frecuencia= 25,175 MHz

            sinc_h    : out std_logic;
            sinc_v    : out std_logic;
            visible   : out std_logic; 
            fila      : out std_logic_vector(9 downto 0);    
            columna   : out std_logic_vector(9 downto 0)
           
            );
            
    
    end component;
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
    -- Declaraciones
    -- Constantes
    constant T_L        : time  := 20 ns;--19,8609 ns
    
    --señales
   signal rst_in        : std_logic; 
   signal clk_in        : std_logic;
   
   signal sinc_h_out     : std_logic;
   signal sinc_v_out     : std_logic;
   signal visible_out    : std_logic; 
   signal fila_out       : std_logic_vector(9 downto 0);    
   signal columna_out    : std_logic_vector(9 downto 0);
   
   signal celda_out          : std_logic_vector(2 downto 0);
   signal fila_celda_out     : std_logic_vector(2 downto 0);
   signal columna_celda_out  : std_logic_vector(2 downto 0);
   signal en_caracter_out    : std_logic;
   




   begin
    DUT:sincronismo port map(
        rst       =>rst_in     ,
        clk       =>clk_in     ,

        sinc_h    =>sinc_h_out  ,
        sinc_v    =>sinc_v_out  ,
        visible   =>visible_out ,
        fila      =>fila_out    ,  
        columna   =>columna_out );

    DUT2: grilla port map(
                         
    visible         =>visible_out ,
    fila            =>fila_out    ,
    columna         =>columna_out ,

    celda           =>celda_out         ,
    fila_celda      =>fila_celda_out    ,
    columna_celda   =>columna_celda_out ,
    en_caracter     =>en_caracter_out   
    );     
        
    
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
        wait for  17 ms; 
        finish;
    end process;




end tb;