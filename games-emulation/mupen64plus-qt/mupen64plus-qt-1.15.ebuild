# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dh4/${PN}"
else
	SRC_URI="https://github.com/dh4/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="A basic cross-platform launcher for mupen64plus"
HOMEPAGE="https://github.com/dh4/mupen64plus-qt"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtxml:5
		dev-qt/qtsql:5
		dev-qt/qtwidgets:5
		dev-libs/quazip"
RDEPEND=">=games-emulation/mupen64plus-core-2.0
		${DEPEND}"

src_prepare() {
	sed -i 's:LIBS += -lquazip5:LIBS += -lquazip1-qt5 -lQt5Core:' \
		mupen64plus-qt.pro || die
	sed -i 's:#include <quazip5/:#include <QuaZip-Qt5-1.1/quazip/:' \
		src/emulation/emulatorhandler.cpp src/common.cpp || die
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
