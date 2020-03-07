# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

RELID="$(ver_cut 1)$(ver_cut 2)"

DESCRIPTION="A comprehensive product suite for modeling fluid flow"
SRC_URI="FLUIDS_${RELID}_LINX64.tar"
HOMEPAGE="https://www.ansys.com/products/fluids"

LICENSE="Clickwrap-SLA"
KEYWORDS="~amd64"
SLOT="0"
IUSE="mechapdl ansyscust autodyn lsdyna cfdpost +cfx turbogrid fluent polyflow aqwa icemcfd forte chemkinpro energico fensapice reactionwb mfl rsm parasolid acis ug_plugin icepak catia5_reader"

RDEPEND=""
DEPEND="
	app-arch/gzip
	app-arch/rpm[python]
	app-arch/tar
	dev-lang/perl
	media-gfx/imagemagick"

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
	cd ${S}/configs/wb
		tar xzf LINX64.TGZ
		rm config/AnsConfigWB.sh
		echo '#!/bin/sh' > config/AnsConfigWB.sh
		chmod 775 config/AnsConfigWB.sh
		tar czf LINX64.TGZ config unconfig
		chmod 755 LINX64.TGZ
		rm -rf config unconfig
	cd -

	mkdir -p ${T}/anstmp
}

src_install() {
	local myargs=""

	use mechapdl && myargs+=" -mechapdl"
	use ansyscust && myargs+=" -ansyscust"
	use autodyn && myargs+=" -autodyn"
	use lsdyna && myargs+=" -lsdyna"
	use cfdpost && myargs+=" -cfdpost"
	use cfx && myargs+=" -cfx"
	use turbogrid && myargs+=" -turbogrid"
	use fluent && myargs+=" -fluent"
	use polyflow && myargs+=" -polyflow"
	use aqwa && myargs+=" -aqwa"
	use icemcfd && myargs+=" -icemcfd"
	use forte && myargs+=" -forte"
	use chemkinpro && myargs+=" -chemkinpro"
	use energico && myargs+=" -energico"
	use fensapice && myargs+=" -fensapice"
	use reactionwb && myargs+=" -reactionwb"
	use mfl && myargs+=" -mfl"
	use rsm && myargs+=" -rsm"
	use parasolid && myargs+=" -parasolid"
	use acis && myargs+=" -acis"
	use ug_plugin && myargs+=" -ug_plugin"
	use icepak && myargs+=" -icepak"
	use catia5_reader && myargs+=" -catia5_reader"

	${S}/INSTALL -usetempdir ${T}/anstmp -silent${myargs} -install_dir "${ED}${INSTALLDIR}"

	for dir in Addins CADConfigLogs EKM Electronics Framework Images RSM SEC SystemCoupling Tools aisol installer tp
	do
		rm -rf ${ED}${INSTALLDIR}/v${RELID}/${dir}
	done

	if use cfx; then

		source /etc/env.d/gcc/config-x86_64-pc-linux-gnu
		source /etc/env.d/gcc/${CURRENT}

		cd ${ED}${INSTALLDIR}/v${RELID}/CFX/lib/linux-amd64
		rm libstdc++.so.6
		ln -s ${LDPATH%%:*}/libstdc++.so libstdc++.so.6
		cd -

		sed -i "s,${ED},," ${ED}${INSTALLDIR}/v${RELID}/CFX/config/hostinfo.ccl

		local i
		for i in 16x16 32x32 48x48; do
			newicon -s ${i} ${FILESDIR}/cfx-${i}.png cfx.png
		done

		make_desktop_entry ${INSTALLDIR}/v${RELID}/CFX/bin/cfx5 "ANSYS CFX v${PV}" cfx "Science;Physics"

	fi
}


