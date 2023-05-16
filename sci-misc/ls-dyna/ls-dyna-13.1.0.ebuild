# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="R$(ver_cut 1)_$(ver_cut 2)_$(ver_cut 3)"
SH="tar.gz_extractor.sh"
PLATFORM="centos79"
IFORT="intel190"

DESCRIPTION="A general-purpose finite element program"
SRC_URI="http://ftp.lstc.com/user/${PN}/R${PV}/linx.64/${PN}_smp_d_${MY_PV}_${PLATFORM}_${IFORT}.${SH}"
HOMEPAGE="http://www.lstc.com/"

LICENSE="Clickwrap-SLA"
KEYWORDS="~amd64"
SLOT="${PV}"

RDEPEND=""
DEPEND="${RDEPEND}"

RESTRICT="fetch mirror strip"

S=${WORKDIR}

INSTDIR="opt/${PN}/${PV}"

QA_PRESTRIPPED="${INSTDIR}/licensingclient/linx64/ansyscl"

src_unpack() {

	FN="${PN}_smp_d_${MY_PV}_${PLATFORM}_${IFORT}"

	sh "${DISTDIR}"/"${FN}.${SH}" --skip-license --exclude-subdir

	rm -rf licensingclient/winx64

}

src_install() {

	ARCH="x64"
	IFORT="ifort190"

	FN="${PN}_smp_d_${MY_PV}_${ARCH}_${PLATFORM}_${IFORT}"

	insinto "/${INSTDIR}"
	doins -r licensingclient

	exeinto "/${INSTDIR}"
	doexe "${FN}"

}
