# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Analysis Tools for Explosive and Gas Dynamic Events"
SRC_URI="${P}.tar.xz"
HOMEPAGE="https://www.lr.org/en/explosion-testing-and-trial-support/"

LICENSE="LR-EULA"
KEYWORDS="~amd64"
SLOT="0"
IUSE="doc +fsi +mpi scalemp"

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

S="${WORKDIR}/${P}"

INSTDIR="opt/${PN}"

DOCS="doc/*"

src_prepare() {
	default
	echo "SEARCH_DIRS_MASK=\"${EPREFIX}/${INSTDIR}"\" > "${T}/70-${PN}" || die
	rm -rf Chinook_V223_*_win.exe LS_dyna_FSI_*.exe
}

src_install() {
	insinto "/${INSTDIR}"
	insopts -m0755

	bins=("chinook_v222_serial" "CFDPP2Chinook_v2.3.3_linux_64bit")
	use mpi && bins+=("Chinook_V223_openMPI" "merge_partitions_v1.8_linux64bit")
	use scalemp && bins+=("Chinook_V223_mpich")
	use fsi && bins+=("lsdyna_FSI_DP")

	for bin in ${bins[@]}; do
		doins "${bin}"
		dosym "${EPREFIX}/${INSTDIR}/${bin}" "/opt/bin/${bin}"
	done

	insinto "/etc/revdep-rebuild"
	insopts -m0644
	doins "${T}/70-${PN}"

	use doc && einstalldocs
}
