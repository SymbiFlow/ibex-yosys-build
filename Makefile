mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))
TOP := top_artya7

IBEX_BUILD = ${current_dir}/ibex/build/lowrisc_ibex_top_artya7_0.1

IBEX_INCLUDE = \
        -I$(IBEX_BUILD)/src/lowrisc_prim_assert_0.1/rtl \
        -I$(IBEX_BUILD)/src/lowrisc_prim_util_memload_0/rtl \

IBEX_PKG_SOURCES = \
        $(shell \
                cat ${IBEX_BUILD}/synth-vivado/lowrisc_ibex_top_artya7_0.1.tcl | \
                grep read_verilog | cut -d' ' -f3  | grep _pkg.sv | \
                sed 's@^..@${IBEX_BUILD}@')

IBEX_SOURCES = \
        $(IBEX_PKG_SOURCES) \
        $(shell \
                cat ${IBEX_BUILD}/synth-vivado/lowrisc_ibex_top_artya7_0.1.tcl | \
                grep read_verilog | cut -d' ' -f3 | grep -v _pkg.sv | \
                sed 's@^..@${IBEX_BUILD}@')

VERILOG := ${IBEX_SOURCES}
PARTNAME := xc7a35tcsg324-1
DEVICE  := xc7a50t_test
BITSTREAM_DEVICE := artix7
PCF := ${current_dir}/arty.pcf
SDC := ${current_dir}/arty.sdc
XDC := ${current_dir}/arty.xdc
BUILDDIR := build

SYMBIFLOW_TOOLS_URL = "https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/presubmit/install/1077/20201126-021625/symbiflow-arch-defs-install-c5272455.tar.xz"
ifeq ("$(DEVICE)","xc7a50t_test")
SYMBIFLOW_ARCH_URL = "https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/presubmit/install/1077/20201126-021625/symbiflow-xc7a50t_test.tar.xz"
else ifeq ("$(DEVICE)","xc7a100t_test")
SYMBIFLOW_ARCH_URL = "https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/presubmit/install/1077/20201126-021625/symbiflow-xc7a100t_test.tar.xz"
else ifeq ("$(DEVICE)","xc7a200t_test")
SYMBIFLOW_ARCH_URL = "https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/presubmit/install/1077/20201126-021625/symbiflow-xc7a200t_test.tar.xz"
endif


TOP_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
REQUIREMENTS_FILE := requirements.txt
ENVIRONMENT_FILE := environment.yml

third_party/make-env/conda.mk:
	git submodule init
	git submodule update --init --recursive

include third_party/make-env/conda.mk

env:: | $(CONDA_ENV_PYTHON)
	mkdir -p env/symbiflow
	wget -qO- ${SYMBIFLOW_TOOLS_URL} | tar -xJC env/symbiflow
	wget -qO- ${SYMBIFLOW_ARCH_URL} | tar -xJC env/symbiflow

all: patch/symbiflow ${BUILDDIR}/${TOP}.bit

ibex/configure:
	$(IN_CONDA_ENV) pip install -r ibex/python-requirements.txt
	cd ibex && git apply ../ibex.patch && make sw-led && $(IN_CONDA_ENV) fusesoc --cores-root=. run --target=synth --setup lowrisc:ibex:top_artya7 --part $(PARTNAME)L --SRAMInitFile=$(current_dir)/examples/sw/led/led.vmem && cd ..
	cp prim_generic_clock_gating.sv ibex/build/lowrisc_ibex_top_artya7_0.1/src/lowrisc_prim_generic_clock_gating_0/rtl/prim_generic_clock_gating.sv

patch/symbiflow:
	$(IN_CONDA_ENV) cp symbiflow_synth $(shell which symbiflow_synth)
	cp synth.tcl $(current_dir)/env/symbiflow/share/symbiflow/scripts/xc7/synth.tcl

yosys/plugins:
	cd yosys-symbiflow-plugins && $(IN_CONDA_ENV) $(MAKE) install && cd ..

yosys/build:
	cd yosys && $(MAKE) install PREFIX=$(current_dir)/env/conda/envs/xc7 && cd ..

toolchain:
	wget https://raw.githubusercontent.com/lowRISC/opentitan/master/util/get-toolchain.py
	python3 get-toolchain.py --install-dir $(current_dir)/riscv/

${BUILDDIR}:
	mkdir ${BUILDDIR}

${BUILDDIR}/${TOP}.eblif: | ${BUILDDIR}
	cd ${BUILDDIR} && $(IN_CONDA_ENV) symbiflow_synth -t ${TOP} -v ${VERILOG} -d ${BITSTREAM_DEVICE} -p ${PARTNAME} -i ${IBEX_INCLUDE} -x ${XDC} -l ${current_dir}/ibex/examples/sw/led/led.vmem

${BUILDDIR}/${TOP}.net: ${BUILDDIR}/${TOP}.eblif
	cd ${BUILDDIR} && $(IN_CONDA_ENV) symbiflow_pack -e ${TOP}.eblif -d ${DEVICE} -s ${SDC} > /dev/null

${BUILDDIR}/${TOP}.place: ${BUILDDIR}/${TOP}.net
	cd ${BUILDDIR} && $(IN_CONDA_ENV) symbiflow_place -e ${TOP}.eblif -d ${DEVICE} -p ${PCF} -n ${TOP}.net -P ${PARTNAME} -s ${SDC} > /dev/null

${BUILDDIR}/${TOP}.route: ${BUILDDIR}/${TOP}.place
	cd ${BUILDDIR} && $(IN_CONDA_ENV) symbiflow_route -e ${TOP}.eblif -d ${DEVICE} -s ${SDC} > /dev/null

${BUILDDIR}/${TOP}.fasm: ${BUILDDIR}/${TOP}.route
	cd ${BUILDDIR} && $(IN_CONDA_ENV) symbiflow_write_fasm -e ${TOP}.eblif -d ${DEVICE} > /dev/null

${BUILDDIR}/${TOP}.bit: ${BUILDDIR}/${TOP}.fasm
	cd ${BUILDDIR} && $(IN_CONDA_ENV) symbiflow_write_bitstream -d ${BITSTREAM_DEVICE} -f ${TOP}.fasm -p ${PARTNAME} -b ${TOP}.bit

clean::
	rm -rf ${BUILDDIR}

