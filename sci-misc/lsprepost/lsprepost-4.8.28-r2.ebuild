# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

MY_PV="$(ver_cut 1).$(ver_cut 2)"
MY_PV1="$(ver_cut 1)$(ver_cut 2)"
BUILDDATE=07Mar2022

DESCRIPTION="Advanced Pre- and Post-Processor for LS-DYNA"
SRC_URI="https://ftp.lstc.com/anonymous/outgoing/${PN}/${MY_PV}/linux64/${P}-common-${BUILDDATE}.tgz
	doc? ( https://ftp.lstc.com/anonymous/outgoing/${PN}/${MY_PV}/doc/linux/Document.zip -> ${PN}-${MY_PV}-Document.zip
		https://ftp.lstc.com/anonymous/outgoing/${PN}/${MY_PV}/doc/linux/Tutor.zip -> ${PN}-${MY_PV}-Tutor.zip )"
HOMEPAGE="http://www.lstc.com/"

LICENSE="LSPREPOST"
KEYWORDS="~amd64"
SLOT="${MY_PV}"
IUSE="doc"
REQUIRED_USE=""

RDEPEND=""
DEPEND=""

S=${WORKDIR}/${PN}${MY_PV}_common

INSTDIR="opt/${PN}-${MY_PV}"

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

src_unpack() {

	unpack ${P}-common-${BUILDDATE}.tgz

}

src_prepare() {

	default

	mv "${DISTDIR}/${PN}-${MY_PV}-Document.zip" "${DISTDIR}/Document.zip"
	mv "${DISTDIR}/${PN}-${MY_PV}-Tutor.zip" "${DISTDIR}/Tutor.zip"

cat <<EOT > lspp${MY_PV1}
#!/usr/bin/env bash
export LSPP_HELPDIR=${EPREFIX}/${INSTDIR}/resource/HelpDocument
export LD_LIBRARY_PATH=${EPREFIX}/${INSTDIR}/lib:\$LD_LIBRARY_PATH
${EPREFIX}/${INSTDIR}/${PN} \$*
EOT

}

src_install() {

	default

	insinto /${INSTDIR}
	insopts -m0755
	doins lsdyna_bestfit lspp${MY_PV1} ${PN} lsrun msuite_ls_64 tetgen
	doins -r lib
	insopts -m0644
	doins -r BaoSteel lspp_forming_${MY_PV1} lspp_matlib material.xml

	if use doc; then
		doins -r resource
		insinto /${INSTDIR}/resource/HelpDocument
		doins "${DISTDIR}/Document.zip" "${DISTDIR}/Tutor.zip"
	fi

	make_desktop_entry "${EPREFIX}/${INSTDIR}/lspp${MY_PV1}" "LS-PrePost V${PV}" ${PN} "Science;Physics"

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
