# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

if [ ! -z $(ver_cut 3) ]; then
	RELID="$(ver_cut 1)r$(ver_cut 2)m$(ver_cut 4)"
else
	RELID="$(ver_cut 1)r$(ver_cut 2)"
fi
FN="${PN}$(ver_cut 1)r$(ver_cut 2)_linux64.sh"
SH="${PN}${RELID}_linux64.sh"
MY_PN="360ex_$(ver_cut 1)r$(ver_cut 2)"

DESCRIPTION="A numerical results post-processor"
SRC_URI="https://tecplot.azureedge.net/products/360/${RELID}/${FN} -> ${SH}"
HOMEPAGE="https://www.tecplot.com/"

LICENSE="Tecplot-EULA"
KEYWORDS="~amd64"
SLOT="${PV}"
IUSE="chorus"

RDEPEND=""
DEPEND="${RDEPEND}"

S=${WORKDIR}

INSTDIR="opt/tecplot"

QA_TEXTRELS="${INSTDIR}/${MY_PN}/bin/libtecutildataio_loadflow3d.so"

QA_PRESTRIPPED="${INSTDIR}/${MY_PN}/bin/QtWebEngineProcess
	${INSTDIR}/${MY_PN}/bin/rlmutil
	${INSTDIR}/${MY_PN}/bin/openssl/libssl.so.1.0.2k
	${INSTDIR}/${MY_PN}/bin/openssl/libssh2.so.1.0.1
	${INSTDIR}/${MY_PN}/bin/openssl/libcrypto.so.1.0.2k
	${INSTDIR}/${MY_PN}/bin/ffmpeg
	${INSTDIR}/${MY_PN}/bin/sys/libstdc++.so.6.0.19
	${INSTDIR}/${MY_PN}/bin/sys/libgcc_s-4.8.5-20150702.so.1
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-dri3.so.0.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-glx.so.0.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxkbcommon.so.0.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxkbcommon-x11.so.0.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-xkb.so.1.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-xinerama.so.0.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-xfixes.so.0.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-util.so.1.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-sync.so.1.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-shm.so.0.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-shape.so.0.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-render.so.0.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-render-util.so.0.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-randr.so.0.1.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-keysyms.so.1.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-image.so.0.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-icccm.so.4.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb.so.1.1.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libpcre.so.1.2.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libpng15.so.15.13.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libjpeg.so.62.1.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libGLU.so.1.3.1
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5WebEngineCore.so.5.15.2"

src_install() {

	local myargs=""
	use chorus || myargs+=" --exclude-chorus"

	cp "${DISTDIR}/${SH}" ${SH}
	chmod +x ${SH}
	./${SH} --skip-license${myargs} --prefix="${ED}/${INSTDIR}"

	# These are world-writable for some reason
	fperms 664 "/${INSTDIR}/${MY_PN}/tecplotlm.lic"
	fperms 664 "/${INSTDIR}/${MY_PN}/variable_aliases.txt"

	make_desktop_entry "${EPREFIX}/${INSTDIR}/${MY_PN}/bin/tec360" "Tecplot 360 EX ${PV} R${PR:1:1}" ${P} "Science;DataVisualization"

}

pkg_postinst() {

	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update

}

pkg_postrm() {

	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update

}
