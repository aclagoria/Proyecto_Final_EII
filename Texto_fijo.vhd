library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Texto_fijo is
    
    port(
        celda           : in std_logic_vector  (2 downto 0);

        dir             : out std_logic_vector (7 downto 0)
        );
end Texto_fijo;

architecture solucion of Texto_fijo is
  subtype letra is std_logic_vector(7 downto 0);

  constant C0 : std_logic_vector(2 downto 0) := (others=>'0'); --celda 0 
  constant C1 : std_logic_vector(2 downto 0) := ("001");       --celda 1 
  constant C2 : std_logic_vector(2 downto 0) := ("010");       --celda 2 
  constant C3 : std_logic_vector(2 downto 0) := ("011");       --celda 3 
  constant C4 : std_logic_vector(2 downto 0) := ("100");       --celda 4 
      
  constant H : letra := "01001000";--letra H
  constant A : letra := "01000001";--letra A
  constant P : letra := "01010000";--letra P
  constant Y : letra := "01011001";--letra Y


begin
    
  with celda select
  dir<= H  when c0, 
        A  when c1, 
        P  when c2, 
        P  when c3, 
        Y  when c4, 
        (others=>'0')  when others;
          
end solucion;