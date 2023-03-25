library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.numeric_std_unsigned.all;

entity Imp_pantalla is
    
    port(
        dato            : in std_logic_vector (63 downto 0);
        fila_celda      : in std_logic_vector(2 downto 0);
        columna_celda   : in std_logic_vector(2 downto 0);
        en_caracter     : in std_logic;                   

        pixel           : out std_logic

        );
end Imp_pantalla;

architecture solucion of Imp_pantalla is
    signal pos_en_dato: integer;
begin

 pos_en_dato <= to_integer(unsigned(fila_celda)&unsigned(columna_celda));

 pixel  <= dato(pos_en_dato) when en_caracter='1' else '0';
    
end solucion;