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
echo "Removing older packages"
echo "----------------------------------------"
sudo apt-get remove -y cmake
echo "----------------------------------------"

echo
echo "========================================"
echo "Host adding PPAs"
echo "----------------------------------------"
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | sudo apt-key add -
sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ xenial main'
echo "----------------------------------------"

echo
echo "========================================"
echo "Host updating packages"
echo "----------------------------------------"
sudo apt-get update
echo "----------------------------------------"

echo
echo "========================================"
echo "Host remove packages"
echo "----------------------------------------"
sudo apt-get remove -y \
	python-pytest \


sudo apt-get autoremove -y

echo "----------------------------------------"
echo
echo "========================================"
echo "Host install packages"
echo "----------------------------------------"
sudo apt-get install -y \
        bash \
        bison \
        build-essential \
        ca-certificates \
        clang \
        clang-format \
        cmake \
        colordiff \
        coreutils \
        curl \
        flex \
        fontconfig \
        git \
        graphviz \
        jq \
        libboost-system-dev \
        libboost-python-dev \
        libboost-filesystem-dev \
        libffi-dev \
        nodejs \
        psmisc \
        python \
        python3 \
        python3-dev \
        python3-virtualenv \
        python3-yaml \
        srecord \
        tcl-dev \
        unzip \
        virtualenv \
        wget \
        xdot \
        xzdec \
        zlib1g-dev \
        libtbb-dev \

echo "----------------------------------------"

(
	cd /tmp
	# Upgrade pstree to support the -T flag.
	wget https://storage.googleapis.com/prjxray-deps-debs/psmisc_23.2-1_amd64.deb
	sudo dpkg --install psmisc_23.2-1_amd64.deb
	which pstree
	pstree --help || true
)

echo "----------------------------------------"

echo
echo "========================================"
echo "Getting diff2html to produce pretty database diffs"
echo "----------------------------------------"
(
	sudo npm install -g diff2html-cli
)

echo "----------------------------------------"

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
	make env DEVICE=${DEVICE}
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
