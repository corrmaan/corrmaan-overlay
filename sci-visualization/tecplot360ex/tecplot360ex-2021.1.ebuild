# Copyright 1999-2021 Gentoo Authors
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

QA_PRESTRIPPED="${INSTDIR}/360ex_${RELID}/bin/sys/libstdc++.so.6.0.13
	${INSTDIR}/360ex_${RELID}/bin/sys/libgcc_s-4.4.7-20120601.so.1
	${INSTDIR}/360ex_${RELID}/bin/ffmpeg
	${INSTDIR}/360ex_${RELID}/bin/sys-util/libpng12.so.0.49.0
	${INSTDIR}/360ex_${RELID}/bin/sys-util/libicudata.so.42.1
	${INSTDIR}/360ex_${RELID}/bin/sys-util/libicui18n.so.42.1
	${INSTDIR}/360ex_${RELID}/bin/sys-util/libxcb-xkb.so.1.0.0
	${INSTDIR}/360ex_${RELID}/bin/sys-util/libjpeg.so.62.0.0
	${INSTDIR}/360ex_${RELID}/bin/sys-util/libGLU.so.1.3.1
	${INSTDIR}/360ex_${RELID}/bin/sys-util/libicuuc.so.42.1
	${INSTDIR}/360ex_${RELID}/bin/sys-util/libudev.so.0.5.1
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5XcbQpa.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5MultimediaWidgets.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5Core.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5Network.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5Qml.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5Sql.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5Quick.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5OpenGL.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5Sensors.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5WebKitWidgets.so.5.5.1
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5WebKit.so.5.5.1
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5Svg.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5PrintSupport.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5EglFSDeviceIntegration.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5DBus.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5Widgets.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5Multimedia.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5Gui.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/Qt/libQt5Positioning.so.5.12.2
	${INSTDIR}/360ex_${RELID}/bin/llvm/libtinfo.so.5.7
	${INSTDIR}/360ex_${RELID}/bin/plugins/bearer/libqgenericbearer.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/platforms/libqminimalegl.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/platforms/libqoffscreen.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/platforms/libqminimal.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/platforms/libqxcb.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/platforms/libqlinuxfb.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/platforms/libqeglfs.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/platforms/libqvnc.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/iconengines/libqsvgicon.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/imageformats/libqwebp.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/imageformats/libqicns.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/imageformats/libqgif.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/imageformats/libqsvg.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/imageformats/libqtiff.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/imageformats/libqwbmp.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/imageformats/libqjpeg.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/imageformats/libqico.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/imageformats/libqtga.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/xcbglintegrations/libqxcb-egl-integration.so
	${INSTDIR}/360ex_${RELID}/bin/plugins/xcbglintegrations/libqxcb-glx-integration.so
	${INSTDIR}/360ex_${RELID}/bin/rlmutil"

src_install() {

	local myargs=""
	use chorus || myargs+=" --exclude-chorus"

	cp "${DISTDIR}/${FN}" ${FN}
	chmod +x ${FN}
	./${FN} --skip-license${myargs} --prefix="${ED}/${INSTDIR}"

#	# These are world-writable for some reason
	fperms 664 "/${INSTDIR}/360ex_${RELID}/tecplotlm.lic"
	fperms 664 "/${INSTDIR}/360ex_${RELID}/variable_aliases.txt"

	make_desktop_entry "${EPREFIX}/${INSTDIR}/360ex_${RELID}/bin/tec360" "Tecplot 360 EX ${PV} R${PR:1:1}" ${P} "Science;DataVisualization"

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
