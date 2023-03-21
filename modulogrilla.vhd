library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity grilla is
    
    port(
                         
        visible   : in std_logic; 
        fila      : in std_logic_vector(9 downto 0);
        columna   : in std_logic_vector(9 downto 0);

        grilla_col    : out std_logic_vector(2 downto 0);
        grilla_fil    : out std_logic_vector(2 downto 0));
end grilla;

architecture solucion of grilla is
--grilla_col<= "0000" when (to_integer(unsigned(columna))>=15   and to_integer(unsigned(columna))<=135 and visible='1') else
--             "0001" when (to_integer(unsigned(columna))>=135  and to_integer(unsigned(columna))<=255 and visible='1') else
--             "0010" when (to_integer(unsigned(columna))>=255  and to_integer(unsigned(columna))<=375 and visible='1') else
--             "0011" when (to_integer(unsigned(columna))>=375  and to_integer(unsigned(columna))<=495 and visible='1') else
--             "0100" when (to_integer(unsigned(columna))>=495  and to_integer(unsigned(columna))<=615 and visible='1') else
--             "0101" when (to_integer(unsigned(columna))>=615  and to_integer(unsigned(columna))<=679 and visible='1') else
--             "1111" when others;
--
--grilla_fil<= "0000" when (to_integer(unsigned(fila))>=9    and to_integer(unsigned(fila))<=129 and visible='1') else
--             "0001" when (to_integer(unsigned(fila))>=129  and to_integer(unsigned(fila))<=249 and visible='1') else
--             "0010" when (to_integer(unsigned(fila))>=249  and to_integer(unsigned(fila))<=369 and visible='1') else
--             "0011" when (to_integer(unsigned(fila))>=369  and to_integer(unsigned(fila))<=489 and visible='1') else
--             "1111" when others;
--             

    begin
       
        
    end solucion;