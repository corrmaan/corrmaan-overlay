# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN}"
MY_PV="R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)"
SH="tar.gz_extractor.sh"
PLATFORM="centos79"
IFORT="intel190"

DESCRIPTION="A general-purpose finite element program"
SRC_URI="single-precision? (
			http://ftp.lstc.com/objects/${MY_PN}/R${PV}/${MY_PN}_smp_s_${MY_PV}_${PLATFORM}_${IFORT}.usermat.${SH}
		 )
		 double-precision? (
			http://ftp.lstc.com/objects/${MY_PN}/R${PV}/${MY_PN}_smp_d_${MY_PV}_${PLATFORM}_${IFORT}.usermat.${SH}
		 )"
HOMEPAGE="http://www.lstc.com/"

LICENSE="Clickwrap-SLA"
KEYWORDS="~amd64"
SLOT="${PV}"
IUSE="+double-precision single-precision"
REQUIRED_USE="^^ ( double-precision single-precision )"

BDEPEND="sci-libs/intel-oneapi[cxx,fortran,mkl]"
DEPEND="${BDEPEND}"

RESTRICT="fetch strip"

S="${WORKDIR}/usermat"

INSTDIR="opt/${MY_PN}/${PV}"

QA_PRESTRIPPED="${INSTDIR}/licensingclient/linx64/ansyscl"

src_unpack() {

	FN_S="${MY_PN}_smp_s_${MY_PV}_${PLATFORM}_${IFORT}"
	FN_D="${MY_PN}_smp_d_${MY_PV}_${PLATFORM}_${IFORT}"

	use single-precision && sh "${DISTDIR}"/"${FN_S}.usermat.${SH}" --skip-license --exclude-subdir
	use double-precision && sh "${DISTDIR}"/"${FN_D}.usermat.${SH}" --skip-license --exclude-subdir

	rm -rf "${S}/licensingclient/winx64"

}

src_prepare() {

	default
	use single-precision && eapply "${FILESDIR}/${FN_S}-Makefile.patch"
	use double-precision && eapply "${FILESDIR}/${FN_D}-Makefile.patch"

}

src_compile() {

	source /opt/intel/oneapi/setvars.sh
	make

}

src_install() {

	FN="${MY_PN}_${MY_PV}"
	mv lsdyna "${FN}"

	insinto "/${INSTDIR}"
	doins -r licensingclient

	exeinto "/${INSTDIR}"
	doexe "${FN}"

}
