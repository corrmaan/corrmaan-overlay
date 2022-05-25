# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=BaseKit
MAGIC=18673
HPC_PN=HPCKit
HPC_MAGIC=18679
HPC_PV=2022.2.0.191

DESCRIPTION="Build high-performance, data-centric applications across diverse architectures."
SRC_URI="https://registrationcenter-download.intel.com/akdlm/irc_nas/${MAGIC}/l_${MY_PN}_p_${PV}_offline.sh
		 clck? ( https://registrationcenter-download.intel.com/akdlm/irc_nas/${HPC_MAGIC}/l_${HPC_PN}_p_${HPC_PV}_offline.sh )
		 fortran? ( https://registrationcenter-download.intel.com/akdlm/irc_nas/${HPC_MAGIC}/l_${HPC_PN}_p_${HPC_PV}_offline.sh )
		 inspector? ( https://registrationcenter-download.intel.com/akdlm/irc_nas/${HPC_MAGIC}/l_${HPC_PN}_p_${HPC_PV}_offline.sh )
		 itac? ( https://registrationcenter-download.intel.com/akdlm/irc_nas/${HPC_MAGIC}/l_${HPC_PN}_p_${HPC_PV}_offline.sh )
		 mpi? ( https://registrationcenter-download.intel.com/akdlm/irc_nas/${HPC_MAGIC}/l_${HPC_PN}_p_${HPC_PV}_offline.sh )"
HOMEPAGE="https://www.intel.com/content/www/us/en/developer/tools/oneapi/overview.html"

LICENSE="Intel-EULA-DevTools"
KEYWORDS="~amd64"
SLOT="0"
IUSE="advisor ccl clck cxx dal dnnl dpcppct dpcppdbg dpl fortran fpga inspector ipp ippcp itac mkl mpi python tbb vpl vtune"
REQUIRED_USE="|| ( ${IUSE} )"

RDEPEND="virtual/libcrypt:="

S="${WORKDIR}/l_${MY_PN}_p_${PV}_offline"
HPC_S="${WORKDIR}/l_${MY_PN}_p_${PV}_offline"

INSTDIR="opt/intel/oneapi"

addpredict /etc/OpenCL
addpredict /etc/OpenCL/vendors
addpredict /etc/OpenCL/vendors/intel64.icd
addpredict /etc/OpenCL/vendors/Altera.icd
addpredict /etc/OpenCL/vendors/Intel_FPGA_SSG_Emulator.icd
addpredict /usr/local/lib/cmake
addpredict /usr/local/share
addpredict /usr/local/share/pkgconfig
# Yucky, but necessary. Cleanup at end of src_install().
addwrite /opt
addwrite /var

RESTRICT="binchecks mirror preserve-libs strip"

src_unpack() {

	mkdir -p "${S}"
	if use clck || use fortran || use inspector || use itac || use mpi; then
		mkdir -p "${HPC_S}"
	fi

}

src_install() {

	default

	local MYCOMPS=""

	use advisor && MYCOMPS+="intel.oneapi.lin.advisor "
	use ccl && MYCOMPS+="intel.oneapi.lin.ccl.devel "
	use cxx && MYCOMPS+="intel.oneapi.lin.dpcpp-cpp-compiler "
	use dal && MYCOMPS+="intel.oneapi.lin.dal.devel "
	use dnnl && MYCOMPS+="intel.oneapi.lin.dnnl "
	use dpcppct && MYCOMPS+="intel.oneapi.lin.dpcpp-ct "
	use dpcppdbg && MYCOMPS+="intel.oneapi.lin.dpcpp_dbg "
	use dpl && MYCOMPS+="intel.oneapi.lin.dpl "
	use fpga && MYCOMPS+="intel.oneapi.lin.fpga.group "
	use ipp && MYCOMPS+="intel.oneapi.lin.ipp.devel "
	use ippcp && MYCOMPS+="intel.oneapi.lin.ippcp.devel "
	use mkl && MYCOMPS+="intel.oneapi.lin.mkl.devel "
	use python && MYCOMPS+="intel.oneapi.lin.python3 "
	use tbb && MYCOMPS+="intel.oneapi.lin.tbb.devel "
	use vpl && MYCOMPS+="intel.oneapi.lin.vpl "
	use vtune && MYCOMPS+="intel.oneapi.lin.vtune "

	if ! [ -z "${MYCOMPS}" ]; then
		MYCOMPS="$(echo ${MYCOMPS} | xargs)" # Remove trailing space.
		MYCOMPS="${MYCOMPS// /:}" # Change delimiter from space to colon.

		sh "${DISTDIR}/l_${MY_PN}_p_${PV}_offline.sh" -f "${WORKDIR}" -r no -a \
			--silent \
			--eula accept \
			--action install \
			--components "${MYCOMPS}" \
			--download-cache "${T}" \
			--ignore-errors \
			--install-dir "${ED}/${INSTDIR}" || die
	fi

	if use clck || use fortran || use inspector || use itac || use mpi; then
		local HPC_MYCOMPS=""

		use clck && HPC_MYCOMPS+="intel.oneapi.lin.clck "
		use cxx && MYCOMPS+="intel.oneapi.lin.dpcpp-cpp-compiler-pro "
		use fortran && HPC_MYCOMPS+="intel.oneapi.lin.ifort-compiler "
		use inspector && HPC_MYCOMPS+="intel.oneapi.lin.inspector "
		use itac && HPC_MYCOMPS+="intel.oneapi.lin.itac "
		use mpi && HPC_MYCOMPS+="intel.oneapi.lin.mpi.devel "

		if ! [ -z "${HPC_MYCOMPS}" ]; then
			HPC_MYCOMPS="$(echo ${HPC_MYCOMPS} | xargs)" # Remove trailing space.
			HPC_MYCOMPS="${HPC_MYCOMPS// /:}" # Change delimiter from space to colon.

			sh "${DISTDIR}/l_${HPC_PN}_p_${HPC_PV}_offline.sh" -f "${WORKDIR}" -r no -a \
				--silent \
				--eula accept \
				--action install \
				--components "${HPC_MYCOMPS}" \
				--download-cache "${T}" \
				--ignore-errors \
				--install-dir "${ED}/${INSTDIR}" || die
		fi
	fi

	# Cleanup
	rm -rf /opt/intel/oneapi/installer /opt/intel/packagemanager
	rmdir --ignore-fail-on-non-empty /opt/intel/oneapi /opt/intel
	rm -rf /var/intel/installercache /var/intel/pythonpackages
	rmdir --ignore-fail-on-non-empty /var/intel

}
