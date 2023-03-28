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
        0 => x"45",--e
        1 => x"4C",--l
        2 => x"45",--e
        3 => x"43",--c
        4 => x"54",--t
        5 => x"52",--r
        6 => x"4F",--o
        7 => x"4E",--n
        8 => x"49",--i
        9 => x"43",--c
        10=> x"41",--a
        11=> x"00",--
        12=> x"49",--i
        13=> x"49",--i
        14=> x"00",--
        15=> x"00" );
begin
    dir<=letra(to_integer(unsigned('0'&celda)+unsigned(celda_offset)));
    end solucion;