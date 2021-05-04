# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils linux-info linux-mod

DESCRIPTION="Official Linux Client for DroidCam"
HOMEPAGE="https://www.dev47apps.com/${PN}"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dev47apps/${PN}.git"
else
	SRC_URI="https://github.com/dev47apps/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="X modules"

RDEPEND=">=app-pda/libplist-2
	>=app-pda/libusbmuxd-2
	dev-util/android-tools
	media-libs/alsa-lib
	>=media-libs/libjpeg-turbo-2
	media-libs/speex
	media-video/ffmpeg
	X? ( dev-libs/libappindicator:3
	     x11-libs/gtk+:3 )
	!modules? ( media-video/v4l2loopback )"
DEPEND="${RDEPEND}"

CONFIG_CHECK="SND_ALOOP VIDEO_V4L2"
MODULE_NAMES="v4l2loopback-dc(video:${S}/v4l2loopback)"
BUILD_TARGETS="clean all"

pkg_setup() {

	if use modules; then
		MN="v4l2loopback_dc"
		linux-mod_pkg_setup
	fi

}

src_prepare() {

	default

	sed -i -e "s:JPEG  = -I\$(JPEG_INCLUDE) \$(JPEG_LIB)/libturbojpeg.a:JPEG  = \`pkg-config --libs --cflags libturbojpeg\`:" \
		"${S}/Makefile"
	sed -i -e "s:USBMUXD = -lusbmuxd:USBMUXD = \`pkg-config --libs libusbmuxd-2.0\`:" \
		"${S}/Makefile"

	if use modules; then
		echo "${MN}" > "${S}/modules-load.d-${PN}.conf"
		echo "options ${MN} width=640 height=480" > "${S}/modprobe.d-${PN}.conf"
	fi

}

src_compile() {

	use modules && KERNELRELEASE="${KV_FULL}" linux-mod_src_compile

	default

}

src_install() {

	if use modules; then
		linux-mod_src_install

		insinto /etc/modules-load.d
		newins "${S}/modules-load.d-${PN}.conf" ${PN}.conf
		insinto /etc/modprobe.d
		newins "${S}/modprobe.d-${PN}.conf" ${PN}.conf
	fi

	einstalldocs

	dobin ${PN}-cli

	if use X; then
		dobin ${PN}

		newicon -s 32 icon.png ${P}.png
		newicon -s 96 icon2.png ${P}.png
		make_desktop_entry ${PN} "DroidCam" ${P} "AudioVideo;"
	fi

}

pkg_preinst() {

	use modules && linux-mod_pkg_preinst

}

pkg_postinst() {

	use modules && linux-mod_pkg_postinst

	if use X; then
		xdg_icon_cache_update
		xdg_mimeinfo_database_update
		xdg_desktop_database_update
	fi

	elog "Use 'pacmd load-module module-alsa-source device=hw:Loopback,1,0'"
	elog "to use sound with PulseAudio while DroidCam is running."

}

pkg_postrm() {

	use modules && linux-mod_pkg_postrm

	if use X; then
		xdg_icon_cache_update
		xdg_mimeinfo_database_update
		xdg_desktop_database_update
	fi

}
