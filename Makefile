std = --std=08
cf = work-obj08.cf
sincronismo:$(cf) 
	ghdl -m $(std) sincronismo_tb
	ghdl -r $(std) sincronismo_tb --assert-level=none --wave=sincronismo.ghw
	gtkwave -f sincronismo.ghw
$(cf): *.vhd
	ghdl -i $(std) *.vhd

Imp_pantalla:$(cf) 
	ghdl -m $(std) TestAmpliado_tb
	ghdl -r $(std) TestAmpliado_tb --assert-level=none --wave=Imp_pantalla.ghw
	gtkwave -f Imp_pantalla.ghw
$(cf): *.vhd
	ghdl -i $(std) *.vhd

Marquesina:$(cf) 
	ghdl -m $(std) Marquesina_tb
	ghdl -r $(std) Marquesina_tb --assert-level=none --wave=Marquesina.ghw
	gtkwave -f Marquesina.ghw
$(cf): *.vhd
	ghdl -i $(std) *.vhd
	