#!/usr/bin/env python3

import edalize
import os
import glob
import subprocess
import re

dirs_re = r'.*\[list (.*)\] .*'
work_root = 'yosys-build'
os.makedirs(work_root, exist_ok=True)

packages = []
sources = []
include_srcs = []
with open('./ibex/build/lowrisc_ibex_top_artya7_0.1/synth-vivado/lowrisc_ibex_top_artya7_0.1.tcl') as fp:
  for l in fp:
    if l.startswith('read_verilog'):
      filepath = l.split()[-1]
      filepath = filepath.strip('..')
      filepath = './ibex/build/lowrisc_ibex_top_artya7_0.1' + filepath
      if filepath.endswith('_pkg.sv'):
        packages.append(filepath)
      else:
        sources.append(filepath)
    if l.startswith('set_property include_dirs'):
      dirs = re.match(dirs_re, l)
      if dirs is not None:
        dirs = dirs.groups()[0].split()
        for dir in dirs:
          dir = dir.strip('..')
          dir = ('./ibex/build/lowrisc_ibex_top_artya7_0.1' + dir)
          include_srcs.extend(glob.glob(dir+'/*.sv', recursive=False))

sram_init = glob.glob("./ibex/**/led.vmem", recursive=True)
SRAM_INIT_FILE_PATH = f"{os.path.abspath(os.getcwd())}/{sram_init[0]}"

files = [
    {'name': os.path.realpath('./ibex/build/lowrisc_ibex_top_artya7_0.1/src/lowrisc_ibex_top_artya7_0.1/data/pins_artya7.xdc'), 'file_type': 'xdc'},
]

# ensure packages are first in the list
for src in packages:
  files.insert(0, {'name': os.path.realpath(src), 'file_type': 'systemVerilogSource'})
for src in sources:
  files.append({'name': os.path.realpath(src), 'file_type': 'systemVerilogSource'})
for src in include_srcs:
  files.append({'name': os.path.realpath(src), 'file_type': 'systemVerilogSource', 'is_include_file': 'true'})


parameters = {
    'SRAM_INIT_FILE':
    {
	     'paramtype': 'vlogdefine',
	     'datatype': 'str',
	     'default': SRAM_INIT_FILE_PATH,
    }
}
tool = 'yosys'
yosys_synth_options = ['-iopad', '-family xc7']
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
