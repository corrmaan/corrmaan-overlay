# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Analysis Tools for Explosive and Gas Dynamic Events"
SRC_URI="${P}.tar.xz"
HOMEPAGE="https://www.lr.org/en/explosion-testing-and-trial-support/"

LICENSE="LR-EULA"
KEYWORDS="~amd64"
SLOT="0"
IUSE="+fsi +mpi scalemp"

RDEPEND="mpi? (
			sci-libs/metis
			virtual/mpi
			>=sys-cluster/openmpi-3.1.3
		)
	"
DEPEND="${RDEPEND}"

REQUIRED_USE="mpi? ( !scalemp )
	scalemp? ( !mpi )"

RESTRICT="fetch"

S=${WORKDIR}

INSTDIR="opt/${PN}"

src_prepare() {
	default
	echo "SEARCH_DIRS_MASK=\"${EPREFIX}/opt/bin/${PN}"\" > "${T}/70-${PN}" || die
}

src_install() {
	into "/${INSTDIR}"

	local bins=( chinook_v222_serial CFDPP2Chinook_v2.3.3_linux_64bit Dyna2Chinook_v2.3.1_linux_64bit )
	use mpi && bins+=( chinook_v222_parallel-openmpi-3.1.3 merge_partitions_v1.8_linux64bit )
	use scalemp && bins+=( chinook_v222_parallel-mpich2-3.5.24 )
	use fsi && bins+=( ls971_R701_fsi_v2 lsdynaFSI_R11.1 )

	for bin in ${bins}; do
		dobin "${bin}"
		dosym "${EPREFIX}/${INSTDIR}/${bin}" "/opt/bin/${bin}"
	done

	insinto "/etc/revdep-rebuild"
	doins "${T}/70-${PN}"
}
