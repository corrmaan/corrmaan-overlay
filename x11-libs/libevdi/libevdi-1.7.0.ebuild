# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3 multilib

MY_PN="evdi"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Extensible Virtual Display Interface Library"
HOMEPAGE="https://github.com/DisplayLink/${MY_PN}"
SRC_URI="https://github.com/DisplayLink/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/libdrm
	 x11-libs/evdi-module"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"
S="${S}/library"

src_prepare() {
	default
	sed -i -e "s:PREFIX ?= /usr/local:PREFIX ?= /usr:" Makefile
	sed -i -e "s:LIBDIR ?= \$(PREFIX)/lib:LIBDIR ?= \$(PREFIX)/$(get_libdir):" Makefile
}

src_configure(){
	return
}
