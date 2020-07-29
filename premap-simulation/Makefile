all:: unisim/.patch dump.vcd

clean::
	rm -f dump.vcd tb

tb: tb.v
	iverilog -g2005-sv -s tb -o $@ \
		$^ \
		/opt/symbiflow/ibex-yosys-build/build/top_artya7_synth.v.premap.v \
		unisim/verilog/src/unisims/PLLE2_ADV.v \
		unisim/verilog/src/unisims/BUFG.v \
		unisim/verilog/src/unisims/LUT2.v \
		unisim/verilog/src/unisims/LUT3.v \
		unisim/verilog/src/unisims/LUT4.v \
		unisim/verilog/src/unisims/LUT5.v \
		unisim/verilog/src/unisims/LUT6.v \
		unisim/verilog/src/unisims/INV.v \
		unisim/verilog/src/unisims/IBUF.v \
		unisim/verilog/src/unisims/OBUF.v \
		unisim/verilog/src/unisims/FDCE.v \
		unisim/verilog/src/unisims/FDRE.v \
		unisim/verilog/src/unisims/FDPE.v \
		unisim/verilog/src/unisims/RAMB36E1.v \
		stub.v

dump.vcd: tb
	vvp $<

unisim/.clone:
	git clone https://github.com/Xilinx/XilinxUnisimLibrary.git unisim && touch $@

unisim/.patch: unisim.patch unisim/.clone
	(cd unisim && patch -Np1 < ../unisim.patch) && touch $@
