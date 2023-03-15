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

architecture solucion of ffd is
    begin
       
        
    end solucion;