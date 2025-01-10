# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg-utils

MY_PV="$(ver_cut 1).$(ver_cut 2)"
MY_PV1="$(ver_cut 1)$(ver_cut 2)"
BUILDDATE=01Oct2024

DESCRIPTION="Advanced Pre- and Post-Processor for LS-DYNA"
HOMEPAGE="http://www.lstc.com/"
SRC_URI="https://ftp.lstc.com/anonymous/outgoing/${PN}/${MY_PV}/linux64/${P}-common_dp-${BUILDDATE}.tgz"

S=${WORKDIR}/${PN}${MY_PV}_common_dp

LICENSE="LSPREPOST"
SLOT="${MY_PV}"
KEYWORDS="~amd64"

RDEPEND="media-libs/speex
	virtual/libcrypt"
RESTRICT="strip"

INSTDIR="opt/${PN}-${MY_PV}"

src_unpack() {

	unpack ${P}-common_dp-${BUILDDATE}.tgz

}

src_prepare() {

	default

cat <<EOT > lspp${MY_PV1}
#!/usr/bin/env bash
export LSPP_HELPDIR=${EPREFIX}/${INSTDIR}/resource/HelpDocument
export LD_LIBRARY_PATH=${EPREFIX}/${INSTDIR}/lib:\$LD_LIBRARY_PATH
${EPREFIX}/${INSTDIR}/${PN}_dp \$*
EOT

}

src_install() {

	default

	insinto /${INSTDIR}
	insopts -m0755
	doins lsdyna_bestfit lspp${MY_PV1}_dp ${PN}_dp lsrun msuite_ls_64 surfgen tetgen
	doins -r lib
	insopts -m0644
	doins -r BaoSteel lspp_forming_temp lspp_matlib material.xml resource templates

	make_desktop_entry "${EPREFIX}/${INSTDIR}/lspp${MY_PV1}" "LS-PrePost V${PV}" ${PN} "Science;Physics" \
		"StartupWMClass=Lsprepost2"

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
