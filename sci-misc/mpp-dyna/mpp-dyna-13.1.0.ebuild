# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="mpp-dyna"
MY_PV="R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)"
SH="tar.gz_extractor.sh"
ARCH="x64"
PLATFORM="centos78"
IFORT="ifort190"
MPI="intelmpi-2018"

DESCRIPTION="A general-purpose finite element program"
SRC_URI="single-precision? (
			http://ftp.lstc.com/user/${MY_PN}/R${PV}/usermat/x86-64/ifort_190_avx2/MPP/ls-dyna_mpp_s_${MY_PV}_${ARCH}_${PLATFORM}_${IFORT}_avx2_${MPI}.usermat.${SH}
			http://ftp.lstc.com/user/${MY_PN}/R${PV}/usermat/x86-64/ifort_190_avx512/MPP/ls-dyna_mpp_s_${MY_PV}_${ARCH}_${PLATFORM}_${IFORT}_avx512_${MPI}.usermat.${SH}
			http://ftp.lstc.com/user/${MY_PN}/R${PV}/usermat/x86-64/ifort_190_sse2/MPP/ls-dyna_mpp_s_${MY_PV}_${ARCH}_${PLATFORM}_${IFORT}_sse2_${MPI}.usermat.${SH}
		 )
		 double-precision? (
			http://ftp.lstc.com/user/${MY_PN}/R${PV}/usermat/x86-64/ifort_190_avx2/MPP/ls-dyna_mpp_d_${MY_PV}_${ARCH}_${PLATFORM}_${IFORT}_avx2_${MPI}.usermat.${SH}
			http://ftp.lstc.com/user/${MY_PN}/R${PV}/usermat/x86-64/ifort_190_avx512/MPP/ls-dyna_mpp_d_${MY_PV}_${ARCH}_${PLATFORM}_${IFORT}_avx512_${MPI}.usermat.${SH}
			http://ftp.lstc.com/user/${MY_PN}/R${PV}/usermat/x86-64/ifort_190_sse2/MPP/ls-dyna_mpp_d_${MY_PV}_${ARCH}_${PLATFORM}_${IFORT}_sse2_${MPI}.usermat.${SH}
		 )"
HOMEPAGE="http://www.lstc.com/"

LICENSE="Clickwrap-SLA"
KEYWORDS="~amd64"
SLOT="${PV}"
IUSE="cpu_flags_x86_sse2 cpu_flags_x86_avx2 cpu_flags_x86_avx512f +double-precision single-precision"
REQUIRED_USE="|| ( cpu_flags_x86_sse2 cpu_flags_x86_avx2 cpu_flags_x86_avx512f )
			  ^^ ( double-precision single-precision )"

RDEPEND="sci-libs/intel-oneapi[cxx,fortran,mkl,mpi]"
DEPEND="${RDEPEND}"

RESTRICT="fetch strip"

S="${WORKDIR}/usermat"

INSTDIR="opt/${MY_PN}/${PV}"

QA_PRESTRIPPED="${INSTDIR}/licensingclient/linx64/ansyscl"

src_unpack() {

	if use cpu_flags_x86_avx512f; then
		CPU="avx512"
	elif use cpu_flags_x86_avx2; then
		CPU="avx2"
	elif use cpu_flags_x86_sse2; then
		CPU="sse2"
	fi

	FN_S="ls-dyna_mpp_s_${MY_PV}_${ARCH}_${PLATFORM}_${IFORT}_${CPU}_${MPI}"
	FN_D="ls-dyna_mpp_d_${MY_PV}_${ARCH}_${PLATFORM}_${IFORT}_${CPU}_${MPI}"

	use single-precision && sh "${DISTDIR}"/"${FN_S}.usermat.${SH}" --skip-license --exclude-subdir
	use double-precision && sh "${DISTDIR}"/"${FN_D}.usermat.${SH}" --skip-license --exclude-subdir

	rm -rf licensingclient/winx64

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
	mv mppdyna "${FN}"

	exeinto "/${INSTDIR}"
	doexe "${FN}"

}
