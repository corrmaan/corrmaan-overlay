# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils qmake-utils git-r3

DESCRIPTION="A basic cross-platform launcher for mupen64plus"
HOMEPAGE="https://github.com/dh4/mupen64plus-qt"
EGIT_REPO_URI="https://github.com/dh4/mupen64plus-qt"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtxml:5
		dev-qt/qtsql:5
		dev-qt/qtwidgets:5
		dev-libs/quazip"
DEPEND=">=games-emulation/mupen64plus-core-2.0
		${RDEPEND}"

src_prepare() {
	sed -i 's:#include <quazip/:#include <quazip5/:' src/emulation/emulatorhandler.cpp src/common.cpp || die
	eapply_user
}

src_configure() {
    eqmake5
}

src_install() {
	dobin ${PN}
	dodoc README.md
	doman resources/${PN}.6
	domenu resources/${PN}.desktop
	newicon resources/images/mupen64plus.png ${PN}.png
}
