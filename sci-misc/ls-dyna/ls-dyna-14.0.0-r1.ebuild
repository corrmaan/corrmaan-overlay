# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FN_S="${PN}_smp_s_F$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos79_intel190"
FN_D="${PN}_smp_d_F$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos79_intel190"
SH="tgz_extractor.sh"

DESCRIPTION="A general-purpose finite element program"
SRC_URI="single-precision? ( http://ftp.lstc.com/user/${PN}/F${PV}/linx.64/${FN_S}.${SH} )
	double-precision? ( http://ftp.lstc.com/user/${PN}/F${PV}/linx.64/${FN_D}.${SH} )
	source? ( single-precision? ( http://ftp.lstc.com/objects/${PN}/F${PV}/${FN_S}.usermat.${SH} )
		double-precision? ( http://ftp.lstc.com/objects/${PN}/F${PV}/${FN_D}.usermat.${SH} ) )"
HOMEPAGE="http://www.lstc.com/"

LICENSE="Clickwrap-SLA"
KEYWORDS="~amd64"
SLOT="$(ver_cut 1)"
IUSE="single-precision +double-precision source"
REQUIRED_USE="^^ ( single-precision double-precision )"

RDEPEND=""
DEPEND="${RDEPEND}"

RESTRICT="fetch"

S=${WORKDIR}

QA_PRESTRIPPED="opt/${PN}/${PV}/licensingclient/linx64/ansyscl"

src_unpack() {

	if use single-precision; then
		sh "${DISTDIR}"/"${FN_S}.${SH}" --skip-license --exclude-subdir
	fi
	if use double-precision; then
		sh "${DISTDIR}"/"${FN_D}.${SH}" --skip-license --exclude-subdir
	fi
	if use source; then
		if use single-precision; then
			sh "${DISTDIR}"/"${FN_S}.usermat.${SH}" --skip-license --exclude-subdir
		fi
		if use double-precision; then
			sh "${DISTDIR}"/"${FN_D}.usermat.${SH}" --skip-license --exclude-subdir
		fi
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

	use source && doheader -r ${PN}

}