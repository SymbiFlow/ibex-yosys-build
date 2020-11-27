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

export DEVICE=xc7a50t_test
export PARTNAME=xc7a35tcsg324-1
export XDC=${PWD}/arty.xdc
export SDC=${PWD}/arty.sdc
export PCF=${PWD}/arty.pcf

source ./kokoro/steps/hostsetup.sh
source ./kokoro/steps/hostinfo.sh
source ./kokoro/steps/git.sh

source ./kokoro/steps/run_tests.sh
