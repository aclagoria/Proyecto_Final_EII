library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity grilla is
    
    port(
                         
        visible             : in std_logic; 
        fila                : in std_logic_vector(9 downto 0);
        columna             : in std_logic_vector(9 downto 0);
    
        celda               : out std_logic_vector(2 downto 0);
        fila_celda          : out std_logic_vector(2 downto 0);
        columna_celda       : out std_logic_vector(2 downto 0);
        en_caracter         : out std_logic  ;                 
       
        celda_marco_sup     : out std_logic_vector(4 downto 0);
        fila_marco_sup      : out std_logic_vector(2 downto 0);
        columna_marco_sup   : out std_logic_vector(2 downto 0);
        en_marco_sup        : out std_logic                   ;
       
        celda_marco_inf     : out std_logic_vector(4 downto 0);
        fila_marco_inf      : out std_logic_vector(2 downto 0);
        columna_marco_inf   : out std_logic_vector(2 downto 0);
        en_marco_inf        : out std_logic                   

        );
end grilla;

architecture solucion of grilla is
    signal f_celda, f_marco_sup, f_marco_inf : std_logic_vector(9 downto 0);
begin
    celda         <= columna(9 downto 7);
    columna_celda <= columna(6 downto 4);
    en_caracter   <= '1' when visible='1' and unsigned(fila) > 111 and unsigned(fila) < 368 else '0';
    f_celda       <= std_logic_vector(unsigned(fila)-112);
    fila_celda    <= f_celda (7 downto 5);
    
    celda_marco_sup   <= columna(9 downto 5);
    columna_marco_sup <= columna(4 downto 2);
    en_marco_sup      <= '1' when visible='1' and unsigned(fila) > 39 and unsigned(fila)  < 71   else '0';
    f_marco_sup       <= std_logic_vector(unsigned(fila)-40);
    fila_marco_sup    <= f_marco_sup (4 downto 2);
    
    celda_marco_inf   <= columna(9 downto 5);
    columna_marco_inf <= columna(4 downto 2);
    en_marco_inf      <= '1' when visible='1' and unsigned(fila) > 407 and unsigned(fila) < 440   else '0';
    f_marco_inf       <= std_logic_vector(unsigned(fila)-408);
    fila_marco_inf    <= f_marco_sup (4 downto 2);
    
end solucion;