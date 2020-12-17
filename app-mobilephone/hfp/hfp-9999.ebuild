# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic linux-info git-r3

DESCRIPTION="A Bluetooth Hands-Free Profile server."
HOMEPAGE="http://nohands.sourceforge.net"
SRC_URI=""
EGIT_REPO_URI="https://github.com/heinervdm/nohands.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa audiofile dbus speex"

DEPEND="dbus? ( dev-libs/dbus-glib )
	alsa? ( media-libs/alsa-lib )
	speex? ( media-libs/speex )"
RDEPEND="${DEPEND}
	net-wireless/bluez
	audiofile? ( media-libs/audiofile )"

CONFIG_CHECK="~BT ~BT_RFCOMM"

src_prepare() {
	default
	eautoreconf
}

pkg_setup() {
	linux-info_pkg_setup
}

src_configure() {
#    append-ldflags $(no-as-needed)
	econf \
		--disable-nghost \
		--disable-oss \
		--without-x \
		$(use_enable alsa) \
		$(use_enable audiofile) \
		$(use_enable dbus) \
		$(use_enable dbus dbus-service)
}
