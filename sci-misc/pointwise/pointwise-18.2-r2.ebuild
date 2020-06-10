# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

RELID="${PV}R${PR:1:1}"
FN="pw-V${RELID}-linux_x86_64-nojre.sh"

DESCRIPTION="A commercial mesh generation software product"
SRC_URI="ftp://ftp.pointwise.com/dload/${FN}"
HOMEPAGE="https://www.pointwise.com/"

LICENSE="Pointwise-RTULA"
KEYWORDS="~amd64"
SLOT="${PV}"
IUSE=""

RDEPEND="|| ( virtual/jre:1.8 virtual/jdk:1.8 )
	dev-lang/tcl
	dev-lang/tk"
DEPEND="${RDEPEND}
	media-gfx/imagemagick"

S=${WORKDIR}

INSTDIR="opt/Pointwise/PointwiseV${RELID}"

addpredict /root/.java
addpredict /etc/.java/.systemPrefs/com/install4j/installations/prefs.tmp
addpredict /root/.local/share/applications
addpredict /usr/local/bin/${PN}

QA_PRESTRIPPED="${INSTDIR}/linux_x86_64/lib/libmg-tetra.so
	${INSTDIR}/linux_x86_64/lib/libmeshgems_stubs.so
	${INSTDIR}/linux_x86_64/lib/libmeshgems.so
	${INSTDIR}/linux_x86_64/lib/libkernel_io.so
	${INSTDIR}/linux_x86_64/lib/libQt5Xml.so.5.9.5
	${INSTDIR}/linux_x86_64/lib/libQt5XcbQpa.so.5.9.5
	${INSTDIR}/linux_x86_64/lib/libQt5X11Extras.so.5.9.5
	${INSTDIR}/linux_x86_64/lib/libQt5Widgets.so.5.9.5
	${INSTDIR}/linux_x86_64/lib/libQt5Svg.so.5.9.5
	${INSTDIR}/linux_x86_64/lib/libQt5PrintSupport.so.5.9.5
	${INSTDIR}/linux_x86_64/lib/libQt5OpenGL.so.5.9.5
	${INSTDIR}/linux_x86_64/lib/libQt5Network.so.5.9.5
	${INSTDIR}/linux_x86_64/lib/libQt5Gui.so.5.9.5
	${INSTDIR}/linux_x86_64/lib/libQt5DBus.so.5.9.5
	${INSTDIR}/linux_x86_64/lib/libQt5Core.so.5.9.5
	${INSTDIR}/linux_x86_64/bin/xcbglintegrations/libqxcb-glx-integration.so
	${INSTDIR}/linux_x86_64/bin/rlmutil
	${INSTDIR}/linux_x86_64/bin/qtdiag
	${INSTDIR}/linux_x86_64/bin/pointwise_tet
	${INSTDIR}/linux_x86_64/bin/platforms/libqxcb.so
	${INSTDIR}/linux_x86_64/bin/imageformats/libqtiff.so
	${INSTDIR}/linux_x86_64/bin/imageformats/libqsvg.so
	${INSTDIR}/linux_x86_64/bin/iconengines/libqsvgicon.so"

src_configure() {

cat <<EOT >> response.varfile
licenseAcceptBtns\$Integer=0
sys.adminRights\$Boolean=false
sys.component.Pointwise\$Boolean=true
sys.installationDir=${D}/${INSTDIR}
sys.languageId=en
EOT

}

src_install() {

	cp "${DISTDIR}/${FN}" ${FN}
	chmod +x ${FN}
	./${FN} -varfile response.varfile -q

	local i
	for i in 16x16 24x24 32x32 48x48 64x64 96x96 128x128 192x192 256x256 512x512; do
		newicon -s ${i} "${FILESDIR}/${PN}-${i}.png" ${PN}.png
	done

	make_desktop_entry /${INSTDIR}/${PN} "Pointwise V${RELID} 64-bit" ${PN} "Science;"

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
