#
# Use of this source code is governed by a ISC-style
# license that can be found in the LICENSE file or at
# https://opensource.org/licenses/ISC
#
# SPDX-License-Identifier: ISC

set -e


echo
echo "========================================"
echo "Install A200T arch def"
echo "----------------------------------------"
(
	. /home/kbuilder/.nix-profile/etc/profile.d/nix.sh
	wget -q https://gist.githubusercontent.com/HackerFoo/686a6292eb49d09efdb02ae71b006c07/raw/f30e915740ad95ebe8d3382defecb16edb92d2e6/narball.sh
	chmod +x narball.sh

	echo "Downloading A200T arch def"
	./narball.sh 6zj0j9vn5zf8nzfl2vbfcsfymi58ajnv-symbiflow
	echo "Unpacking A200T arch def"
	tar -xf 6zj0j9vn5zf8nzfl2vbfcsfymi58ajnv-symbiflow.tar.gz -C ${PWD}/env/symbiflow --strip 1
	echo "Fixing reference to /bin/bash in package"
	find ${PWD}/env/symbiflow/bin -type f -exec sed -i 's/\/nix\/store\/hrpvwkjz04s9i4nmli843hyw9z4pwhww-bash-4.4-p23//g' {} \;
	echo "Downloading prjxray-tools"
	wget -q https://anaconda.org/SymbiFlow/prjxray-tools/0.1_2646_gec6f9c51/download/linux-64/prjxray-tools-0.1_2646_gec6f9c51-20200723_171057.tar.bz2
	echo "Fixing xc7frames2bit executable"
	tar -xf prjxray-tools-0.1_2646_gec6f9c51-20200723_171057.tar.bz2 bin/xc7frames2bit -C ${PWD}/env/symbiflow
	mv ${PWD}/bin/xc7frames2bit ${PWD}/env/symbiflow
)
