# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg-utils

MY_PV="$(ver_cut 1).$(ver_cut 2)"
MY_PV1="$(ver_cut 1)$(ver_cut 2)"
BUILDDATE=01Oct2024

DESCRIPTION="Advanced Pre- and Post-Processor for LS-DYNA"
HOMEPAGE="http://www.lstc.com/"
SRC_URI="https://ftp.lstc.com/anonymous/outgoing/${PN}/${MY_PV}/linux64/${P}-common-${BUILDDATE}.tgz"

S=${WORKDIR}/${PN}${MY_PV}_common

LICENSE="LSPREPOST"
SLOT="${MY_PV}"
KEYWORDS="~amd64"

BDEPEND="media-gfx/icoutils"
RDEPEND="app-accessibility/at-spi2-core
		app-arch/bzip2
		app-arch/xz-utils
		app-crypt/libsecret
		app-crypt/p11-kit
		dev-libs/expat
		dev-libs/fribidi
		dev-libs/glib
		dev-libs/gmp
		dev-libs/icu
		dev-libs/libffi
		dev-libs/libgcrypt
		dev-libs/libgpg-error
		dev-libs/libpcre2
		dev-libs/libtasn1
		dev-libs/libunistring
		dev-libs/libxml2
		dev-libs/openssl
		media-gfx/graphite2
		media-libs/fontconfig
		media-libs/freetype
		media-libs/glu
		media-libs/harfbuzz
		media-libs/libepoxy
		media-libs/libglvnd
		media-libs/libogg
		media-libs/libpng
		media-libs/libtheora
		media-libs/libvorbis
		media-libs/openjpeg
		net-dns/c-ares
		net-dns/libidn2
		net-libs/libpsl
		net-libs/nghttp2
		net-misc/curl
		sys-apps/dbus
		sys-apps/util-linux
		virtual/libcrypt
		x11-libs/cairo
		x11-libs/gdk-pixbuf
		x11-libs/gtk+
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXcomposite
		x11-libs/libXcursor
		x11-libs/libXdamage
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/libXmu
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXt
		x11-libs/libXtst
		x11-libs/libXxf86vm
		x11-libs/libdrm
		x11-libs/libnotify
		x11-libs/libxcb
		x11-libs/libxkbcommon
		x11-libs/pango
		x11-libs/pixman"
RESTRICT="strip"

INSTDIR="opt/${PN}-${MY_PV}"

src_prepare() {

	default

cat <<EOT > lspp${MY_PV1}
#!/usr/bin/env bash
export LSPP_HELPDIR=${EPREFIX}/${INSTDIR}/resource/HelpDocument
export LD_LIBRARY_PATH=${EPREFIX}/${INSTDIR}/lib:\$LD_LIBRARY_PATH
export GDK_BACKEND=x11
${EPREFIX}/${INSTDIR}/${PN} \$*
EOT

	rm README.txt

}

src_install() {

	default

	insinto /${INSTDIR}
	insopts -m0755
	doins lsdyna_bestfit lspp${MY_PV1} ${PN} lsrun msuite_ls_64 surfgen tetgen
	doins -r lib
	insopts -m0644
	doins -r BaoSteel lspp_forming_temp lspp_matlib material.xml resource templates

	icotool -x -o . "${FILESDIR}/${PN}.ico"
	local i
	local j=1
	for i in 16 24 32 48 64 72 96 128 256; do
		newicon -s ${i} "${PN}_${j}_${i}x${i}x8.png" ${PN}.png
		j=$((j+1))
	done

	make_desktop_entry "${EPREFIX}/${INSTDIR}/lspp${MY_PV1}" "LS-PrePost V${PV}" ${PN} "Science;Physics" \
		"StartupWMClass=Lsprepost"

}

pkg_postinst() {

	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update

}

pkg_postrm() {

	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update

}
