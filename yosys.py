#!/usr/bin/env python3

import edalize
import os
import glob
import re
from pathlib import Path

dirs_re = r'.*\[list (.*)\] .*'
work_root = 'yosys-build'
os.makedirs(work_root, exist_ok=True)
ibex_build_dir = './ibex/build/lowrisc_ibex_top_artya7_0.1'
tcl_dir = ibex_build_dir + '/synth-vivado'

packages = []
sources = []
include_srcs = []
xdc = []
defines = []

files = []
parameters = {}

with open(f'{tcl_dir}/lowrisc_ibex_top_artya7_0.1.tcl') as fp:
  for l in fp:
    if l.startswith('read_verilog'):
      filepath = l.split()[-1]
      filepath = filepath.strip('..')
      filepath = ibex_build_dir + filepath
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
          dir = ibex_build_dir + dir
          include_srcs.extend(glob.glob(dir+'/*.sv', recursive=False))
    if l.startswith('read_xdc'):
        filepath = l.split()[-1]
        filepath = filepath.strip('..')
        filepath = ibex_build_dir + filepath
        xdc.append(filepath)
    if l.startswith('set_property verilog_define'):
        defines_list = l[l.find('{') + 1:l.rfind('}')]
        for define in defines_list.split():
            key = define.split('=')[0]
            value = define.split('=')[1]
            defines.append({key: value})

# ensure packages are first in the list
for src in packages:
  files.insert(0, {'name': os.path.realpath(src), 'file_type': 'systemVerilogSource'})
for src in sources:
  files.append({'name': os.path.realpath(src), 'file_type': 'systemVerilogSource'})
for src in include_srcs:
  files.append({'name': os.path.realpath(src), 'file_type': 'systemVerilogSource', 'is_include_file': 'true'})
for src in xdc:
  files.append({'name': os.path.realpath(src), 'file_type': 'xdc'})

for define in defines:
    for key in define:
        if not define[key].isnumeric():
            resolved = Path(f'{tcl_dir}/{define[key]}').resolve()
            parameters[key] = {
                    'paramtype': 'vlogdefine',
                    'datatype': 'str',
                    'default': str(resolved),
                }
        else:
            parameters[key] = {
                    'paramtype': 'vlogdefine',
                    'datatype': 'int',
                    'default': define[key],
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
