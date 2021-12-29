# Copyright 1999-2021 Gentoo Authors
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
EGIT_COMMIT="74444f8eeda44d894a814db6db837c239189c7d1"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

BDEPEND="sys-devel/binutils:*
	>=dev-util/cmake-3.0
	media-libs/glu
	virtual/pkgconfig
	x11-base/xorg-server
	x11-libs/libXfixes
	x11-libs/libxcb"
DEPEND="${BDEPEND}"

CMAKE_USE_DIR="${S}"/host

src_configure() {
	local mycmakeargs=(
		-DENABLE_BACKTRACE="$(usex debug)"
	)
	cmake_src_configure
}
