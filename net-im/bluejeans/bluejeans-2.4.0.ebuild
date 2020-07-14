# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm desktop xdg-utils

DESCRIPTION="Online meetings, video conferencing, and screen sharing for teams of any size"
HOMEPAGE="https://www.bluejeans.com"
SRC_URI="https://swdl.bluejeans.com/desktop-app/linux/${PV}/BlueJeans.rpm -> ${P}.rpm"

LICENSE="BlueJeans"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}"

INSTDIR="opt/BlueJeans"

QA_WX_LOAD="${INSTDIR}/resources/app.asar.unpacked/node_modules/fiber-wrapper-node/dependencies/build/fiberclient/lib/libfiber.so.2.0.0"

QA_PRESTRIPPED="${INSTDIR}/bluejeans-v2
	${INSTDIR}/libEGL.so
	${INSTDIR}/libGLESv2.so
	${INSTDIR}/libffmpeg.so
	${INSTDIR}/resources/app.asar.unpacked/node_modules/fiber-wrapper-node/dependencies/build/fiberclient/lib/libdvclient.so
	${INSTDIR}/resources/app.asar.unpacked/node_modules/fiber-wrapper-node/dependencies/build/fiberclient/lib/libfiber.so.2.0.0"

src_unpack() {

	rpm_src_unpack ${A}

}

src_install() {

	cp -R "${S}/opt" "${ED}/" || die

#	fperms +x /${INSTDIR}/${PN}-v$(ver_cut 1)

	for i in 16 24 32 48 64 96 128 256 512; do
		newicon -s ${i} \
			"usr/share/icons/hicolor/${i}x${i}/apps/${PN}-v$(ver_cut 1).png" \
			${P}.png
	done

#	domenu usr/share/applications/${PN}-v$(ver_cut 1).desktop
	make_desktop_entry "${EPREFIX}/${INSTDIR}/${PN}-v$(ver_cut 1) %U" "BlueJeans" ${P} "AudioVideo;"

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
