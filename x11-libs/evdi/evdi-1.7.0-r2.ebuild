# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3 multilib linux-info linux-mod

DESCRIPTION="Extensible Virtual Display Interface"
HOMEPAGE="https://github.com/DisplayLink/${PN}"
SRC_URI="https://github.com/DisplayLink/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	x11-libs/libdrm"

MODULE_NAMES="evdi(video:${S}/module)"

CONFIG_CHECK="~DRM ~DRM_KMS_HELPER"

pkg_setup() {
	linux-mod_pkg_setup
	kernel_is -ge 4 15 || die "Update your kernel to at least version 4.15."
}

src_prepare() {
	default
	sed -i -e "s:PREFIX ?= /usr/local:PREFIX ?= ${EPREFIX}/usr:" "${S}/library/Makefile"
	sed -i -e "s:LIBDIR ?= \$(PREFIX)/lib:LIBDIR ?= \$(PREFIX)/$(get_libdir):" "${S}/library/Makefile"
}

src_configure(){
	return
}

src_compile() {
	linux-mod_src_compile

	cat > "${S}/modprobe.d-evdi.conf" <<EOF
options evdi initial_device_count=4
EOF

	cd "${S}/library"
	default
	cd -
}

src_install() {
	linux-mod_src_install

	insinto /etc/modprobe.d
	newins "${S}/modprobe.d-evdi.conf" evdi.conf

	cd "${S}/library"
	default
	cd -
}

pkg_preinst() {
	linux-mod_pkg_preinst
}

pkg_postinst() {
	linux-mod_pkg_postinst
}

pkg_postrm() {
	linux-mod_pkg_postrm
}
