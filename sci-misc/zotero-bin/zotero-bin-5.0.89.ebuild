# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

MY_PN="Zotero"
LNXARCH="linux-x86_64"

DESCRIPTION="A free, easy-to-use tool to help you collect, organize, cite, and share research"
HOMEPAGE="https://www.zotero.org/"
SRC_URI="https://www.zotero.org/download/client/dl?channel=release&platform=${LNXARCH}&version=${PV} -> ${P}.tar.bz2"

MY_P="${MY_PN}-${PV}"

S="${WORKDIR}/${MY_PN}_${LNXARCH}"

IUSE=""
LICENSE="AGPL-3"
KEYWORDS="~amd64"
SLOT="0"

DEPEND=""
RDEPEND=""

INSTDIR="opt/${PN}"

QA_PRESTRIPPED="${INSTDIR}/libmozavcodec.so
	${INSTDIR}/plugin-container
	${INSTDIR}/gtk2/libmozgtk.so
	${INSTDIR}/gmp-clearkey/0.1/libclearkey.so
	${INSTDIR}/libssl3.so
	${INSTDIR}/zotero-bin
	${INSTDIR}/libnssdbm3.so
	${INSTDIR}/liblgpllibs.so
	${INSTDIR}/libnspr4.so
	${INSTDIR}/libxul.so
	${INSTDIR}/libsoftokn3.so
	${INSTDIR}/libsmime3.so
	${INSTDIR}/libmozavutil.so
	${INSTDIR}/libnss3.so
	${INSTDIR}/libmozsqlite3.so
	${INSTDIR}/updater
	${INSTDIR}/libmozsandbox.so
	${INSTDIR}/libplc4.so
	${INSTDIR}/libnssckbi.so
	${INSTDIR}/libfreeblpriv3.so
	${INSTDIR}/libplds4.so
	${INSTDIR}/libnssutil3.so
	${INSTDIR}/libmozgtk.so
	${INSTDIR}/minidump-analyzer"

src_install() {

	dodir "/${INSTDIR}"
	cp -a "${S}/." "${ED}/${INSTDIR}" || die

	local i
	for i in 16 32 48 256; do
		newicon -s ${i} "${S}/chrome/icons/default/default${i}.png" ${P}.png
	done

	make_desktop_entry "${EPREFIX}/${INSTDIR}/zotero" "Zotero" ${P} "Science;"

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
