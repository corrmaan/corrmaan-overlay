# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FN_S="ls-dyna_smp_s_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos610_ifort190"
FN_D="ls-dyna_smp_d_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos610_ifort190"
SH="tgz_extractor.sh"

DESCRIPTION="A general-purpose finite element program"
SRC_URI="single-precision? ( http://ftp.lstc.com/user/ls-dyna/R${PV}/linx.64/${FN_S}.${SH} )
	double-precision? ( http://ftp.lstc.com/user/ls-dyna/R${PV}/linx.64/${FN_D}.${SH} )
	usermat-single-precision? ( http://ftp.lstc.com/objects/ls-dyna/R${PV}/${FN_S}.usermat.${SH} )
	usermat-double-precision? ( http://ftp.lstc.com/objects/ls-dyna/R${PV}/${FN_D}.usermat.${SH} )"
HOMEPAGE="http://www.lstc.com/"

LICENSE="Clickwrap-SLA"
KEYWORDS="~amd64"
SLOT="${PV}"
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
		sh "${DISTDIR}"/"${FN_S}.${SH}" --skip-license --exclude-subdir
	fi
	if use double-precision; then
		sh "${DISTDIR}"/"${FN_D}.${SH}" --skip-license --exclude-subdir
	fi
	if use usermat-single-precision; then
		sh "${DISTDIR}"/"${FN_S}.usermat.${SH}" --skip-license --exclude-subdir
		rm -rf usermat/licensingclient
		mkdir ${PN}
		mv usermat ${PN}/${PV}
	fi
	if use usermat-double-precision; then
		sh "${DISTDIR}"/"${FN_D}.usermat.${SH}" --skip-license --exclude-subdir
		rm -rf usermat/licensingclient
		mkdir ${PN}
		mv usermat ${PN}/${PV}
	fi
	rm -rf licensingclient/winx64

}

src_install() {

	insinto /opt/${PN}/${PV}
	use single-precision || use double-precision && doins -r licensingclient

	exeinto /opt/${PN}/${PV}
	use single-precision && doexe "${FN_S}"
	use double-precision && doexe "${FN_D}"

	use usermat-single-precision || use usermat-double-precision && doheader -r ${PN}

}
