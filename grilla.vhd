library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.numeric_std_unsigned.all;

entity grilla is
    
    port(
                         
        visible         : in std_logic; 
        fila            : in std_logic_vector(9 downto 0);
        columna         : in std_logic_vector(9 downto 0);

        celda           : out std_logic_vector(2 downto 0);
        fila_celda      : out std_logic_vector(2 downto 0);
        columna_celda   : out std_logic_vector(2 downto 0);
        en_caracter     : out std_logic                   
        );
end grilla;

architecture solucion of grilla is
    signal f_celda : std_logic_vector(9 downto 0);
begin
    celda         <= columna(9 downto 7);
    columna_celda <= columna(6 downto 4);
    en_caracter   <= '1' when visible='1' and unsigned(fila) > 111 and unsigned(fila) < 368 else '0';
    f_celda       <= std_logic_vector(unsigned(fila)-112);
    fila_celda    <= f_celda (7 downto 5);
end solucion;