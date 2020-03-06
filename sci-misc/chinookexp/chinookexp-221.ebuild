# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Analysis Tools for Explosive and Gas Dynamic Events"
SRC_URI="chinookexp-221.tar.xz"
HOMEPAGE="https://www.lr.org/en/explosion-testing-and-trial-support/"

LICENSE="LR-EULA"
KEYWORDS="~amd64"
SLOT="0"
IUSE="+fsi +mpi static"

RDEPEND="mpi? ( 
		sci-libs/metis
		virtual/mpi
		>=sys-cluster/openmpi-3.1.2 
	      )
	"
DEPEND="${RDEPEND}"

RESTRICT="fetch"

S=${WORKDIR}

pkg_nofetch() {
	einfo "Please obtain"
	einfo "  - ${SRC_URI}"
	einfo "from whomever wrote this ebuild (probably Cory Marshall)."
}

src_install() {
	dobin CFDPP2Chinook_v2.3.3_linux_64bit
	dobin Dyna2Chinook_v2.3.1_linux_64bit
	use mpi && dobin chinookEXP_v221_linux64bit_parallel_openmpi-3.1.2
	use mpi && dobin chinookEXP_v221_linux64bit_parallel_scalemp_mpich2-3.2.23
	dobin chinookEXP_v221_linux64bit_serial
	use static && dobin chinookEXP_v221_linux64bit_serial_static
	use fsi && dobin ls971_R701_fsi_v2
	use mpi && dobin merge_partitions_v1.8_linux64bit
}


