library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity txt is
    port(
        celda : in std_logic_vector (2 downto 0);
        celda_offset: in std_logic_vector (3 downto 0);

        dir: out std_logic_vector(7 downto 0)
        );
end txt;

architecture solucion of txt is
    type tabla is array (0 to 15) of std_logic_vector(7 downto 0 );
    constant letra : tabla :=(
        0 => x"48",
        1 => x"41", 
        2 => x"50",
        3 => x"50",
        4 => x"59",
        5 => x"00",
        6 => x"48",
        7 => x"41",
        8 => x"50",
        9 => x"50",
        10=> x"59",
        11=> x"03",
        12=> x"04",
        13=> x"05",
        14=> x"06",
        15=> x"01" );
begin
    dir<=letra(to_integer(unsigned('0'&celda)+unsigned(celda_offset)));
    end solucion;