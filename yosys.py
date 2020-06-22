#!/usr/bin/env python3

import edalize
import os
import glob
import subprocess

work_root = 'yosys-build'
os.makedirs(work_root, exist_ok=True)

srcs = glob.glob("./ibex/build/lowrisc_ibex_top_artya7_0.1/src/**/*.sv", recursive=True)
sram_init = glob.glob("./ibex/**/led.vmem", recursive=True)
SRAM_INIT_FILE_PATH = f"{os.path.abspath(os.getcwd())}/{sram_init[0]}"

files = [
    {'name': os.path.realpath('./ibex/build/lowrisc_ibex_top_artya7_0.1/src/lowrisc_ibex_top_artya7_0.1/data/pins_artya7.xdc'), 'file_type': 'xdc'},
]

PRIM_ASSERT_DIR = ""
for src in srcs:
    basename = os.path.basename(src)
    if basename == "prim_assert.sv":
      files.append({'name': os.path.realpath(src), 'file_type': 'systemVerilogSource', 'is_include_file': 'true'})
      PRIM_ASSERT_DIR = os.path.dirname(src)
    elif basename == "ibex_pkg.sv":
      files.insert(0, {'name': os.path.realpath(src), 'file_type': 'systemVerilogSource'})
    else:
      files.append({'name': os.path.realpath(src), 'file_type': 'systemVerilogSource'})

parameters = {
    'SRAM_INIT_FILE':
    {
	     'paramtype': 'vlogdefine',
	     'datatype': 'str',
	     'default': SRAM_INIT_FILE_PATH,
    }
}
tool = 'yosys'
yosys_synth_options = '-iopad -family xc7'
incdirs = {}
edam = {
  'files' : files,
  'name'  : 'design',
  'toplevel': 'top_artya7',
  'parameters': parameters,
  'tool_options' : {'yosys' : {
    'yosys_synth_options' : yosys_synth_options
    }}
}

backend = edalize.get_edatool(tool)(edam=edam, work_root=work_root)
backend.configure("")
backend.build()

print("Files used to generate:")
for f in files:
    print(f['name'])
