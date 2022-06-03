# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="Redirects the standard usbmuxd socket to usbmuxd instances."
HOMEPAGE="https://github.com/corellium/${PN}"
LICENSE="GPL-2 GPL-3"
SLOT="0"

EGIT_REPO_URI="https://github.com/corellium/${PN}.git"
KEYWORDS="~amd64"
IUSE="+avahi"

BDEPEND="avahi? ( net-dns/avahi )
	>=app-pda/libplist-2.2"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --with-static-libplist=no
}
