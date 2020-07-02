# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

RELID="$(ver_cut 1)r$(ver_cut 2)"
FN="${PN}${RELID}_linux64.sh"

DESCRIPTION="A numerical results post-processor"
SRC_URI="http://download.tecplot.com/360/${RELID}/${FN}"
HOMEPAGE="https://www.tecplot.com/"

LICENSE="Tecplot-EULA"
KEYWORDS="~amd64"
SLOT="0"
IUSE="chorus"

RDEPEND=""
DEPEND="${RDEPEND}"

S=${WORKDIR}

INSTDIR="opt/tecplot"

QA_TEXTRELS="${INSTDIR}/360ex_${RELID}/bin/libtecutildataio_loadflow3d.so"

QA_PRESTRIPPED="${INSTDIR}/360ex_${RELID}/bin/ffmpeg
	${INSTDIR}/360ex_${RELID}/bin/libQtWebKit.so.4.9.4
	${INSTDIR}/360ex_${RELID}/bin/libQtCore.so.4
	${INSTDIR}/360ex_${RELID}/bin/libQtGui.so.4
	${INSTDIR}/360ex_${RELID}/bin/rlmutil
	${INSTDIR}/360ex_${RELID}/bin/sys-util/libjpeg.so.62.0.0
	${INSTDIR}/360ex_${RELID}/bin/sys-util/libssl.so.10
	${INSTDIR}/360ex_${RELID}/bin/sys-util/libpng12.so.0.49.0
	${INSTDIR}/360ex_${RELID}/bin/sys-util/libcrypto.so.10
	${INSTDIR}/360ex_${RELID}/bin/libQtNetwork.so.4
	${INSTDIR}/360ex_${RELID}/bin/libQtOpenGL.so.4.8.6
	${INSTDIR}/360ex_${RELID}/bin/plugins/imageformats/libqjpeg.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/imageformats/libqgif.so"

src_install() {
	local myargs=""
	use chorus || myargs+=" --exclude-chorus"

	cp "${DISTDIR}/${FN}" ${FN}
	chmod +x ${FN}
	./${FN} --skip-license${myargs} --prefix="${ED}/${INSTDIR}"

	# Fix for "/usr/lib64/libfontconfig.so.1: undefined symbol: FT_Done_MM_Var"
	rm "${ED}/${INSTDIR}/360ex_${RELID}/bin/libfreetype.so.6"

	# These are world-writable for some reason
	fperms 664 "${ED}/${INSTDIR}/360ex_${RELID}/tecplotlm.lic"
	fperms 664 "${ED}/${INSTDIR}/360ex_${RELID}/variable_aliases.txt"

	local i
	for i in 16x16 32x32 48x48 192x192; do
		newicon -s ${i} "${FILESDIR}/${PN}-${i}.png" ${PN}.png
	done

	make_desktop_entry /${INSTDIR}/360ex_${RELID}/bin/tec360 "Tecplot 360 EX ${PV} R${PR:1:1}" ${PN} "Science;DataVisualization"

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
