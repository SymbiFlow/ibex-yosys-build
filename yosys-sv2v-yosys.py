#!/usr/bin/env python3

import edalize
import os
import glob
import subprocess

work_root = 'yosys-sv2v-yosys-vivado-build'
post_imp_file = os.path.realpath(os.path.join(work_root, 'post.tcl'))
os.makedirs(work_root, exist_ok=True)

srcs = glob.glob("./ibex/build/**/*.sv", recursive=True)

with open(post_imp_file, 'w') as f:
    f.write('write_checkpoint -force design.dcp')

files = [
    {'name': os.path.realpath('./ibex/build/lowrisc_ibex_top_artya7_0.1/src/lowrisc_ibex_top_artya7_0.1/data/pins_artya7.xdc'), 'file_type': 'xdc'},
    {'name': os.path.realpath('./ibex.v'), 'file_type': 'verilogSource'}
]

skip_files = ["ibex_icache.sv", "ibex_cs_registers.sv", "ibex_counters.sv", "ibex_fetch_fifo.sv", "ibex_core.sv", "ibex_pmp.sv", "ibex_alu.sv"]

sv2v_files = []

PRIM_ASSERT_DIR = ""
for src in srcs:
    basename = os.path.basename(src)
    if basename in skip_files:
        sv2v_files.append(src)
        continue
    if basename == "prim_assert.sv":
      files.append({'name': os.path.realpath(src), 'file_type': 'systemVerilogSource', 'is_include_file': 'true'})
      PRIM_ASSERT_DIR = os.path.dirname(src)
    elif basename == "ibex_pkg.sv":
      files.insert(0, {'name': os.path.realpath(src), 'file_type': 'systemVerilogSource'})
      sv2v_files.append(src)
    else:
      files.append({'name': os.path.realpath(src), 'file_type': 'systemVerilogSource'})


SRAM_INIT_FILE_PATH = os.getenv('SRAM_INIT_FILE_PATH')
cmd = ["sv2v", f"--define=SRAM_INIT_FILE={SRAM_INIT_FILE_PATH}", f"--incdir={PRIM_ASSERT_DIR}"]
for sv2v_file in sv2v_files:
    cmd.append(sv2v_file)
with open("ibex.v", "w") as f:
    subprocess.call(cmd, stdout=f)

parameters = {}
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
print("Files used to generate sv2v.v:")
for f in sv2v_files:
    print(f)
