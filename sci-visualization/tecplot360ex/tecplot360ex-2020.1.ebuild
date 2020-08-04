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

INSTDIR="opt/tecplot/360ex_${RELID}"

QA_TEXTRELS="${INSTDIR}/bin/libtecutildataio_loadflow3d.so"

QA_PRESTRIPPED="${INSTDIR}/bin/sys/libstdc++.so.6.0.13
	${INSTDIR}/bin/sys/libgcc_s-4.4.7-20120601.so.1
	${INSTDIR}/bin/ffmpeg
	${INSTDIR}/bin/sys-util/libpng12.so.0.49.0
	${INSTDIR}/bin/sys-util/libxcb-xfixes.so.0.0.0
	${INSTDIR}/bin/sys-util/libxcb-shape.so.0.0.0
	${INSTDIR}/bin/sys-util/libicudata.so.42.1
	${INSTDIR}/bin/sys-util/libicui18n.so.42.1
	${INSTDIR}/bin/sys-util/libxcb-render.so.0.0.0
	${INSTDIR}/bin/sys-util/libxcb-xkb.so.1.0.0
	${INSTDIR}/bin/sys-util/libjpeg.so.62.0.0
	${INSTDIR}/bin/sys-util/libGLU.so.1.3.1
	${INSTDIR}/bin/sys-util/libicuuc.so.42.1
	${INSTDIR}/bin/sys-util/libudev.so.0.5.1
	${INSTDIR}/bin/Qt/libQt5XcbQpa.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5MultimediaWidgets.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5Core.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5Network.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5Qml.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5Sql.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5Quick.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5OpenGL.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5Sensors.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5WebKitWidgets.so.5.5.1
	${INSTDIR}/bin/Qt/libQt5WebKit.so.5.5.1
	${INSTDIR}/bin/Qt/libQt5Svg.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5PrintSupport.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5EglFSDeviceIntegration.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5DBus.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5Widgets.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5Multimedia.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5Gui.so.5.12.2
	${INSTDIR}/bin/Qt/libQt5Positioning.so.5.12.2
	${INSTDIR}/bin/llvm/libtinfo.so.5.7
	${INSTDIR}/bin/plugins/bearer/libqgenericbearer.so
	${INSTDIR}/bin/plugins/platforms/libqminimalegl.so
	${INSTDIR}/bin/plugins/platforms/libqoffscreen.so
	${INSTDIR}/bin/plugins/platforms/libqminimal.so
	${INSTDIR}/bin/plugins/platforms/libqxcb.so
	${INSTDIR}/bin/plugins/platforms/libqlinuxfb.so
	${INSTDIR}/bin/plugins/platforms/libqeglfs.so
	${INSTDIR}/bin/plugins/platforms/libqvnc.so
	${INSTDIR}/bin/plugins/iconengines/libqsvgicon.so
	${INSTDIR}/bin/plugins/imageformats/libqwebp.so
	${INSTDIR}/bin/plugins/imageformats/libqicns.so
	${INSTDIR}/bin/plugins/imageformats/libqgif.so
	${INSTDIR}/bin/plugins/imageformats/libqsvg.so
	${INSTDIR}/bin/plugins/imageformats/libqtiff.so
	${INSTDIR}/bin/plugins/imageformats/libqwbmp.so
	${INSTDIR}/bin/plugins/imageformats/libqjpeg.so
	${INSTDIR}/bin/plugins/imageformats/libqico.so
	${INSTDIR}/bin/plugins/imageformats/libqtga.so
	${INSTDIR}/bin/plugins/xcbglintegrations/libqxcb-egl-integration.so
	${INSTDIR}/bin/plugins/xcbglintegrations/libqxcb-glx-integration.so
	${INSTDIR}/bin/rlmutil"

src_install() {

	local myargs=""
	use chorus || myargs+=" --exclude-chorus"

	cp "${DISTDIR}/${FN}" ${FN}
	chmod +x ${FN}
	./${FN} --skip-license${myargs} --prefix="${ED}/${INSTDIR}"

	# These are world-writable for some reason
	fperms 664 "/${INSTDIR}/tecplotlm.lic"
	fperms 664 "/${INSTDIR}/variable_aliases.txt"

	make_desktop_entry "${EPREFIX}/${INSTDIR}/bin/tec360" "Tecplot 360 EX ${PV} R${PR:1:1}" ${P} "Science;DataVisualization"

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
