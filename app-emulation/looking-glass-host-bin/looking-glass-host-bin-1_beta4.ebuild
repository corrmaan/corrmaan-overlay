# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="looking-glass-host"
MY_PV="${PV//1_beta/B}"

DESCRIPTION="A low latency KVMFR implementation for guests with VGA PCI Passthrough"
HOMEPAGE="https://looking-glass.io/"

SRC_URI="https://looking-glass.io/ci/host/download?id=715 -> ${PN}-${MY_PV}.zip"

if [[ ${PV} != "9999" ]]; then
	EGIT_COMMIT="25c88a1c6ca77c2db5f1fcef3458e3083b7bfaa7"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-cdr/cdrtools"

S="${WORKDIR}"

src_unpack() {
	mkdir "${MY_PN}"
	unzip -P "${EGIT_COMMIT:0:8}" -d "${MY_PN}" "${DISTDIR}/${PN}-${MY_PV}.zip"
}

src_prepare() {
	default
	mkisofs -lJR -iso-level 4 -o "${MY_PN}-${MY_PV}.iso" "${MY_PN}"
}

src_install() {
	insinto /usr/share/drivers/windows
	doins "${MY_PN}-${MY_PV}.iso"
	dosym "${MY_PN}-${MY_PV}.iso" "/usr/share/drivers/windows/${MY_PN}.iso"
}
