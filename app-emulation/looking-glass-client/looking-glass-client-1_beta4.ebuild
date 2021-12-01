# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV//1_beta/B}"

inherit cmake git-r3 tmpfiles

DESCRIPTION="A low latency KVMFR implementation for guests with VGA PCI Passthrough"
HOMEPAGE="https://looking-glass.io/"
EGIT_REPO_URI="https://github.com/gnif/LookingGlass.git"

if [[ ${PV} != "9999" ]]; then
	EGIT_COMMIT="25c88a1c6ca77c2db5f1fcef3458e3083b7bfaa7"
fi

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
	newtmpfiles "${FILESDIR}"/${PN}.conf 10-${PN}.conf
}

pkg_postinst() {
	tmpfiles_process 10-${PN}.conf
}
