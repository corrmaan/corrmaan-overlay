# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod xorg-3 multilib

DESCRIPTION="Extensible Virtual Display Interface"
HOMEPAGE="https://github.com/DisplayLink/evdi"
SRC_URI="https://github.com/DisplayLink/evdi/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/libdrm"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers"

MODULE_NAMES="evdi(kernel/drivers/gpu/drm/evdi:${S}/module)"

CONFIG_CHECK="~DRM ~DRM_KMS_HELPER"

pkg_setup() {
	linux-mod_pkg_setup
	kernel_is -ge 4 15 || die "Update your kernel to at least version 4.15."
}

src_configure() {
	return
}

src_compile() {
	linux-mod_src_compile
	cd "${S}/library"
	export LIBDIR=/usr/$(get_libdir)
	default
	cd -
}

src_install() {
	linux-mod_src_install
	cd "${S}/library"
	default
	cd -
}
