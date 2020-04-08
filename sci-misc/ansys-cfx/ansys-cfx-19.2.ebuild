# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

RELID="$(ver_cut 1)$(ver_cut 2)"

DESCRIPTION="A comprehensive product suite for modeling fluid flow"
SRC_URI="FLUIDS_${RELID}_LINX64.tar"
HOMEPAGE="https://www.ansys.com/products/fluids"

LICENSE="Clickwrap-SLA"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	app-arch/gzip
	app-arch/rpm[python]
	app-arch/tar"

RESTRICT="fetch"

S=${WORKDIR}

INSTALLDIR="/opt/ansys_inc"

addpredict /var/lib/rpm/.dbenv.lock

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

	"${S}/INSTALL" -usetempdir "${T}/anstmp" -silent${myargs} -install_dir "${ED}${INSTALLDIR}"

	for dir in Addins CADConfigLogs EKM Electronics Framework Images RSM SEC SystemCoupling Tools aisol installer tp
	do
		rm -rf "${ED}${INSTALLDIR}/v${RELID}/${dir}"
	done

	source /etc/env.d/gcc/config-x86_64-pc-linux-gnu
	source /etc/env.d/gcc/${CURRENT}

	cd "${ED}${INSTALLDIR}/v${RELID}/CFX/lib/linux-amd64"
	rm libstdc++.so.6
	ln -s ${LDPATH%%:*}/libstdc++.so libstdc++.so.6
	cd -

	sed -i "s,${ED},," "${ED}${INSTALLDIR}/v${RELID}/CFX/config/hostinfo.ccl"

	local i
	for i in 16x16 32x32 48x48; do
		newicon -s ${i} "${FILESDIR}/cfx-${i}.png cfx.png"
	done

	make_desktop_entry ${INSTALLDIR}/v${RELID}/CFX/bin/cfx5 "ANSYS CFX v${PV}" cfx "Science;Physics"

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
