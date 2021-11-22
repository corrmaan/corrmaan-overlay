# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

BUILDDATE=15Nov2021

DESCRIPTION="Advanced Pre- and Post-Processor for LS-DYNA"
SRC_URI="http://ftp.lstc.com/user/ls-prepost/$(ver_cut 1).$(ver_cut 2)/linux64/${P}-common-${BUILDDATE}.tgz"
HOMEPAGE="http://www.lstc.com/"

LICENSE="LSPREPOST"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""
REQUIRED_USE=""

RDEPEND=""
DEPEND=""

RESTRICT="fetch"

S=${WORKDIR}/${PN}$(ver_cut 1).$(ver_cut 2)_common

INSTDIR="opt/lsprepost"

HTML_DOCS="resource/HelpDocument/."

QA_PRESTRIPPED="${INSTDIR}/lib/libavformat.so.58.29.100
	${INSTDIR}/lib/libtiff.so.3.8.2
	${INSTDIR}/lib/libftgl.so.2.1.3
	${INSTDIR}/lib/libavdevice.so.57.0.101
	${INSTDIR}/lib/libpng12.so.0.10.0
	${INSTDIR}/lib/libswscale.so.5.5.100
	${INSTDIR}/lib/libjpeg.so.62.0.0
	${INSTDIR}/lib/libLSVI653.so.0.0.0
	${INSTDIR}/lib/libavcodec.so.58.54.100
	${INSTDIR}/lib/libswresample.so.3.5.100
	${INSTDIR}/lib/libexpat.so.0.5.0
	${INSTDIR}/lib/libavutil.so.56.31.100
	${INSTDIR}/lib/libx264.so.160
	${INSTDIR}/lib/libavfilter.so.6.47.100
	${INSTDIR}/lib/libGLEW.so.2.0.0
	${INSTDIR}/lib/libLSIO653.so.0.0.0
	${INSTDIR}/lib/libLSMA653.so.0.0.0
	${INSTDIR}/lib/libintlc.so.5
	${INSTDIR}/lsrun"

src_prepare() {

	default

cat <<EOT > lspp$(ver_cut 1)$(ver_cut 2)
#!/usr/bin/env bash
export LD_LIBRARY_PATH=${EPREFIX}/${INSTDIR}/lib:\$LD_LIBRARY_PATH
${EPREFIX}/${INSTDIR}/lsprepost \$*
EOT

}

src_install() {

	default

	insinto /${INSTDIR}
	insopts -m0755
	doins lsdyna_bestfit lspp$(ver_cut 1)$(ver_cut 2) lsprepost lsrun msuite_ls_64 tetgen
	doins -r lib
	insopts -m0644
	doins -r BaoSteel lspp_forming_48 lspp_matlib material.xml

	make_desktop_entry "${EPREFIX}/${INSTDIR}/lspp$(ver_cut 1)$(ver_cut 2)" "LS-PrePost V${PV}" ${PN} "Science;Physics"

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
