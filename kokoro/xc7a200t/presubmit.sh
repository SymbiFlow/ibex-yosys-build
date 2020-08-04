#!/bin/bash
# Copyright (C) 2017-2020  The Project X-Ray Authors.
#
# Use of this source code is governed by a ISC-style
# license that can be found in the LICENSE file or at
# https://opensource.org/licenses/ISC
#
# SPDX-License-Identifier: ISC

set -e

cd github/$KOKORO_DIR/

source ./kokoro/steps/hostsetup.sh
source ./kokoro/steps/hostinfo.sh
source ./kokoro/steps/git.sh

source ./kokoro/steps/hostsetup-a200t.sh
source ./kokoro/steps/download-a200t-arch-defs.sh

source ./kokoro/steps/riscv-env.sh

echo
echo "========================================"
echo "Running tests"
echo "----------------------------------------"
(
	make ibex/configure
	make all PARTNAME=xc7a200tsbg484-1 DEVICE=xc7a200t_test PCF=${PWD}/a200t/a200t-arty.pcf SDC=${PWD}/a200t/a200t-arty.sdc XDC=${PWD}/a200t/a200t-arty.xdc
)
echo "----------------------------------------"

# TODO
#echo
#echo "========================================"
#echo "Copying tests logs"
#echo "----------------------------------------"
#(
#)
#echo "----------------------------------------"
