library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Imp_pantalla is
    
    port(
        dato               : in std_logic_vector (63 downto 0);
        fila_celda         : in std_logic_vector(2 downto 0);
        columna_celda      : in std_logic_vector(2 downto 0);
        en_caracter        : in std_logic;                   

        dato_ms            : in std_logic_vector (63 downto 0);
        fila_marco_sup     : in std_logic_vector(2 downto 0);
        columna_marco_sup  : in std_logic_vector(2 downto 0);                   
        en_marco_sup       : in std_logic;                   

        dato_mi            : in std_logic_vector (63 downto 0);
        fila_marco_inf     : in std_logic_vector(2 downto 0);
        columna_marco_inf  : in std_logic_vector(2 downto 0);                   
        en_marco_inf       : in std_logic;

        pixel           : out std_logic

        );
end Imp_pantalla;

architecture solucion of Imp_pantalla is
    signal pos_en_dato  : integer;
    signal pos_marc_sup : integer;
    signal pos_marc_inf : integer;
begin

 pos_en_dato  <= 63-to_integer(unsigned(fila_celda)&unsigned(columna_celda));
 pos_marc_sup <= 63-to_integer(unsigned(fila_marco_sup)&unsigned(columna_marco_sup));
 pos_marc_inf <= 63-to_integer(unsigned(fila_marco_inf)&unsigned(columna_marco_inf));

 pixel  <=dato(pos_en_dato)       when en_caracter='1'  else
          dato_ms(pos_marc_sup)   when en_marco_sup='1' else 
          dato_mi(pos_marc_inf)   when en_marco_inf='1' else 
          '0' ;
    
end solucion;