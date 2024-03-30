# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop git-r3 tmpfiles xdg-utils

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
IUSE="X debug doc +host wayland"

BDEPEND="sys-devel/binutils:*
	>=dev-build/cmake-3.0
	media-fonts/freefonts
	app-emulation/spice-protocol
	media-libs/fontconfig
	dev-libs/nettle[gmp]
	media-libs/glu
	virtual/pkgconfig
	>=virtual/tmpfiles-0-r3
	X? ( media-gfx/icoutils
		media-gfx/imagemagick
		x11-base/xorg-server
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

	if use X
	then
		cd resources
		icotool -x -o . icon.ico
		local i
		local j=1
		for i in 128 64 32 16; do
			newicon -s ${i} "icon_${j}_${i}x${i}x32.png" ${P}.png
			j=$((j+1))
		done
		make_desktop_entry "${PN}" "Looking Glass Client" ${P} "System;Emulator" \
			"StartupWMClass=\"Looking Glass (client)\", \"${PN}\""
		cd -
	fi
}

pkg_postinst() {

	tmpfiles_process ${PN}.conf

	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update

}

pkg_postrm() {

	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update

}
