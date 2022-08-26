# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

MY_PV=$(ver_cut 1-3)

DESCRIPTION="oneAPI Threading Building Blocks"
HOMEPAGE="https://www.intel.com/content/www/us/en/developer/tools/oneapi/components.html"
SRC_URI="
	https://yum.repos.intel.com/oneapi/${PN}-${MY_PV}-${MY_PV}-$(ver_cut 5).noarch.rpm
"

LICENSE="Intel-EULA-DevTools"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"
RESTRICT="mirror strip"

RDEPEND="
	>=sci-libs/intel-oneapi-common-vars-${MY_PV}
	>=sci-libs/intel-oneapi-common-licensing-${MY_PV}
"

S="${WORKDIR}/opt"

src_unpack() {
	default
	if [[ -n ${A} ]]; then
		rpm_unpack ${A}
	fi
}

src_install() {
	insinto /opt
	doins -r intel
}
