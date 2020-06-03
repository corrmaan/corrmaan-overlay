# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod

MY_PN="evdi"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Extensible Virtual Display Interface Module"
HOMEPAGE="https://github.com/DisplayLink/${MY_PN}"
SRC_URI="https://github.com/DisplayLink/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-kernel/linux-headers"

S="${WORKDIR}/${MY_P}"

MODULE_NAMES="evdi(video:${S}/module)"

CONFIG_CHECK="~DRM ~DRM_KMS_HELPER"

pkg_setup() {
	linux-mod_pkg_setup
	kernel_is -ge 4 15 || die "Update your kernel to at least version 4.15."
}

src_compile() {
	linux-mod_src_compile

	cat > "${S}/modules-load.d-evdi.conf" <<EOF
evdi
EOF
	cat > "${S}/modprobe.d-evdi.conf" <<EOF
options evdi initial_device_count=4 initial_loglevel=6
EOF
}

src_install() {
	linux-mod_src_install

	insinto /etc/modprobe.d
	newins "${S}/modprobe.d-evdi.conf" evdi.conf
	insinto /etc/modules-load.d
	newins "${S}/modules-load.d-evdi.conf" evdi.conf
}

pkg_preinst() {
	linux-mod_pkg_preinst
}

pkg_postinst() {
	linux-mod_pkg_preinst
}

pkg_postrm() {
	linux-mod_pkg_postrm
}
