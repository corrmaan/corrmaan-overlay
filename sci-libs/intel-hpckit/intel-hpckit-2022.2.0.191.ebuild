# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs

MY_PN=HPCKit
MAGIC=18679

DESCRIPTION="Build applications across shared- and distributed-memory computing systems."
SRC_URI="https://registrationcenter-download.intel.com/akdlm/irc_nas/${MAGIC}/l_${MY_PN}_p_${PV}_offline.sh"
HOMEPAGE="https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit.html"

LICENSE="Intel-EULA-DevTools"
KEYWORDS="~amd64"
SLOT="0"
IUSE="clck cxx fortran inspector itac mpi"

RDEPEND="virtual/libcrypt:="

S="${WORKDIR}/l_${MY_PN}_p_${PV}_offline"

INSTDIR="opt/intel/oneapi"

addpredict /etc/OpenCL/vendors/intel64.icd
addpredict /etc/OpenCL/vendors/Altera.icd
addpredict /etc/OpenCL/vendors/Intel_FPGA_SSG_Emulator.icd
addpredict /usr/local/lib/cmake
addpredict /usr/local/share/pkgconfig
# Yucky, but necessary. Cleanup at end of src_install().
addwrite /opt
addwrite /var

RESTRICT="binchecks mirror preserve-libs strip"

CHECKREQS_DISK_VAR=2G
CHECKREQS_DISK_BUILD=6G

pkg_pretend() {

	check-reqs_pkg_pretend

}

pkg_setup() {

	check-reqs_pkg_setup

}

src_unpack() {

	mkdir -p "${S}"

}

src_install() {

	default

	local MYCOMPS=""

	use clck && MYCOMPS+="intel.oneapi.lin.clck "
	use cxx && MYCOMPS+="intel.oneapi.lin.dpcpp-cpp-compiler-pro "
	use fortran && MYCOMPS+="intel.oneapi.lin.ifort-compiler "
	use inspector && MYCOMPS+="intel.oneapi.lin.inspector "
	use itac && MYCOMPS+="intel.oneapi.lin.itac "
	use mpi && MYCOMPS+="intel.oneapi.lin.mpi.devel "

	if [ -z "${MYCOMPS}" ]
	then
		  die "No USE flags set."
	fi

	MYCOMPS="$(echo ${MYCOMPS} | xargs)" # Remove trailing space.
	MYCOMPS="${MYCOMPS// /:}" # Change delimiter from space to colon.

	sh "${DISTDIR}/l_${MY_PN}_p_${PV}_offline.sh" -f "${WORKDIR}" -r no -a \
		--silent \
		--eula accept \
		--action install \
		--components "${MYCOMPS}" \
		--install-dir "${ED}/${INSTDIR}"

	# Get rid of the garbage
	rm -rf /opt/intel/{packagemanager,oneapi/installer}
	rmdir /opt/intel/oneapi
	rmdir /opt/intel
	rm -rf /var/intel/{installercache,pythonpackages}
	rmdir /var/intel

}
