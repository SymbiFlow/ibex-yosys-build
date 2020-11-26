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

echo
echo "========================================"
echo "Install riscv-toolchain"
echo "----------------------------------------"
(
	echo
	echo "----------------------------------------"
	make toolchain
	echo "----------------------------------------"
)

echo
echo "========================================"
echo "Setting up conda environment"
echo "----------------------------------------"
(
	echo
	echo " Configuring conda environment"
	echo "----------------------------------------"
	make env DEVICE=xc7a100t_test
	echo "----------------------------------------"
)

source ./kokoro/steps/riscv-env.sh

echo "----------------------------------------"

echo
echo "========================================"
echo "Install yosys"
echo "----------------------------------------"
(
	echo
	echo "----------------------------------------"
	make yosys/build
	make yosys/plugins
	echo "----------------------------------------"
)

echo
echo "========================================"
echo "Running tests"
echo "----------------------------------------"
(
	make ibex/configure
	make all PARTNAME=xc7a100tcsg324-1 DEVICE=xc7a100t_test
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
