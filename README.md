# ibex-yosys-build
[![Build Status](https://travis-ci.com/antmicro/ibex-yosys-build.svg?branch=master)](https://travis-ci.com/antmicro/ibex-yosys-build)
This repository contains scripts to synthesize and build Ibex CPU for Arty A7 (A100T) board using SymbiFlow toolchain.
# Getting started
## Clone repository
```
git clone --recursive https://github.com/antmicro/ibex-yosys-build
```
## Install Prerequisites
This repository requires `SymbiFlow toolchain` and `Lowrisc RISCV toolchain`
Install `SymbiFlow toolchain` using:
```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O conda_installer.sh
export INSTALL_DIR="/opt/symbiflow/xc7"
bash conda_installer.sh -b -p $INSTALL_DIR/conda && rm conda_installer.sh
source "$INSTALL_DIR/conda/etc/profile.d/conda.sh"
conda env create -f examples/xc7/environment.yml
conda activate xc7
wget -qO- https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/27/20200630-100111/symbiflow-arch-defs-install-30f7325f.tar.xz | tar -xJ -C $INSTALL_DIR
export PATH="$INSTALL_DIR/install/bin:$PATH"
```
download `Lowrisc RISCV toolchain` using (you can change the installation directory using `-t` flag):
```
wget https://raw.githubusercontent.com/lowRISC/opentitan/master/util/get-toolchain.py
python3 get-toolchain.py -t ${PWD}/tools/riscv
export PATH=$PATH:${PWD}/tools/riscv/bin
```
## Preparing tools
To prepare environment, apply `ibex.patch`, download ibex requirements and prepare ibex for Arty A7 to build with `yosys`:
```
cd ibex
git apply ../ibex.patch
pip install -r python-requirements.txt
make sw-led
fusesoc --cores-root=. run --target=synth --setup lowrisc:ibex:top_artya7 --part xc7a100tcsg324-1L
cd ..
make ibex/configure
make patch/symbiflow
```
Build yosys, symbiflow yosys plugins and install it in conda environment:
```
cd yosys && make -j$(nproc) && PREFIX=$INSTALL_DIR/conda/envs/xc7 make install && cd ..
cd yosys-symbiflow-plugins && make -j$(nproc) install && cd ..
```

## Generating bitstream
To generate bitstream run:
```
make
```
