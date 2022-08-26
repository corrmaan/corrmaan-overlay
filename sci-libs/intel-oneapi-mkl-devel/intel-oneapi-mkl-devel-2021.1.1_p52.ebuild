# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

MY_PV=$(ver_cut 1-3)

DESCRIPTION="Intel oneAPI Math Kernel Library development package"
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
	>=sci-libs/intel-oneapi-mkl-${MY_PV}
	>=sci-libs/intel-oneapi-mkl-common-devel-${MY_PV}
"

S="${WORKDIR}"

src_unpack() {
	default
	if [[ -n ${A} ]]; then
		rpm_unpack ${A}
	fi
}

src_prepare() {
	default
	ln -s ${MY_PV} opt/intel/oneapi/mkl/latest
}

src_install() {
	cp -a opt "${ED}/"
}
