# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

BUILDDATE=02Jul2020

DESCRIPTION="Advanced Pre- and Post-Processor for LS-DYNA"
SRC_URI="http://ftp.lstc.com/user/ls-prepost/$(ver_cut 1).$(ver_cut 2)/linux64/${P}-common-${BUILDDATE}.tgz"
HOMEPAGE="http://www.lstc.com/"

LICENSE="LSPREPOST"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""
REQUIRED_USE=""

RDEPEND=""
DEPEND="media-gfx/imagemagick"

RESTRICT="fetch"

S=${WORKDIR}/${PN}$(ver_cut 1).$(ver_cut 2)_common

INSTDIR="/opt/lsprepost"

pkg_nofetch() {
	einfo "Please obtain"
	einfo "- ${SRC_URI}"
}

src_prepare() {

	default

cat <<EOT > lspp$(ver_cut 1)$(ver_cut 2)
#!/bin/bash
export LD_LIBRARY_PATH=${INSTDIR}/lib:\$LD_LIBRARY_PATH
${INSTDIR}/lsprepost \$*
EOT

}

src_install() {

	insinto ${INSTDIR}
	insopts -m0755
	doins lspp$(ver_cut 1)$(ver_cut 2) lsprepost lsrun msuite_ls_64 tetgen
	doins -r lib
	insopts -m0644
	doins material.xml
	doins -r lspp_matlib
	doins -r resource

	local i
	for i in 16x16 24x24 32x32 48x48 128x128 256x256; do
		newicon -s ${i} "${FILESDIR}/${PN}-${i}.png" ${PN}.png
	done

	make_desktop_entry ${INSTDIR}/lspp$(ver_cut 1)$(ver_cut 2) "LS-PrePost V${PV}" ${PN} "Science;Physics"

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
