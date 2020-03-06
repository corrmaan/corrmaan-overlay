# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A general-purpose finite element program"
SRC_URI="
	!usermat-only? (
		single-precision? ( http://ftp.lstc.com/user/ls-dyna/R${PV}/linux.64/ls-dyna_smp_s_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_redhat65_ifort160_sse2.gz )
		double-precision? ( http://ftp.lstc.com/user/ls-dyna/R${PV}/linux.64/ls-dyna_smp_d_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_redhat65_ifort160_sse2.gz )
	)
	usermat? (
		single-precision? ( http://ftp.lstc.com/objects/ls-dyna/R${PV}/ls-dyna_smp_s_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_redhat65_ifort160_sse2.tgz )
		double-precision? ( http://ftp.lstc.com/objects/ls-dyna/R${PV}/ls-dyna_smp_d_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_redhat65_ifort160_sse2.tgz )
	)"
HOMEPAGE="http://www.lstc.com/"

LICENSE="LSDYNA"
KEYWORDS="~amd64"
SLOT="0"
IUSE="single-precision +double-precision usermat usermat-only"
REQUIRED_USE="
	usermat-only? ( !usermat )
	!usermat-only? ( || ( single-precision double-precision ) )
	usermat? ( ^^ ( single-precision double-precision ) )"

RDEPEND=""
DEPEND="${RDEPEND}"

RESTRICT="fetch"

S=${WORKDIR}

pkg_nofetch() {
	einfo "Please obtain"
	einfo "- ${SRC_URI}"
}

src_install() {
	if ! use usermat-only; then
		use single-precision && dobin ls-dyna_smp_s_R11_1_0_x64_redhat65_ifort160_sse2
		use double-precision && dobin ls-dyna_smp_d_R11_1_0_x64_redhat65_ifort160_sse2
		if use usermat; then
			doheader -r usermat
		fi
	else
		doheader -r usermat
	fi
}


