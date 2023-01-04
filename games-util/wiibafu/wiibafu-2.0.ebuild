# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils

MY_PN="WiiBaFu"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/larsenv/Wii-Backup-Fusion"
else
	SRC_URI="https://codeload.github.com/larsenv/Wii-Backup-Fusion/tar.gz/refs/tags/v${PV} -> ${P}.tar.gz"
fi

DESCRIPTION="The complete and simply to use backup solution for your Wii games"
HOMEPAGE="https://github.com/larsenv/Wii-Backup-Fusion"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore"
RDEPEND="games-util/wit"

S="${WORKDIR}/Wii-Backup-Fusion-${PV}"

src_configure() {
	eqmake5
}

src_install() {
	einstalldocs
	dobin bin/${MY_PN}
	domenu resources/${MY_PN}.desktop
	newicon resources/images/${MY_PN}.png ${MY_PN}.png
}
