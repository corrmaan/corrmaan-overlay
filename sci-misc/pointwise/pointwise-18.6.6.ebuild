# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils java-pkg-2
MY_PV=$(ver_cut 1-2)
RELID="${MY_PV}R$(ver_cut 3)"
FN="pw-V${RELID}-linux_x86_64-nojre.sh"

DESCRIPTION="A commercial mesh generation software product"
SRC_URI="http://www.pointwise.com/downloads/${FN}
	doc?		( http://www.pointwise.com/downloads/${PN^^}_2022.2.2-glyph.tgz )
	tutorials?	( http://www.pointwise.com/downloads/README-tutorials.tgz -> ${P}-README-tutorials.tgz )"
HOMEPAGE="https://www.pointwise.com/"

LICENSE="Pointwise-RTULA"
KEYWORDS="~amd64"
SLOT="0"
IUSE="+X doc tutorials"
RESTRICT="mirror strip"

RDEPEND="|| ( >=virtual/jdk-1.8:* >=virtual/jdk-1.8:* )"
DEPEND="${RDEPEND}
	X? ( media-gfx/icoutils
		 media-gfx/imagemagick
		 x11-libs/libXScrnSaver )"

S=${WORKDIR}

INSTDIR="opt/${PN^}/${PN^}V${RELID}"

QA_PRESTRIPPED="${INSTDIR}/linux_x86_64/lib/libkernel_io.so
	${INSTDIR}/linux_x86_64/lib/libQt5Xml.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5XcbQpa.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5X11Extras.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5Widgets.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5Svg.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5PrintSupport.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5OpenGL.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5Network.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5Gui.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5DBus.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5Core.so.5.15.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKernel.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKXSBase.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKTopAlgo.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKShHealing.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKSTEPBase.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKSTEPAttr.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKSTEP209.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKSTEP.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKPrim.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKOffset.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKMath.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKIGES.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKGeomBase.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKGeomAlgo.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKG3d.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKG2d.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKFillet.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKFeat.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKBool.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKBRep.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKBO.so.7.3.1
	${INSTDIR}/linux_x86_64/bin/xcbglintegrations/libqxcb-glx-integration.so
	${INSTDIR}/linux_x86_64/bin/rlmutil
	${INSTDIR}/linux_x86_64/bin/qtdiag
	${INSTDIR}/linux_x86_64/bin/platforms/libqxcb.so
	${INSTDIR}/linux_x86_64/bin/imageformats/libqtiff.so
	${INSTDIR}/linux_x86_64/bin/imageformats/libqsvg.so
	${INSTDIR}/linux_x86_64/bin/iconengines/libqsvgicon.so
	${INSTDIR}/linux_x86_64/bin/iconengines/libqsvgicon.so
	${INSTDIR}/linux_x86_64/bin/imageformats/libqsvg.so
	${INSTDIR}/linux_x86_64/bin/imageformats/libqtiff.so
	${INSTDIR}/linux_x86_64/bin/libggbase.so
	${INSTDIR}/linux_x86_64/bin/libggcae.so
	${INSTDIR}/linux_x86_64/bin/libgcirender.so
	${INSTDIR}/linux_x86_64/bin/libggextrusion.so
	${INSTDIR}/linux_x86_64/bin/libggguibase.so
	${INSTDIR}/linux_x86_64/bin/libgggui.so
	${INSTDIR}/linux_x86_64/bin/libge.so
	${INSTDIR}/linux_x86_64/bin/libggplugin.so
	${INSTDIR}/linux_x86_64/bin/libggstreamobjects.so
	${INSTDIR}/linux_x86_64/bin/libggqt.so
	${INSTDIR}/linux_x86_64/bin/libggdatabase.so
	${INSTDIR}/linux_x86_64/bin/libggfunctions.so
	${INSTDIR}/linux_x86_64/bin/libggentities.so
	${INSTDIR}/linux_x86_64/bin/libggtcltools.so
	${INSTDIR}/linux_x86_64/bin/libggscene.so
	${INSTDIR}/linux_x86_64/bin/libggworkspace.so
	${INSTDIR}/linux_x86_64/bin/libggio.so
	${INSTDIR}/linux_x86_64/bin/liboctree.so
	${INSTDIR}/linux_x86_64/bin/libggmesh.so
	${INSTDIR}/linux_x86_64/bin/libggtypes.so
	${INSTDIR}/linux_x86_64/bin/ogaserver
	${INSTDIR}/linux_x86_64/bin/platforms/libqxcb.so
	${INSTDIR}/linux_x86_64/bin/pointwise
	${INSTDIR}/linux_x86_64/bin/libggv15compatability.so
	${INSTDIR}/linux_x86_64/bin/qtdiag
	${INSTDIR}/linux_x86_64/bin/libloom.so
	${INSTDIR}/linux_x86_64/bin/pointwise_ncr
	${INSTDIR}/linux_x86_64/bin/wish8.5
	${INSTDIR}/linux_x86_64/bin/libggtasks.so
	${INSTDIR}/linux_x86_64/bin/tclsh8.5
	${INSTDIR}/linux_x86_64/bin/xcbglintegrations/libqxcb-glx-integration.so
	${INSTDIR}/linux_x86_64/bin/libglyph.so
	${INSTDIR}/linux_x86_64/egads2nmb/libTKG2d.so.7.3.1
	${INSTDIR}/linux_x86_64/bin/rlmutil
	${INSTDIR}/linux_x86_64/egads2nmb/libTKFeat.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKBO.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKBRep.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKG3d.so.7.3.1
	${INSTDIR}/linux_x86_64/bin/pointwise_car
	${INSTDIR}/linux_x86_64/egads2nmb/egads2nmb
	${INSTDIR}/linux_x86_64/egads2nmb/libTKFillet.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKSTEP209.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKMath.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKOffset.so.7.3.1
	${INSTDIR}/linux_x86_64/bin/pointwise_hpcurvemesh
	${INSTDIR}/linux_x86_64/egads2nmb/libTKSTEPAttr.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKPrim.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKBool.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKGeomAlgo.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKIGES.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKernel.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKXSBase.so.7.3.1
	${INSTDIR}/linux_x86_64/lib/libQt5DBus.so.5.15.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKTopAlgo.so.7.3.1
	${INSTDIR}/linux_x86_64/lib/libQt5Network.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5Svg.so.5.15.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKSTEP.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKSTEPBase.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKGeomBase.so.7.3.1
	${INSTDIR}/linux_x86_64/egads2nmb/libTKShHealing.so.7.3.1
	${INSTDIR}/linux_x86_64/lib/libQt5X11Extras.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5OpenGL.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5Xml.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5PrintSupport.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/librsync.so
	${INSTDIR}/linux_x86_64/lib/libQt5XcbQpa.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5Core.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libQt5Gui.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libslugs2.so
	${INSTDIR}/linux_x86_64/egads2nmb/libegads.so
	${INSTDIR}/linux_x86_64/lib/libtclstub8.5.a
	${INSTDIR}/linux_x86_64/lib/libQt5Widgets.so.5.15.1
	${INSTDIR}/linux_x86_64/lib/libtbbmalloc.so.2
	${INSTDIR}/linux_x86_64/lib/libtcl8.5.so
	${INSTDIR}/linux_x86_64/lib/libtkstub8.5.a
	${INSTDIR}/linux_x86_64/plugins/libCaeCFL3D.so
	${INSTDIR}/linux_x86_64/lib/libtk8.5.so
	${INSTDIR}/linux_x86_64/plugins/libCaeAcuSolve.so
	${INSTDIR}/linux_x86_64/lib/libtbb.so.2
	${INSTDIR}/linux_x86_64/plugins/libCaeStarCD.so
	${INSTDIR}/linux_x86_64/plugins/libCaeOpenFOAM.so
	${INSTDIR}/linux_x86_64/plugins/libCaeStarCDv4.so
	${INSTDIR}/linux_x86_64/plugins/libCaeStrFdnsUnic.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUSM3DVGRID.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsAzore.so
	${INSTDIR}/linux_x86_64/lib/libkernel_io.so
	${INSTDIR}/linux_x86_64/plugins/libCaeStrGridgenGeneric.so
	${INSTDIR}/linux_x86_64/plugins/libCaeStrLAURA.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsCFDPP.so
	${INSTDIR}/linux_x86_64/lib/libxerces-c-3.2.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsCMSoftAero.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsADS.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsAnsysCFX.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsCRUNCH.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsCobalt.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsCart3D.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsEdge.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsFUN3D.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsFidelityPBS.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsGMesh.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsFluent.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsFrontFlow.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsExodusII.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsGambit.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsNSU3D.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsKestrel.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsMFEM.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsSCRYUTetra.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsShipIR.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsPyFR.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsSU2.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsStarCCMPlus.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsSuggarFlex.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsTetrex.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsThermalDesktop.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsUGRID.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsUMCPSEG.so
	${INSTDIR}/linux_x86_64/plugins/libGrdpAnsysCFX.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsWIND.so
	${INSTDIR}/linux_x86_64/plugins/libCaeUnsTAU.so
	${INSTDIR}/linux_x86_64/plugins/libGrdpCFDPP.so
	${INSTDIR}/linux_x86_64/plugins/libGrdpCRUNCH.so
	${INSTDIR}/linux_x86_64/plugins/libGrdpFUN3D.so
	${INSTDIR}/linux_x86_64/plugins/libGrdpGMesh.so
	${INSTDIR}/linux_x86_64/plugins/libGrdpFluent.so
	${INSTDIR}/linux_x86_64/plugins/libGrdpMFEM.so
	${INSTDIR}/linux_x86_64/plugins/libGrdpOpenFOAM.so
	${INSTDIR}/linux_x86_64/plugins/libGrdpUGRID.so
	${INSTDIR}/linux_x86_64/plugins/libGrdpSU2.so
	${INSTDIR}/linux_x86_64/plugins/libGrdpUSM3DVGrid.so"

src_prepare() {

	default

	if use tutorials
	then

		mkdir "${T}/tutorials"
		mv "${S}"/* "${T}/tutorials/"
		use doc && mv "${T}/tutorials/glyph2" "${S}/"
		mv "${T}/tutorials" "${S}/"

	fi

	use doc && HTML_DOCS="${S}/glyph2/."

	JAVAVM=$(readlink -f "${EPREFIX}/etc/java-config-2/current-system-vm")

	addpredict "${JAVAVM}"
	addpredict /root/.icesoft
	addpredict /root/.java
	addpredict /root/.local/share/applications
	addpredict "${EPREFIX}/usr/local/bin/${PN}"

}

src_install() {

	default

	cp "${DISTDIR}/${FN}" ${FN}
	chmod +x ${FN}

	cat <<EOT > response.varfile
licenseAcceptBtns\$Integer=0
sys.adminRights\$Boolean=false
sys.component.Pointwise\$Boolean=true
sys.installationDir=${ED}/${INSTDIR}
sys.languageId=en
EOT

	app_java_home="${EPREFIX}/usr" ./${FN} -varfile response.varfile -q || die

	dosym "${EPREFIX}/${INSTDIR}/${PN}" "${EPREFIX}/opt/bin/${PN}"

	newenvd - "52${P}" <<-_EOF_
		PWI_HOME="${EPREFIX}/${INSTDIR}"
	_EOF_

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
			newicon -s ${i} "icon_pwise_${j}_${i}x${i}x32.png" ${P}.png
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
