# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg-utils

MY_PV="$(ver_cut 1).$(ver_cut 2)"
MY_PV1="$(ver_cut 1)$(ver_cut 2)"
BUILDDATE=26Sep2023

DESCRIPTION="Advanced Pre- and Post-Processor for LS-DYNA"
SRC_URI="https://ftp.lstc.com/anonymous/outgoing/${PN}/${MY_PV}/linux64/${P}-common_gtk3-${BUILDDATE}.tgz
	doc? ( https://ftp.lstc.com/anonymous/outgoing/${PN}/${MY_PV}/doc/linux/Document.zip -> ${PN}-${MY_PV}-Document.zip
		https://ftp.lstc.com/anonymous/outgoing/${PN}/${MY_PV}/doc/linux/Tutor.zip -> ${PN}-${MY_PV}-Tutor.zip )"
HOMEPAGE="http://www.lstc.com/"

LICENSE="LSPREPOST"
KEYWORDS="~amd64"
SLOT="${MY_PV}"
IUSE="doc"
REQUIRED_USE=""
RESTRICT="strip"

RDEPEND="media-libs/speex"
DEPEND=""
BDEPEND="doc? ( app-arch/unzip )"

S=${WORKDIR}/${PN}${MY_PV}_common_gtk3

INSTDIR="opt/${PN}-${MY_PV}"

src_unpack() {

	unpack ${P}-common_gtk3-${BUILDDATE}.tgz

}

src_prepare() {

	default

	cp "${DISTDIR}/${PN}-${MY_PV}-Document.zip" Document.zip
	cp "${DISTDIR}/${PN}-${MY_PV}-Tutor.zip" Tutor.zip

cat <<EOT > lspp${MY_PV1}
#!/usr/bin/env bash
export LSPP_HELPDIR=${EPREFIX}/${INSTDIR}/resource/HelpDocument
export LD_LIBRARY_PATH=${EPREFIX}/${INSTDIR}/lib2:\$LD_LIBRARY_PATH
${EPREFIX}/${INSTDIR}/${PN}2 \$*
EOT

}

src_install() {

	default

	insinto /${INSTDIR}
	insopts -m0755
	doins lsdyna_bestfit lspp${MY_PV1} ${PN}2 lsrun msuite_ls_64 surfgen tetgen
	doins -r lib2
	insopts -m0644
	doins -r BaoSteel lspp_forming_${MY_PV1} lspp_matlib material.xml

	if use doc; then
		doins -r resource
		insinto /${INSTDIR}/resource/HelpDocument
		doins Document.zip Tutor.zip
	fi

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
