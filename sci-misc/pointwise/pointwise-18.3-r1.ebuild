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

INSTDIR="/opt/Pointwise/PointwiseV${RELID}"

addpredict /root/.java
addpredict /etc/.java/.systemPrefs/com/install4j/installations/prefs.tmp
addpredict /root/.local/share/applications
addpredict /usr/local/bin/${PN}

src_configure() {

cat <<EOT >> response.varfile
licenseAcceptBtns\$Integer=0
sys.adminRights\$Boolean=false
sys.component.Pointwise\$Boolean=true
sys.installationDir=${D}${INSTDIR}
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

	make_desktop_entry ${INSTDIR}/${PN} "Pointwise V${RELID} 64-bit" ${PN} "Science;"

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
