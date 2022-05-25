# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="ls-dyna"
MY_PV="R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)"
SH="tar.gz_extractor.sh"
PLATFORM="centos79"
IFORT="intel190"

DESCRIPTION="A general-purpose finite element program"
SRC_URI="single-precision? (
			http://ftp.lstc.com/user/${MY_PN}/R${PV}/linx.64/${MY_PN}_smp_s_${MY_PV}_${PLATFORM}_${IFORT}.${SH}
		 )
		 double-precision? (
			http://ftp.lstc.com/user/${MY_PN}/R${PV}/linx.64/${MY_PN}_smp_d_${MY_PV}_${PLATFORM}_${IFORT}.${SH}
		 )"
HOMEPAGE="http://www.lstc.com/"

LICENSE="Clickwrap-SLA"
KEYWORDS="~amd64"
SLOT="${PV}"
IUSE="+double-precision single-precision"
REQUIRED_USE="|| ( double-precision single-precision )"

RDEPEND=""
DEPEND="${RDEPEND}"

RESTRICT="fetch strip"

S=${WORKDIR}

INSTDIR="opt/${MY_PN}/${PV}"

QA_PRESTRIPPED="${INSTDIR}/licensingclient/linx64/ansyscl"

src_unpack() {

	FN_S="${MY_PN}_smp_s_${MY_PV}_${PLATFORM}_${IFORT}"
	FN_D="${MY_PN}_smp_d_${MY_PV}_${PLATFORM}_${IFORT}"

	use single-precision && sh "${DISTDIR}"/"${FN_S}.${SH}" --skip-license --exclude-subdir
	use double-precision && sh "${DISTDIR}"/"${FN_D}.${SH}" --skip-license --exclude-subdir

	rm -rf licensingclient/winx64

}

src_install() {

	ARCH="x64"
	IFORT="ifort190"

	FN_S="${MY_PN}_smp_s_${MY_PV}_${ARCH}_${PLATFORM}_${IFORT}"
	FN_D="${MY_PN}_smp_d_${MY_PV}_${ARCH}_${PLATFORM}_${IFORT}"

	insinto "/${INSTDIR}"
	doins -r licensingclient

	exeinto "/${INSTDIR}"
	use single-precision && doexe "${FN_S}"
	use double-precision && doexe "${FN_D}"

}
