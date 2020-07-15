# ibex-yosys-build
[![Build Status](https://travis-ci.com/antmicro/ibex-yosys-build.svg?branch=master)](https://travis-ci.com/antmicro/ibex-yosys-build)
This repository contains scripts to synthesize Ibex CPU for Arty A7 board using yosys.
# Getting started
## Clone repository
```
git clone --recursive https://github.com/antmicro/ibex-yosys-build
```
## Install Prerequisites
This repository requires `fusesoc` and `Lowrisc RISCV toolchain`
Install `fusesoc` using:
```
pip install -r $(pwd)/ibex/python-requirements.txt
```
download `Lowrisc RISCV toolchain` using (you can change the installation directory using `-t` flag):
```
wget https://raw.githubusercontent.com/lowRISC/opentitan/master/util/get-toolchain.py
python3 get-toolchain.py -t $(pwd)/tools/riscv
```
## Preparing tools
To prepare environment, add a path to the toolchain into the PATH variable, apply `ibex.patch`, and prepare ibex for Arty A7 to build with `yosys`:
```
export PATH=$PATH:$(pwd)/tools/riscv/bin
cd ibex
git apply ../ibex.patch
make sw-led
fusesoc --cores-root=. run --target=synth --setup lowrisc:ibex:top_artya7 --part xc7a35ticsg324-1L --SRAMInitFile=$(pwd)/examples/sw/led/led.vmem
cd ..
```
Build yosys and add it to the PATH variable:
```
cd yosys && make -j$(nproc) && cd ..
export PATH=$PATH:$(pwd)/yosys
```

## Synthesizing ibex using yosys
Run synthesis using:
```
python yosys.py
```

