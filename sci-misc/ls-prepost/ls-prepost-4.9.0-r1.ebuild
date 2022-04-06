# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

BUILDDATE=28Mar2022

DESCRIPTION="Advanced Pre- and Post-Processor for LS-DYNA"
SRC_URI="http://ftp.lstc.com/user/${PN}/$(ver_cut 1).$(ver_cut 2)/linux64/lsprepost-${PV}-common_gtk3-${BUILDDATE}.tgz"
HOMEPAGE="http://www.lstc.com/"

LICENSE="LSPREPOST"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""
REQUIRED_USE=""

RDEPEND=""
DEPEND=""

RESTRICT="fetch"

S=${WORKDIR}/lsprepost$(ver_cut 1).$(ver_cut 2)_common_gtk3

INSTDIR="opt/${PN}"

HTML_DOCS="resource/HelpDocument/."

QA_PRESTRIPPED="${INSTDIR}/lib2/libTKSTEPAttr.so.7.0.0
	${INSTDIR}/lib2/libTKStdL.so.7.0.0
	${INSTDIR}/lib2/libswscale.so.5.5.100
	${INSTDIR}/lib2/libavformat.so.58.29.100
	${INSTDIR}/lib2/libTKG3d.so.7.0.0
	${INSTDIR}/lib2/libavutil.so.56.31.100
	${INSTDIR}/lib2/libTKVRML.so.7.0.0
	${INSTDIR}/lib2/libTKTObj.so.7.0.0
	${INSTDIR}/lib2/libTKXSBase.so.7.0.0
	${INSTDIR}/lib2/libTKG2d.so.7.0.0
	${INSTDIR}/lib2/libTKXDEIGES.so.7.0.0
	${INSTDIR}/lib2/libTKXCAF.so.7.0.0
	${INSTDIR}/lib2/libTKMeshVS.so.7.0.0
	${INSTDIR}/lib2/libTKMath.so.7.0.0
	${INSTDIR}/lib2/libTKIGES.so.7.0.0
	${INSTDIR}/lib2/libTKFeat.so.7.0.0
	${INSTDIR}/lib2/libTKSTL.so.7.0.0
	${INSTDIR}/lib2/libTKOffset.so.7.0.0
	${INSTDIR}/lib2/libTKGeomAlgo.so.7.0.0
	${INSTDIR}/lib2/libTKBin.so.7.0.0
	${INSTDIR}/lib2/libTKTopAlgo.so.7.0.0
	${INSTDIR}/lib2/libTKHLR.so.7.0.0
	${INSTDIR}/lib2/libTKXmlTObj.so.7.0.0
	${INSTDIR}/lib2/libTKService.so.7.0.0
	${INSTDIR}/lib2/libTKernel.so.7.0.0
	${INSTDIR}/lib2/libTKBO.so.7.0.0
	${INSTDIR}/lib2/libx264.so.160
	${INSTDIR}/lib2/libFWOSPlugin.so.7.0.0
	${INSTDIR}/lib2/libTKXDESTEP.so.7.0.0
	${INSTDIR}/lib2/libTKCDF.so.7.0.0
	${INSTDIR}/lib2/libGLEW.so.2.0.0
	${INSTDIR}/lib2/libTKSTEPBase.so.7.0.0
	${INSTDIR}/lib2/libTKStd.so.7.0.0
	${INSTDIR}/lib2/libTKCAF.so.7.0.0
	${INSTDIR}/lib2/libTKGeomBase.so.7.0.0
	${INSTDIR}/lib2/libpng15.so.15.13.0
	${INSTDIR}/lib2/libTKXml.so.7.0.0
	${INSTDIR}/lib2/libTKShHealing.so.7.0.0
	${INSTDIR}/lib2/libTKBinTObj.so.7.0.0
	${INSTDIR}/lib2/libTKMesh.so.7.0.0
	${INSTDIR}/lib2/libTKFillet.so.7.0.0
	${INSTDIR}/lib2/libTKBRep.so.7.0.0
	${INSTDIR}/lib2/libTKVCAF.so.7.0.0
	${INSTDIR}/lib2/libTKLCAF.so.7.0.0
	${INSTDIR}/lib2/libTKBinXCAF.so.7.0.0
	${INSTDIR}/lib2/libTKSTEP209.so.7.0.0
	${INSTDIR}/lib2/libTKXmlXCAF.so.7.0.0
	${INSTDIR}/lib2/libTKBinL.so.7.0.0
	${INSTDIR}/lib2/libjpeg.so.62.1.0
	${INSTDIR}/lib2/libTKPrim.so.7.0.0
	${INSTDIR}/lib2/libTKXMesh.so.7.0.0
	${INSTDIR}/lib2/libswresample.so.3.5.100
	${INSTDIR}/lib2/libavcodec.so.58.54.100
	${INSTDIR}/lib2/libTKOpenGl.so.7.0.0
	${INSTDIR}/lib2/libTKBool.so.7.0.0
	${INSTDIR}/lib2/libTKSTEP.so.7.0.0
	${INSTDIR}/lib2/libTKXmlL.so.7.0.0
	${INSTDIR}/lib2/libTKV3d.so.7.0.0"

src_prepare() {

	default

cat <<EOT > lspp$(ver_cut 1)$(ver_cut 2)
#!/usr/bin/env bash
export LD_LIBRARY_PATH=${EPREFIX}/${INSTDIR}/lib2:\$LD_LIBRARY_PATH
${EPREFIX}/${INSTDIR}/lsprepost \$*
EOT

}

src_install() {

	default

	insinto /${INSTDIR}
	insopts -m0755
	doins lsdyna_bestfit lspp$(ver_cut 1)$(ver_cut 2) lsprepost2 lsrun msuite_ls_64 tetgen
	doins -r lib2
	insopts -m0644
	doins -r BaoSteel lspp_forming_$(ver_cut 1)$(ver_cut 2) lspp_matlib material.xml

	make_desktop_entry "${EPREFIX}/${INSTDIR}/lspp$(ver_cut 1)$(ver_cut 2)" "LS-PrePost V${PV}" ${PN} "Science;Physics"

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
