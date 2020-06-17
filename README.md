# ibex-yosys-build
[![Build Status](https://travis-ci.com/antmicro/ibex-yosys-build.svg?branch=master)](https://travis-ci.com/antmicro/ibex-yosys-build)
This repository contains scripts to synthesize Ibex CPU for Arty A7 board using yosys.
# Getting started
## Clone repository
```
git clone --recursive https://github.com/antmicro/ibex-yosys-build
```
## Install Prerequisites
This repository requires `fusesoc`, `Lowrisc RISCV toolchain` and `sv2v` (for currently unsupported files with yosys).
Install `fusesoc` using:
```
pip install fusesoc
```
download `Lowrisc RISCV toolchain` using (you can change the installation directory using `-t` flag):
```
wget https://raw.githubusercontent.com/lowRISC/opentitan/master/util/get-toolchain.py
python3 get-toolchain.py -t ${PWD}/tools/riscv
```
and download `sv2v`:
```
wget https://github.com/zachjs/sv2v/releases/download/v0.0.3/sv2v-Linux.zip
unzip sv2v-Linux.zip
```
## Preparing tools
To prepare environment, add a path to the toolchain and sv2v into the PATH variable, apply `ibex.patch`, and prepare ibex for Arty A7 to build with `yosys`:
```
export PATH=$PATH:${PWD}/tools/riscv/bin:${PWD}/sv2v-Linux
cd ibex
git apply ../ibex.patch
make sw-led
fusesoc --cores-root=. run --target=synth --setup lowrisc:ibex:top_artya7 --part xc7a35ticsg324-1L
cd ..
```
Build yosys and add it to the PATH variable:
```
cd yosys && make -j$(nproc) && cd ..
export PATH=$PATH:${PWD}/yosys
```

## Synthesizing ibex using yosys
Run synthesis using:
```
PYTHONPATH=${PWD}/edalize python yosys-sv2v-yosys.py
```

## List of currently unsupported files by yosys:
Unsupported files are first processed by `sv2v` to generate a `verilog` file and then they are added to yosys as a verilog file.
```
ibex_pmp.sv
ibex_cs_registers.sv
ibex_alu.sv
ibex_core.sv
ibex_fetch_fifo.sv
ibex_icache.sv
```
