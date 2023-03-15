std = --std=08
cf = work-obj08.cf
sincronismo:$(cf) 
	ghdl -m $(std) sincronismo_tb
	ghdl -r $(std) sincronismo_tb --assert-level=none --wave=sincronismo.ghw
	gtkwave -f sincronismo.ghw
$(cf): *.vhd
	ghdl -i $(std) *.vhd
