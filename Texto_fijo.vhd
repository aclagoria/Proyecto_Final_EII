library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Texto_fijo is
    port(
      celda_marco_sup   : in  std_logic_vector (4 downto 0);
      celda_marco_inf   : in  std_logic_vector (4 downto 0);

      dir_ms            : out std_logic_vector (7 downto 0);
      dir_mi            : out std_logic_vector (7 downto 0)
      );
end Texto_fijo;

architecture solucion of Texto_fijo is
  subtype letra is std_logic_vector(7 downto 0);

begin
   
  with celda_marco_sup select 
  dir_ms<= x"04"  when 5x"03"|5x"04"|5x"0F"|5x"10", --DIAM
           x"50"  when 5x"06", --P
           x"52"  when 5x"07", --R
           x"4F"  when 5x"08", --O
           x"59"  when 5x"09", --Y
           x"45"  when 5x"0A", --E
           x"43"  when 5x"0B", --C
           x"54"  when 5x"0C", --T
           x"4F"  when 5x"0D", --O
           x"00"  when others;
    
  with celda_marco_inf select
  dir_mi<= x"00" when 5x"04"|5x"0F",
           x"49" when 5x"05", --I
           x"4E" when 5x"06", --N
           x"54" when 5x"07", --T
           x"45" when 5x"08", --E
           x"47" when 5x"09", --G
           x"52" when 5x"0A"|5x"0E", --R
           x"41" when 5x"0B", --A
           x"44" when 5x"0C", --D
           x"4F" when 5x"0D", --O
           x"04" when others; --diamante
          
end solucion;