#!/bin/bash
# Copyright (C) 2017-2020  The Project X-Ray Authors.
#
# Use of this source code is governed by a ISC-style
# license that can be found in the LICENSE file or at
# https://opensource.org/licenses/ISC
#
# SPDX-License-Identifier: ISC

set -e

echo
echo "========================================"
echo "Install nix"
echo "----------------------------------------"
(
	echo
	echo "----------------------------------------"
	sudo curl -L https://nixos.org/nix/install | sh
	echo "----------------------------------------"
)
