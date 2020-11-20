# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

MY_PN="${PN/-bin}"

DESCRIPTION="Free/Libre Open Source Software Binaries of VSCode"
HOMEPAGE="https://vscodium.com"

SRC_URI="
	amd64? ( https://github.com/VSCodium/${MY_PN}/releases/download/${PV}/VSCodium-linux-x64-${PV}.tar.gz )
	arm? ( https://github.com/VSCodium/${MY_PN}/releases/download/${PV}/VSCodium-linux-armhf-${PV}.tar.gz )
	arm64? ( https://github.com/VSCodium/${MY_PN}/releases/download/${PV}/VSCodium-linux-arm64-${PV}.tar.gz )"

RESTRICT="mirror strip bindist"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64"

DEPEND="
	>=media-libs/libpng-1.2.46
	>=x11-libs/gtk+-2.24.8-r1:2
	x11-libs/cairo
	x11-libs/libXtst
	!app-editors/vscodium"

RDEPEND="
	${DEPEND}
	app-accessibility/at-spi2-atk
	>=net-print/cups-2.0.0
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	dev-libs/nss
	app-crypt/libsecret[crypt]"

INSTDIR="opt/${MY_PN}"

src_unpack(){

	mkdir -pv "${S}"
	cd "${S}"
	
	default

}

src_install(){

	insinto /${INSTDIR}
	cp -av "${S}/." "${ED}/${INSTDIR}/"

	dosym "${EPREFIX}/${INSTDIR}/bin/codium" "/opt/bin/codium"

	newicon "${S}/resources/app/resources/linux/code.png" "${MY_PN}".png
	make_desktop_entry "${EPREFIX}/${INSTDIR}/bin/codium --unity-launch" "VSCodium" "${MY_PN}" "Utility;Development;IDE;"

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
