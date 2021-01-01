# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils
MY_PV=$(ver_cut 1-2)
RELID="${MY_PV}R$(ver_cut 3)"
FN="pw-V${RELID}-linux_x86_64-nojre.sh"

DESCRIPTION="A commercial mesh generation software product"
SRC_URI="http://www.pointwise.com/downloads/${FN}
	doc?		( http://www.pointwise.com/downloads/${PN^^}_V${RELID}-glyph.tgz -> ${P}-glyph.tgz )
	tutorials?	( http://www.pointwise.com/downloads/tutorials.tgz -> ${P}-tutorials.tgz )"
HOMEPAGE="https://www.pointwise.com/"

LICENSE="Pointwise-RTULA"
KEYWORDS="~amd64"
SLOT="0"
IUSE="+X doc tutorials"

RDEPEND="|| ( virtual/jre:1.8 virtual/jdk:1.8 )"
DEPEND="${RDEPEND}
	X? ( media-gfx/icoutils
		 media-gfx/imagemagick )"

S=${WORKDIR}

INSTDIR="opt/${PN^}/${PN^}V${RELID}"

#QA_PRESTRIPPED="${INSTDIR}/linux_x86_64/lib/libkernel_io.so
#	${INSTDIR}/linux_x86_64/lib/libQt5Xml.so.5.15.0
#	${INSTDIR}/linux_x86_64/lib/libQt5XcbQpa.so.5.15.0
#	${INSTDIR}/linux_x86_64/lib/libQt5X11Extras.so.5.15.0
#	${INSTDIR}/linux_x86_64/lib/libQt5Widgets.so.5.15.0
#	${INSTDIR}/linux_x86_64/lib/libQt5Svg.so.5.15.0
#	${INSTDIR}/linux_x86_64/lib/libQt5PrintSupport.so.5.15.0
#	${INSTDIR}/linux_x86_64/lib/libQt5OpenGL.so.5.15.0
#	${INSTDIR}/linux_x86_64/lib/libQt5Network.so.5.15.0
#	${INSTDIR}/linux_x86_64/lib/libQt5Gui.so.5.15.0
#	${INSTDIR}/linux_x86_64/lib/libQt5DBus.so.5.15.0
#	${INSTDIR}/linux_x86_64/lib/libQt5Core.so.5.15.0
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKernel.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKXSBase.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKTopAlgo.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKShHealing.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKSTEPBase.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKSTEPAttr.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKSTEP209.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKSTEP.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKPrim.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKOffset.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKMath.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKIGES.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKGeomBase.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKGeomAlgo.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKG3d.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKG2d.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKFillet.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKFeat.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKBool.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKBRep.so.7.3.1
#	${INSTDIR}/linux_x86_64/egads2nmb/libTKBO.so.7.3.1
#	${INSTDIR}/linux_x86_64/bin/xcbglintegrations/libqxcb-glx-integration.so
#	${INSTDIR}/linux_x86_64/bin/rlmutil
#	${INSTDIR}/linux_x86_64/bin/qtdiag
#	${INSTDIR}/linux_x86_64/bin/platforms/libqxcb.so
#	${INSTDIR}/linux_x86_64/bin/imageformats/libqtiff.so
#	${INSTDIR}/linux_x86_64/bin/imageformats/libqsvg.so
#	${INSTDIR}/linux_x86_64/bin/iconengines/libqsvgicon.so"

src_prepare() {

	default

	if use tutorials
	then

		rm "${S}/TutorialWorkbook.pdf"

		mkdir "${T}/tutorials"
		mv "${S}"/* "${T}/tutorials/"
		use doc && mv "${T}/tutorials/glyph2" "${S}/"
		mv "${T}/tutorials" "${S}/"

	fi

	use doc && HTML_DOCS="${S}/glyph2/."

	JAVAVM=$(readlink -f "${EPREFIX}/etc/java-config-2/current-system-vm")

	addpredict "${JAVAVM}"
	addpredict /root/.java
	addpredict /root/.local/share/applications
	addpredict "${EPREFIX}/usr/local/bin/${PN}"

}

src_configure() {

cat <<EOT >> response.varfile
licenseAcceptBtns\$Integer=0
sys.adminRights\$Boolean=false
sys.component.Pointwise\$Boolean=true
sys.installationDir=${ED}/${INSTDIR}
sys.languageId=en
EOT

}

src_install() {

	default

	cp "${DISTDIR}/${FN}" ${FN}
	chmod +x ${FN}

	app_java_home="${EPREFIX}/usr" ./${FN} -varfile response.varfile -q || die

	dosym "${EPREFIX}/${INSTDIR}/${PN}" "/opt/bin/${PN}"

	if use X
	then

		convert -density 960 -background none \
			"${ED}/${INSTDIR}/doc/user-manual/images/icons/icon_pwise.svg" \
			-define icon:auto-resize="16,22,24,32,36,48,64,72,96,128,192,256" \
			icon_pwise.ico
		icotool -x -o . icon_pwise.ico
		local i
		local j=1
		for i in 16 22 24 32 36 48 64 72 96 128 192 256; do
			case ${i} in
			16|22|24|32|36|48|64|72|96|128|192|256|512)
				if [ ${i} -eq 256 ]; then
					newicon -s ${i} "icon_pwise_${j}_${i}x${i}x64.png" ${P}.png
				else
					newicon -s ${i} "icon_pwise_${j}_${i}x${i}x32.png" ${P}.png
				fi
				;;
			*)
				;;
			esac
			j=$((j+1))
		done

		make_desktop_entry "${EPREFIX}/${INSTDIR}/${PN}" "${PN^} V${RELID} 64-bit" ${P} "Science;"

	fi

	use tutorials && insinto "/${INSTDIR}" && doins -r "${S}/tutorials"

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
