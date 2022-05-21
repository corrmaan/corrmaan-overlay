# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SH="tgz_extractor.sh"

DESCRIPTION="A general-purpose finite element program"
SRC_URI="single-precision? (
			http://ftp.lstc.com/user/${PN}/R${PV}/x86-64/ifort_190_sse2/MPP/ls-dyna_mpp_s_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos610_ifort190_sse2_openmpi4.0.0.${SH}
			http://ftp.lstc.com/user/${PN}/R${PV}/x86-64/ifort_190_avx2/MPP/ls-dyna_mpp_s_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos610_ifort190_avx2_openmpi4.0.0.${SH}
			http://ftp.lstc.com/user/${PN}/R${PV}/x86-64/ifort_190_avx2/MPP/ls-dyna_mpp_s_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos610_ifort190_avx512_openmpi4.0.0.${SH}
		 )
		 double-precision? (
			http://ftp.lstc.com/user/${PN}/R${PV}/x86-64/ifort_190_sse2/MPP/ls-dyna_mpp_d_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos610_ifort190_sse2_openmpi4.0.0.${SH}
			http://ftp.lstc.com/user/${PN}/R${PV}/x86-64/ifort_190_avx2/MPP/ls-dyna_mpp_d_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos610_ifort190_avx2_openmpi4.0.0.${SH}
			http://ftp.lstc.com/user/${PN}/R${PV}/x86-64/ifort_190_avx2/MPP/ls-dyna_mpp_d_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos610_ifort190_avx512_openmpi4.0.0.${SH}
		 )"
HOMEPAGE="http://www.lstc.com/"

LICENSE="Clickwrap-SLA"
KEYWORDS="~amd64"
SLOT="$(ver_cut 1)"
IUSE="single-precision +double-precision cpu_flags_x86_sse2 cpu_flags_x86_avx2 cpu_flags_x86_avx512f"
REQUIRED_USE="^^ ( single-precision double-precision )"

RDEPEND="~sys-cluster/openmpi-4.0.0[icc]"
DEPEND="${RDEPEND}"

RESTRICT="fetch"

S=${WORKDIR}

QA_PRESTRIPPED="opt/${PN}/${PV}/licensingclient/linx64/ansyscl"

src_unpack() {

	if use cpu_flags_x86_avx512f; then
		FN_S="ls-dyna_mpp_s_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos610_ifort190_avx512_openmpi4.0.0"
		FN_D="ls-dyna_mpp_d_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos610_ifort190_avx512_openmpi4.0.0"
	elif use cpu_flags_x86_avx2; then
		FN_S="ls-dyna_mpp_s_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos610_ifort190_avx2_openmpi4.0.0"
		FN_D="ls-dyna_mpp_d_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos610_ifort190_avx2_openmpi4.0.0"
	elif use cpu_flags_x86_sse2; then
		FN_S="ls-dyna_mpp_s_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos610_ifort190_sse2_openmpi4.0.0"
		FN_D="ls-dyna_mpp_d_R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)_x64_centos610_ifort190_sse2_openmpi4.0.0"
	fi

	if use single-precision; then
		sh "${DISTDIR}"/"${FN_S}.${SH}" --skip-license --exclude-subdir
	fi
	if use double-precision; then
		sh "${DISTDIR}"/"${FN_D}.${SH}" --skip-license --exclude-subdir
	fi
	rm -rf licensingclient/winx64

}

src_install() {

	insinto /opt/${PN}/${PV}
	doins -r licensingclient

	exeinto /opt/${PN}/${PV}
	use single-precision && doexe "${FN_S}"
	use double-precision && doexe "${FN_D}"

}
