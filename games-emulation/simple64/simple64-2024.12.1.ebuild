# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Accurate N64 Emulator"
HOMEPAGE="https://simple64.github.io/ https://github.com/simple64/simple64"

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	REV="b49e10e5a90aa74ff3d0871d38cf2840ed3effe7"
fi
SRC_URI="${SRC_URI}
		https://raw.githubusercontent.com/simple64/cheat-parser/main/cheats.json -> ${P}-cheats.json"

LICENSE="GPL-3"
SLOT="0"

DEPEND="dev-libs/hidapi
		dev-util/vulkan-headers
		dev-qt/qtbase:6[dbus,gui,network,widgets]
		dev-qt/qtwebsockets:6
		media-libs/libglvnd
		media-libs/libpng
		media-libs/libsdl2
		media-libs/sdl2-net
		sys-libs/zlib
		x11-libs/libxkbcommon"

MODULES="mupen64plus-core
		simple64-input-raphnetraw
		simple64-input-qt
		simple64-audio-sdl2
		simple64-gui
		parallel-rsp
		parallel-rdp-standalone"

src_prepare() {
	for MODULE in $MODULES; do
		CMAKE_USE_DIR="${S}/${MODULE}"
		BUILD_DIR="${CMAKE_USE_DIR}_build"
		cmake_src_prepare
	done
	echo "#define GUI_VERSION \"${REV}\"" >"${S}/simple64-gui/version.h"
	cp "${DISTDIR}/${P}-cheats.json" "${S}/cheats.json"
}

src_configure() {
	for MODULE in $MODULES; do
		CMAKE_USE_DIR="${S}/${MODULE}"
		BUILD_DIR="${CMAKE_USE_DIR}_build"
		cmake_src_configure
	done
}

src_compile() {
	for MODULE in $MODULES; do
		CMAKE_USE_DIR="${S}/${MODULE}"
		BUILD_DIR="${CMAKE_USE_DIR}_build"
		cmake_src_compile
	done
}

src_install() {
	dobin "${S}/simple64-gui_build/simple64-gui"
	insinto "/usr/share/${PN}"
	doins "${S}/cheats.json"
	doins "${S}/mupen64plus-core/data/mupen64plus.ini"
	doins "${S}/mupen64plus-core/data/pif.ntsc.rom"
	doins "${S}/mupen64plus-core/data/pif.pal.rom"
	dolib.so "${S}/mupen64plus-core_build/libmupen64plus.so"
	dolib.so "${S}/simple64-input-raphnetraw_build/simple64-input-raphnetraw.so"
	dolib.so "${S}/simple64-input-qt_build/simple64-input-qt.so"
	dolib.so "${S}/simple64-audio-sdl2_build/simple64-audio-sdl2.so"
	dolib.so "${S}/parallel-rsp_build/simple64-rsp-parallel.so"
	dolib.so "${S}/parallel-rdp-standalone_build/simple64-video-parallel.so"
}
