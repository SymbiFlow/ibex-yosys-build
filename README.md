# ibex-yosys-build
[![Build Status](https://travis-ci.com/antmicro/ibex-yosys-build.svg?branch=master)](https://travis-ci.com/antmicro/ibex-yosys-build)
This repository contains scripts to synthesize and build Ibex CPU for Nexys Video (A200T) board using SymbiFlow toolchain.
# Getting started
## Clone repository
```
git clone --recursive https://github.com/antmicro/ibex-yosys-build
```
## Install Prerequisites
This repository requires `SymbiFlow toolchain`, `Lowrisc RISCV toolchain` and `nix`.
To install `nix` follow installation guide on: [Nix website](https://nixos.org/download.html).
Install `SymbiFlow toolchain` using (this step requires `nix`):
```
export INSTALL_DIR="/opt/symbiflow/xc7"

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O conda_installer.sh
bash conda_installer.sh -b -p $INSTALL_DIR/conda && rm conda_installer.sh
source "$INSTALL_DIR/conda/etc/profile.d/conda.sh"
conda env create -f examples/xc7/environment.yml
conda activate xc7

./narball.sh 6zj0j9vn5zf8nzfl2vbfcsfymi58ajnv-symbiflow
mkdir -p $INSTALL_DIR/install
tar -xvf 6zj0j9vn5zf8nzfl2vbfcsfymi58ajnv-symbiflow.tar.gz -C $INSTALL_DIR/install --strip 1
find $INSTALL_DIR/install/bin -type f -exec sed -i 's/\/nix\/store\/hrpvwkjz04s9i4nmli843hyw9z4pwhww-bash-4.4-p23//g' {} \; // fix hardcoded path to bash
wget https://anaconda.org/SymbiFlow/prjxray-tools/0.1_2646_gec6f9c51/download/linux-64/prjxray-tools-0.1_2646_gec6f9c51-20200723_171057.tar.bz2 > /dev/null
tar -xf prjxray-tools-0.1_2646_gec6f9c51-20200723_171057.tar.bz2
cp bin/xc7frames2bit $INSTALL_DIR/install/bin/xc7frames2bit // fix bad path in generated xc7frames2bit from nix

export PATH="$INSTALL_DIR/install/bin:$PATH"
```
download `Lowrisc RISCV toolchain` using (you can change the installation directory using `-t` flag):
```
wget https://raw.githubusercontent.com/lowRISC/opentitan/master/util/get-toolchain.py
python3 get-toolchain.py -t ${PWD}/tools/riscv
export PATH=$PATH:${PWD}/tools/riscv/bin
```
## Preparing tools
To prepare environment, apply `ibex.patch`, download ibex requirements and prepare ibex for Nexys Video to build with `yosys`:
```
cd ibex
git apply ../ibex.patch
pip install -r python-requirements.txt
make sw-led
fusesoc --cores-root=. run --target=synth --setup lowrisc:ibex:top_artya7 --part xc7a200tsbg484-1L
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
