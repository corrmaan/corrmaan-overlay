# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FN_S="ls-dyna_smp_s_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_redhat65_ifort160"
FN_D="ls-dyna_smp_d_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_redhat65_ifort160"

DESCRIPTION="A general-purpose finite element program"
SRC_URI="
	!usermat-only? (
		single-precision? ( http://ftp.lstc.com/user/ls-dyna/R${PV}/linux.64/${FN_S}.gz )
		double-precision? ( http://ftp.lstc.com/user/ls-dyna/R${PV}/linux.64/${FN_D}.gz )
	)
	usermat? (
		single-precision? ( http://ftp.lstc.com/objects/ls-dyna/R${PV}/${FN_S}.tgz )
		double-precision? ( http://ftp.lstc.com/objects/ls-dyna/R${PV}/${FN_D}.tgz )
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

src_install() {
	into /opt/

	if ! use usermat-only; then
		use single-precision && dobin "${FN_S}"
		use double-precision && dobin "${FN_D}"
		if use usermat; then
			doheader -r usermat
		fi
	else
		doheader -r usermat
	fi
}
