# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fortran-2

MY_PN="H2OI95"

DESCRIPTION="A code for evaluating the IAPWS-95 equation-of-state model for water"
HOMEPAGE="https://github.com/corrmaan/${MY_PN}"
SRC_URI="https://github.com/corrmaan/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	use doc && dodoc "doc/${MY_PN}_v${PV} Report.pdf"
}
