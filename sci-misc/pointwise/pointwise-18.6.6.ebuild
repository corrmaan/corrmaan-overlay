# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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

BDEPEND="X? ( media-gfx/icoutils
		      media-gfx/imagemagick )"
RDEPEND="virtual/jre:11
	     X? ( x11-libs/libXScrnSaver )"
DEPEND="${RDEPEND}"

S=${WORKDIR}

INSTDIR="opt/${PN^}/${PN^}V${RELID}"

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
	addpredict /root/.local/share/applications
	addpredict "${EPREFIX}/usr/local/bin/${PN}"
	addwrite /root/.java

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
