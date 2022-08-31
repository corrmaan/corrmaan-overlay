# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)"
SH="tar.gz_extractor.sh"
ARCH="x64"
PLATFORM="centos65"
IFORT="ifort160"
MPI="intelmpi-2018"

DESCRIPTION="A general-purpose finite element program"
SRC_URI="
	cpu_flags_x86_avx2? ( http://ftp.lstc.com/user/${PN}/R${PV}/x86-64/CentOS_6.5/ifort_160_avx2/MPP/ls-dyna_mpp_d_${MY_PV}_${ARCH}_${PLATFORM}_${IFORT}_avx2_${MPI}.${SH} )
	cpu_flags_x86_avx512f? ( http://ftp.lstc.com/user/${PN}/R${PV}/x86-64/CentOS_6.5/ifort_160_avx512/MPP/ls-dyna_mpp_d_${MY_PV}_${ARCH}_${PLATFORM}_${IFORT}_avx512_${MPI}.${SH} )
	cpu_flags_x86_sse2? ( http://ftp.lstc.com/user/${PN}/R${PV}/x86-64/CentOS_6.5/ifort_160_sse2/MPP/ls-dyna_mpp_d_${MY_PV}_${ARCH}_${PLATFORM}_${IFORT}_sse2_${MPI}.${SH} )"
HOMEPAGE="http://www.lstc.com/"

LICENSE="Clickwrap-SLA"
KEYWORDS="~amd64"
SLOT="${PV}"
IUSE="cpu_flags_x86_sse2 cpu_flags_x86_avx2 cpu_flags_x86_avx512f"
REQUIRED_USE="^^ ( cpu_flags_x86_sse2 cpu_flags_x86_avx2 cpu_flags_x86_avx512f )"

RESTRICT="fetch strip"

S=${WORKDIR}

INSTDIR="opt/${PN}/${PV}"

src_unpack() {

	if use cpu_flags_x86_avx512f; then
		CPU="avx512"
	elif use cpu_flags_x86_avx2; then
		CPU="avx2"
	elif use cpu_flags_x86_sse2; then
		CPU="sse2"
	fi

	FN="ls-dyna_mpp_d_${MY_PV}_${ARCH}_${PLATFORM}_${IFORT}_${CPU}_${MPI}"

	sh "${DISTDIR}"/"${FN}.${SH}" --skip-license --exclude-subdir

}

src_install() {

	exeinto "/${INSTDIR}"
	doexe "${FN}"*

}
