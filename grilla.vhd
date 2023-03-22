library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.numeric_std_unsigned.all;

entity grilla is
    
    port(
                         
        visible   : in std_logic; 
        fila      : in std_logic_vector(9 downto 0);
        columna   : in std_logic_vector(9 downto 0);

        zona_en_la_pantalla: out std_logic_vector(2 downto 0)
        );
end grilla;

architecture solucion of grilla is
    subtype zona is std_logic_vector(2 downto 0);

    constant fondo  : zona := "000";
    constant celda_1: zona := "001";
    constant celda_2: zona := "010";
    constant celda_3: zona := "011";
    constant celda_4: zona := "100";
    constant celda_5: zona := "101";

    begin
        zona_en_la_pantalla<= fondo when ((to_integer(fila)<=111 or 368<=to_integer(fila)) and visible='1' ) else
                              celda_1 when ((to_integer(fila)<=367 or 112<=to_integer(fila)) and visible='1' and (to_integer(columna)<=127 or 0<=to_integer(columna))) else
                              celda_2 when ((to_integer(fila)<=367 or 112<=to_integer(fila)) and visible='1' and (to_integer(columna)<=255 or 127<=to_integer(columna))) else
                              celda_3 when ((to_integer(fila)<=367 or 112<=to_integer(fila)) and visible='1' and (to_integer(columna)<=383 or 255<=to_integer(columna))) else
                              celda_4 when ((to_integer(fila)<=367 or 112<=to_integer(fila)) and visible='1' and (to_integer(columna)<=511 or 383<=to_integer(columna))) else
                              celda_5 when ((to_integer(fila)<=367 or 112<=to_integer(fila)) and visible='1' and (to_integer(columna)<=639 or 512<=to_integer(columna))) else
                              "111";--Error no está en la pantalla visible
       
        
    end solucion;