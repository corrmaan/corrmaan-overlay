# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

RELYEAR=$(ver_cut 1)
RELREV=$(ver_cut 2)
RELID="v${RELYEAR:(-2)}${RELREV}"

DESCRIPTION="A comprehensive product suite for modeling fluid flow"
SRC_URI="FLUIDS_${RELYEAR}R${RELREV}_LINX64.tar"
HOMEPAGE="https://www.ansys.com/products/fluids"

LICENSE="Clickwrap-SLA"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/gzip
	app-arch/rpm[python]
	app-arch/tar
	media-gfx/icoutils"

RESTRICT="fetch"

S=${WORKDIR}

INSTDIR="opt/ansys_inc"

addpredict "${EPREFIX}/var/lib/rpm/.dbenv.lock"

pkg_nofetch() {
	einfo "Please download"
	einfo "  - ${SRC_URI}"
	einfo "from the ANSYS Customer portal and place it in your DISTDIR directory."
}

src_prepare() {
	default

	# Just disable Workbench config at install entirely
	cd "${S}/configs/wb"
		tar xzf LINX64.TGZ
		echo '#!/bin/sh' > config/AnsConfigWB.sh
		tar czf LINX64.TGZ config unconfig
		chown --reference=../ansys/LINX64.TGZ LINX64.TGZ
		chmod --reference=../ansys/LINX64.TGZ LINX64.TGZ
		rm -rf config unconfig
	cd -

	mkdir -p "${T}/anstmp"
}

src_install() {

	local myargs=""

	myargs+=" -cfx"

	"${S}/INSTALL" -usetempdir "${T}/anstmp" -silent${myargs} -install_dir "${ED}/${INSTDIR}"

	for dir in Addins CADConfigLogs EKM Electronics Framework Images RSM SEC SystemCoupling Tools aisol installer tp
	do
		rm -rf "${ED}/${INSTDIR}/${RELID}/${dir}/"
	done

	source "${EPREFIX}/etc/env.d/gcc/config-x86_64-pc-linux-gnu"
	source "${EPREFIX}/etc/env.d/gcc/${CURRENT}"

	cd "${ED}/${INSTDIR}/${RELID}/CFX/lib/linux-amd64"
	rm libstdc++.so.6
	ln -s ${LDPATH%%:*}/libstdc++.so libstdc++.so.6
	cd -

	sed -i "s,${ED},," "${ED}/${INSTDIR}/${RELID}/CFX/config/hostinfo.ccl"

	icotool -x -p 0 -o . "${ED}/${INSTDIR}/${RELID}/CFX/etc/icons/CFX.ico"
	local i
	local j=6
	for i in 256 128 96 72 64 48 40 32 24 20 16; do
		case ${i} in
		16|22|24|32|36|48|64|72|96|128|192|256|512)
			newicon -s ${i} "CFX_${j}_${i}x${i}x32.png" ${P}
			;;
		*)
			;;
		esac
		j=$((j+1))
	done

	make_desktop_entry "${EPREFIX}/${INSTDIR}/${RELID}/CFX/bin/cfx5" "ANSYS CFX v${RELYEAR}R${RELREV}" ${P} "Science;Physics"

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
