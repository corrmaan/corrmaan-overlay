# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

MY_PV="$(ver_cut 1).$(ver_cut 2)"
MY_PV1="$(ver_cut 1)$(ver_cut 2)"
BUILDDATE=23Jun2023

DESCRIPTION="Advanced Pre- and Post-Processor for LS-DYNA"
SRC_URI="https://ftp.lstc.com/anonymous/outgoing/${PN}/${MY_PV}/linux64/${P}-common_gtk3-${BUILDDATE}.tgz
	doc? ( https://ftp.lstc.com/anonymous/outgoing/${PN}/${MY_PV}/doc/linux/Document.zip -> ${PN}-${MY_PV}-Document.zip
		https://ftp.lstc.com/anonymous/outgoing/${PN}/${MY_PV}/doc/linux/Tutor.zip -> ${PN}-${MY_PV}-Tutor.zip )"
HOMEPAGE="http://www.lstc.com/"

LICENSE="LSPREPOST"
KEYWORDS="~amd64"
SLOT="${MY_PV}"
IUSE="doc"
REQUIRED_USE=""

RDEPEND="media-libs/speex"
DEPEND=""
BDEPEND="doc? ( app-arch/unzip )"

S=${WORKDIR}/${PN}${MY_PV}_common_gtk3

INSTDIR="opt/${PN}-${MY_PV}"

QA_PRESTRIPPED="${INSTDIR}/lib2/libTKSTEPAttr.so.7.0.0
	${INSTDIR}/lib2/libTKStdL.so.7.0.0
	${INSTDIR}/lib2/libswscale.so.5.5.100
	${INSTDIR}/lib2/libTKG3d.so.7.0.0
	${INSTDIR}/lib2/libgcrypt.so.11.8.2
	${INSTDIR}/lib2/libpixman-1.so.0.34.0
	${INSTDIR}/lib2/libgnutls.so.28.43.3
	${INSTDIR}/lib2/libTKVRML.so.7.0.0
	${INSTDIR}/lib2/libTKTObj.so.7.0.0
	${INSTDIR}/lib2/libTKXSBase.so.7.0.0
	${INSTDIR}/lib2/libTKG2d.so.7.0.0
	${INSTDIR}/lib2/libTKXDEIGES.so.7.0.0
	${INSTDIR}/lib2/libdav1d.so.3.1.0
	${INSTDIR}/lib2/libTKXCAF.so.7.0.0
	${INSTDIR}/lib2/libTKMeshVS.so.7.0.0
	${INSTDIR}/lib2/libTKMath.so.7.0.0
	${INSTDIR}/lib2/libzvbi.so.0.13.2
	${INSTDIR}/lib2/libopencore-amrwb.so.0.0.3
	${INSTDIR}/lib2/libhogweed.so.2.5
	${INSTDIR}/lib2/libTKIGES.so.7.0.0
	${INSTDIR}/lib2/libopenh264.so.2.3.1
	${INSTDIR}/lib2/libTKFeat.so.7.0.0
	${INSTDIR}/lib2/libTKSTL.so.7.0.0
	${INSTDIR}/lib2/libavutil.so.57.28.100
	${INSTDIR}/lib2/libTKOffset.so.7.0.0
	${INSTDIR}/lib2/libgpg-error.so.0.10.0
	${INSTDIR}/lib2/libTKGeomAlgo.so.7.0.0
	${INSTDIR}/lib2/libTKBin.so.7.0.0
	${INSTDIR}/lib2/libTKTopAlgo.so.7.0.0
	${INSTDIR}/lib2/libTKHLR.so.7.0.0
	${INSTDIR}/lib2/libTKXmlTObj.so.7.0.0
	${INSTDIR}/lib2/libTKService.so.7.0.0
	${INSTDIR}/lib2/libswscale.so.6.7.100
	${INSTDIR}/lib2/libTKernel.so.7.0.0
	${INSTDIR}/lib2/libTKBO.so.7.0.0
	${INSTDIR}/lib2/libx264.so.160
	${INSTDIR}/lib2/libFWOSPlugin.so.7.0.0
	${INSTDIR}/lib2/libnettle.so.4.7
	${INSTDIR}/lib2/libTKXDESTEP.so.7.0.0
	${INSTDIR}/lib2/libTKCDF.so.7.0.0
	${INSTDIR}/lib2/libavformat.so.59.27.100
	${INSTDIR}/lib2/liblsmedia.so.22.11
	${INSTDIR}/lib2/libva-drm.so.1.4000.0
	${INSTDIR}/lib2/libswresample.so.4.7.100
	${INSTDIR}/lib2/libGLEW.so.2.0.0
	${INSTDIR}/lib2/libva-x11.so.1.4000.0
	${INSTDIR}/lib2/libTKSTEPBase.so.7.0.0
	${INSTDIR}/lib2/libjbig.so.2.0
	${INSTDIR}/lib2/libaom.so.3.1.1
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
	${INSTDIR}/lib2/libtiff.so.5.2.0
	${INSTDIR}/lib2/libTKVCAF.so.7.0.0
	${INSTDIR}/lib2/libTKLCAF.so.7.0.0
	${INSTDIR}/lib2/libTKBinXCAF.so.7.0.0
	${INSTDIR}/lib2/libTKSTEP209.so.7.0.0
	${INSTDIR}/lib2/libTKXmlXCAF.so.7.0.0
	${INSTDIR}/lib2/libTKBinL.so.7.0.0
	${INSTDIR}/lib2/libavcodec.so.59.37.100
	${INSTDIR}/lib2/libjpeg.so.62.1.0
	${INSTDIR}/lib2/libTKPrim.so.7.0.0
	${INSTDIR}/lib2/libTKXMesh.so.7.0.0
	${INSTDIR}/lib2/libswresample.so.3.5.100
	${INSTDIR}/lib2/libopencore-amrnb.so.0.0.3
	${INSTDIR}/lib2/libTKOpenGl.so.7.0.0
	${INSTDIR}/lib2/libsecret-1.so.0.0.0
	${INSTDIR}/lib2/libTKBool.so.7.0.0
	${INSTDIR}/lib2/libTKSTEP.so.7.0.0
	${INSTDIR}/lib2/libTKXmlL.so.7.0.0
	${INSTDIR}/lib2/libTKV3d.so.7.0.0
	${INSTDIR}/lib2/libva.so.1.4000.0
	${INSTDIR}/lsrun"

src_unpack() {

	unpack ${P}-common_gtk3-${BUILDDATE}.tgz

}

src_prepare() {

	default

	cp "${DISTDIR}/${PN}-${MY_PV}-Document.zip" Document.zip
	cp "${DISTDIR}/${PN}-${MY_PV}-Tutor.zip" Tutor.zip

cat <<EOT > lspp${MY_PV1}
#!/usr/bin/env bash
export LSPP_HELPDIR=${EPREFIX}/${INSTDIR}/resource/HelpDocument
export LD_LIBRARY_PATH=${EPREFIX}/${INSTDIR}/lib2:\$LD_LIBRARY_PATH
${EPREFIX}/${INSTDIR}/${PN}2 \$*
EOT

}

src_install() {

	default

	insinto /${INSTDIR}
	insopts -m0755
	doins lsdyna_bestfit lspp${MY_PV1} ${PN}2 lsrun msuite_ls_64 surfgen tetgen
	doins -r lib2
	insopts -m0644
	doins -r BaoSteel lspp_forming_${MY_PV1} lspp_matlib material.xml

	if use doc; then
		doins -r resource
		insinto /${INSTDIR}/resource/HelpDocument
		doins Document.zip Tutor.zip
	fi

	make_desktop_entry "${EPREFIX}/${INSTDIR}/lspp${MY_PV1}" "LS-PrePost V${PV}" ${PN} "Science;Physics" \
		"StartupWMClass=Lsprepost2"

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
