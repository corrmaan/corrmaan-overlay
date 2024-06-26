# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="A low latency KVMFR implementation for guests with VGA PCI Passthrough"
HOMEPAGE="https://looking-glass.io/"

MY_PN="LookingGlass"
if [ ! -z $(ver_cut 4) ]; then
	if [ ! -z $(ver_cut 6) ]; then
		MY_PV="B$(ver_cut 4)-rc$(ver_cut 6)"
	else
		MY_PV="B$(ver_cut 4)"
	fi
else
	MY_PV="${PV}"
fi
EGIT_REPO_URI="https://github.com/gnif/${MY_PN}.git"
EGIT_COMMIT="188f25c6bf6e4525652222be7408f628d7fec1fc"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE="debug"

BDEPEND="sys-devel/binutils:*
	>=dev-build/cmake-3.0
	media-libs/glu
	virtual/pkgconfig
	x11-base/xorg-server
	x11-libs/libXfixes
	x11-libs/libxcb"
DEPEND="${BDEPEND}"

CMAKE_USE_DIR="${S}"/host

src_configure() {
	local mycmakeargs=(
		-DCMAKE_C_FLAGS="-Wno-uninitialized"
		-DENABLE_BACKTRACE="$(usex debug)"
	)
	cmake_src_configure
}
