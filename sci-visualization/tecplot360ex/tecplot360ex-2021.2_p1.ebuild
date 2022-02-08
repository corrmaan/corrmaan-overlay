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

QA_PRESTRIPPED="${INSTDIR}/${MY_PN}/bin/plugins/iconengines/libqsvgicon.so
	${INSTDIR}/${MY_PN}/bin/plugins/xcbglintegrations/libqxcb-glx-integration.so
	${INSTDIR}/${MY_PN}/bin/plugins/xcbglintegrations/libqxcb-egl-integration.so
	${INSTDIR}/${MY_PN}/bin/plugins/platforms/libqvnc.so
	${INSTDIR}/${MY_PN}/bin/plugins/platforms/libqminimalegl.so
	${INSTDIR}/${MY_PN}/bin/plugins/platforms/libqxcb.so
	${INSTDIR}/${MY_PN}/bin/plugins/platforms/libqlinuxfb.so
	${INSTDIR}/${MY_PN}/bin/plugins/platforms/libqminimal.so
	${INSTDIR}/${MY_PN}/bin/plugins/platforms/libqeglfs.so
	${INSTDIR}/${MY_PN}/bin/plugins/platforms/libqoffscreen.so
	${INSTDIR}/${MY_PN}/bin/plugins/bearer/libqgenericbearer.so
	${INSTDIR}/${MY_PN}/bin/plugins/imageformats/libqsvg.so
	${INSTDIR}/${MY_PN}/bin/plugins/imageformats/libqtga.so
	${INSTDIR}/${MY_PN}/bin/plugins/imageformats/libqicns.so
	${INSTDIR}/${MY_PN}/bin/plugins/imageformats/libqtiff.so
	${INSTDIR}/${MY_PN}/bin/plugins/imageformats/libqwebp.so
	${INSTDIR}/${MY_PN}/bin/plugins/imageformats/libqwbmp.so
	${INSTDIR}/${MY_PN}/bin/plugins/imageformats/libqgif.so
	${INSTDIR}/${MY_PN}/bin/plugins/imageformats/libqico.so
	${INSTDIR}/${MY_PN}/bin/plugins/imageformats/libqjpeg.so
	${INSTDIR}/${MY_PN}/bin/rlmutil
	${INSTDIR}/${MY_PN}/bin/llvm/libtinfo.so.5.7
	${INSTDIR}/${MY_PN}/bin/ffmpeg
	${INSTDIR}/${MY_PN}/bin/sys-util/libxcb-xkb.so.1.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libudev.so.0.5.1
	${INSTDIR}/${MY_PN}/bin/sys-util/libpng12.so.0.49.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libjpeg.so.62.0.0
	${INSTDIR}/${MY_PN}/bin/sys-util/libicuuc.so.42.1
	${INSTDIR}/${MY_PN}/bin/sys-util/libicui18n.so.42.1
	${INSTDIR}/${MY_PN}/bin/sys-util/libicudata.so.42.1
	${INSTDIR}/${MY_PN}/bin/sys-util/libGLU.so.1.3.1
	${INSTDIR}/${MY_PN}/bin/sys/libstdc++.so.6.0.13
	${INSTDIR}/${MY_PN}/bin/sys/libgcc_s-4.4.7-20120601.so.1
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5WebKitWidgets.so.5.5.1
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5WebKit.so.5.5.1
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5Sql.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5Sensors.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5Quick.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5Qml.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5Positioning.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5MultimediaWidgets.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5Multimedia.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5XcbQpa.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5EglFSDeviceIntegration.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5DBus.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5Widgets.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5Svg.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5PrintSupport.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5OpenGL.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5Network.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5Gui.so.5.12.2
	${INSTDIR}/${MY_PN}/bin/Qt/libQt5Core.so.5.12.2"

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
