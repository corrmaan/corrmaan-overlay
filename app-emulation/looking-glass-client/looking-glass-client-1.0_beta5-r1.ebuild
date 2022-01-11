# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3 tmpfiles

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
IUSE="X debug doc +host wayland"

BDEPEND="sys-devel/binutils:*
	>=dev-util/cmake-3.0
	media-fonts/freefonts
	app-emulation/spice-protocol
	media-libs/fontconfig
	dev-libs/nettle[gmp]
	media-libs/glu
	virtual/pkgconfig
	X? ( x11-base/xorg-server
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXpresent
		x11-libs/libXScrnSaver )
	doc? ( dev-python/sphinx )
	wayland? ( dev-libs/wayland
		>=dev-libs/wayland-protocols-1.15 )"
DEPEND="${BDEPEND}
	host? ( || ( ~app-emulation/looking-glass-host-bin-${PV} ~app-emulation/looking-glass-host-${PV} ) )"

CMAKE_USE_DIR="${S}"/client

src_configure() {
	local mycmakeargs=(
		-DENABLE_X11="$(usex X)"
		-DENABLE_BACKTRACE="$(usex debug)"
		-DENABLE_WAYLAND="$(usex wayland)"
	)
	cmake_src_configure
}

src_compile() {
	default
	cmake_src_compile
	if use doc; then
		cd doc
		make html || die "Documentation build failed."
		cd -
		use doc && HTML_DOCS=( "${S}"/doc/_build/html/* )
	fi
}

src_install() {
	default
	cmake_src_install

	echo "f /dev/shm/looking-glass 0660 qemu kvm -" > ${PN}.conf
	newtmpfiles ${PN}.conf ${PN}.conf
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}
