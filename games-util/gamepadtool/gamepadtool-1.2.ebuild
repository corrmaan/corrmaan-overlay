# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker desktop xdg-utils

DESCRIPTION="Simple GUI tool to create/modify gamepad mappings for games that use SDL2"
HOMEPAGE="http://www.generalarcade.com/${PN}/"

SRC_URI="amd64? ( http://www.generalarcade.com/${PN}/linux/${PN}_${PV}_amd64.deb )
	 x86? ( http://www.generalarcade.com/${PN}/linux/${PN}_${PV}_i386.deb )"

LICENSE="freedist"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="media-libs/libsdl2
	media-libs/mesa
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtcore:5"

MY_PN="gamepad-tool"

S="${WORKDIR}"

DOCS=( "${S}/usr/share/doc/${PN}/changelog" )

src_unpack() {

	unpack_deb ${A}
	cd "${S}/usr/share/doc/${PN}"
	gunzip changelog.gz
	cd -

}

src_install() {

	dobin "${S}/usr/bin/${MY_PN}"

	newicon -s 256x256 "${S}/usr/share/icons/hicolor/${MY_PN}.png" ${MY_PN}.png
	make_desktop_entry ${MY_PN} "Gamepad Tool" ${MY_PN} "Utility"

	einstalldocs

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
