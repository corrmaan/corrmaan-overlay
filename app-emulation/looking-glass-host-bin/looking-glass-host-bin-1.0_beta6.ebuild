# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A low latency KVMFR implementation for guests with VGA PCI Passthrough"
HOMEPAGE="https://looking-glass.io/"

MY_PN="looking-glass-host"
if [ ! -z $(ver_cut 4) ]; then
	if [ ! -z $(ver_cut 6) ]; then
		MY_PV="B$(ver_cut 4)-rc$(ver_cut 6)"
	else
		MY_PV="B$(ver_cut 4)"
	fi
else
	MY_PV="${PV}"
fi
SRC_URI="https://looking-glass.io/artifact/${MY_PV}/host -> ${MY_PN}-${MY_PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

BDEPEND="app-arch/unzip
		 app-cdr/cdrtools"

S="${WORKDIR}"

src_unpack() {
	mkdir "${MY_PN}"
	unzip -d "${MY_PN}" "${DISTDIR}/${MY_PN}-${MY_PV}.zip"
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
