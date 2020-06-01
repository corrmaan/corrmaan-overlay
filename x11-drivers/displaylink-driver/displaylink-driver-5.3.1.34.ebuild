# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils systemd udev

DESCRIPTION="DisplayLink USB Graphics Software"
HOMEPAGE="http://www.displaylink.com/downloads/ubuntu"
SRC_URI="${P}.zip"

MY_PV=$(ver_cut 1-3)

LICENSE="DisplayLink-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"

QA_PREBUILT="/opt/displaylink/DisplayLinkManager"
RESTRICT="fetch"

DEPEND="app-admin/chrpath"
RDEPEND=">=sys-devel/gcc-5.1
	>=x11-drivers/evdi-1.7
	virtual/libusb:1
	>=x11-base/xorg-server-1.17.0"
#	!systemd? ( sys-power/pm-utils )"

pkg_nofetch() {
	einfo "Please download"
	einfo "- DisplayLink USB Graphics Software for Ubuntu ${MY_PV}.zip"
	einfo "from http://www.displaylink.com/downloads/ubuntu and rename it to"
	einfo "${P}.zip"
}

src_unpack() {
	default
	sh ./${P}.run --noexec --keep --target ${P}
}

src_configure() {
	default

	COREDIR=/opt/displaylink
	LOGSDIR=/var/log/displaylink
	MY_UBUNTU_VERSION=1604
	case "${ARCH}" in
		amd64)	MY_ARCH="x64" ;;
		*)		MY_ARCH="${ARCH}" ;;
	esac
	BINS="${S}/${MY_ARCH}-ubuntu-${MY_UBUNTU_VERSION}"
	DLM="${BINS}/DisplayLinkManager"
	chrpath -d "${DLM}"

	source udev-installer.sh
	create_bootstrap_file systemd udev.sh
	if ! use systemd; then
		sed -i 's/systemctl start displaylink-driver/rc-service dlm start/g' udev.sh
		sed -i 's/systemctl stop displaylink-driver/rc-service dlm stop/g' udev.sh
	else
		cp displaylink-installer.sh dlm.service
		sed -i '/#!\/bin\/bash/,/add_systemd_service()/d' dlm.service
		sed -i -e 1,2d dlm.service
		sed -i '/EOF/,$d' dlm.service
	fi
	create_udev_rules_file 99-displaylink.rules
}

src_install() {
	dodir "${COREDIR}"
	keepdir "${LOGSDIR}"

	exeinto "${COREDIR}"
	doexe "${DLM}"
	doexe udev.sh
	insinto "${COREDIR}"
	doins *.spkg

	udev_dorules 99-displaylink.rules

	if use systemd; then
##		use pm-utils && newins "${FILESDIR}/pm-systemd-displaylink" suspend.sh
##		use pm-utils && dosym /opt/displaylink/suspend.sh /lib/systemd/system-sleep/displaylink.sh
		systemd_dounit dlm.service
	else
##		use pm-utils && newins "${FILESDIR}/pm-displaylink" suspend.sh
##		use pm-utils && dosym /opt/displaylink/suspend.sh /etc/pm/sleep.d/displaylink.sh
		newinitd "${FILESDIR}/dlm" dlm
	fi
}

#pkg_postinst() {
#	einfo "The DisplayLinkManager Init is now called dlm"
#	einfo ""
#	einfo "You should be able to use xrandr as follows:"
#	einfo "xrandr --setprovideroutputsource 1 0"
#	einfo "Repeat for more screens, like:"
#	einfo "xrandr --setprovideroutputsource 2 0"
#	einfo "Then, you can use xrandr or GUI tools like arandr to configure the screens, e.g."
#	einfo "xrandr --output DVI-1-0 --auto"
#}
pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
