# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

MY_PV=$(ver_cut 1-3)

DESCRIPTION="oneAPI Threading Building Blocks"
HOMEPAGE="https://www.intel.com/content/www/us/en/developer/tools/oneapi/components.html"
SRC_URI="
	https://yum.repos.intel.com/oneapi/${PN}-${MY_PV}-${MY_PV}-$(ver_cut 5).x86_64.rpm
"

LICENSE="Intel-EULA-DevTools"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror strip"

RDEPEND="
	>=sci-libs/intel-oneapi-common-vars-${MY_PV}
	>=sci-libs/intel-oneapi-common-licensing-${MY_PV}
	>=sci-libs/intel-oneapi-tbb-common-${MY_PV}
"

S="${WORKDIR}/opt"

src_unpack() {
	default
	if [[ -n ${A} ]]; then
		rpm_unpack ${A}
	fi
}

src_prepare() {
	default
	ln -s ${MY_PV} intel/oneapi/tbb/latest
}

src_install() {
	insinto /opt
	doins -r intel
}
