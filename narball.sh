#!/usr/bin/env bash

# Download from a Nix cache to a tarball
# --------------------------------------
# This script takes the part of the store path after /nix/store as the argument to specify what to download
# You can find this in the build details page on Hydra under "Output store paths".

# Requirements: nix, curl, xz (zxdec)

set -e

STORE_PATH=$1
TMPDIR=$(mktemp -d)
CACHE=https://hydra.vtr.tools

curl ${CACHE}/nar/${STORE_PATH} | xzdec | nix-store --restore ${TMPDIR}/${STORE_PATH}
tar -C ${TMPDIR} -czf ${PWD}/${STORE_PATH}.tar.gz ${STORE_PATH}
rm -rf ${TMPDIR}

