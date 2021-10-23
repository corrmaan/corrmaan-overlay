# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FN_S="ls-dyna_smp_s_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_redhat65_ifort160"
FN_D="ls-dyna_smp_d_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_redhat65_ifort160"

DESCRIPTION="A general-purpose finite element program"
SRC_URI="single-precision? ( http://ftp.lstc.com/user/ls-dyna/R${PV}/linx.64/${FN_S}.gz )
	double-precision? ( http://ftp.lstc.com/user/ls-dyna/R${PV}/linx.64/${FN_D}.gz )
	usermat-single-precision? ( http://ftp.lstc.com/objects/ls-dyna/R${PV}/${FN_S}.tgz )
	usermat-double-precision? ( http://ftp.lstc.com/objects/ls-dyna/R${PV}/${FN_D}.tgz )"
HOMEPAGE="http://www.lstc.com/"

LICENSE="Clickwrap-SLA"
KEYWORDS="~amd64"
SLOT="0"
IUSE="single-precision +double-precision usermat-single-precision usermat-double-precision"
REQUIRED_USE="
	usermat-single-precision? ( !usermat-double-precision )
	usermat-double-precision? ( !usermat-single-precision )"

RDEPEND=""
DEPEND="${RDEPEND}"

RESTRICT="fetch"

S=${WORKDIR}

src_unpack() {

	if use single-precision; then
		unpack ${FN_S}.gz
	fi
	if use double-precision; then
		unpack ${FN_D}.gz
	fi
	if use usermat-single-precision; then
		unpack ${FN_S}.tgz
		mv usermat ${PN}
	fi
	if use usermat-double-precision; then
		unpack ${FN_D}.tgz
		mv usermat ${PN}
	fi

}

src_install() {

	exeinto /opt/${PN}
	use single-precision && doexe "${FN_S}"
	use double-precision && doexe "${FN_D}"

	use usermat-single-precision || use usermat-double-precision && doheader -r ${PN}

}
