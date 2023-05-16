# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)"
SH="tgz_extractor.sh"
PLATFORM="centos79"
IFORT="intel190"
FN="${PN}_smp_d_${MY_PV}_${PLATFORM}_${IFORT}"

DESCRIPTION="A general-purpose finite element program"
SRC_URI="http://ftp.lstc.com/user/${PN}/R${PV}/linx.64/${FN}.${SH}"
HOMEPAGE="http://www.lstc.com/"

LICENSE="Clickwrap-SLA"
KEYWORDS="~amd64"
SLOT="${PV}"

RDEPEND=""
DEPEND="${RDEPEND}"

RESTRICT="fetch mirror strip"

S="${WORKDIR}/${FN}"

INSTDIR="opt/${PN}/${PV}"

QA_PRESTRIPPED="${INSTDIR}/licensingclient/linx64/ansyscl"

src_unpack() {

	sh "${DISTDIR}"/"${FN}.${SH}" --skip-license --exclude-subdir

}

src_prepare() {

	default
	rm -rf licensingclient/winx64

}

src_install() {

	insinto "/${INSTDIR}"
	doins -r licensingclient

	exeinto "/${INSTDIR}"
	doexe "${FN}"

}
