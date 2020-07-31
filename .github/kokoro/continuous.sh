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

source ./.github/kokoro/steps/hostsetup.sh
source ./.github/kokoro/steps/hostinfo.sh
source ./.github/kokoro/steps/git.sh

source ./.github/kokoro/steps/riscv-env.sh

echo
echo "========================================"
echo "Running tests"
echo "----------------------------------------"
(
	make ibex/configure
	make all PARTNAME=$(PARTNAME) DEVICE=$(DEVICE)
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
