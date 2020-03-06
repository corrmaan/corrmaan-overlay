# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

RELID="${PV}${PR}"
FN="${PN}${RELID}_linux64.sh"

DESCRIPTION="A numerical results post-processor"
SRC_URI="http://download.tecplot.com/360/${RELID}/${FN}"
HOMEPAGE="https://www.tecplot.com/"

LICENSE="Tecplot-EULA"
KEYWORDS="~amd64"
SLOT="0"
IUSE="chorus"

RDEPEND=""
DEPEND="${RDEPEND}"

S=${WORKDIR}

INSTDIR="/opt/tecplot"

src_install() {
	local myargs=""
	use chorus || myargs+=" --exclude-chorus"
	
	cp ${DISTDIR}/${FN} ${FN}
	chmod +x ${FN}
	./${FN} --skip-license${myargs} --prefix=${D}${INSTDIR}

	# Fix for "/usr/lib64/libfontconfig.so.1: undefined symbol: FT_Done_MM_Var"
	rm ${D}${INSTDIR}/360ex_${RELID}/bin/libfreetype.so.6

	local i
	for i in 16x16 32x32 48x48 192x192; do
		newicon -s ${i} ${FILESDIR}/${PN}_${i}.png ${PN}.png
	done

	make_desktop_entry ${INSTDIR}/360ex_${RELID}/bin/tec360 "Tecplot 360 EX ${PV} R${PR:1:1}" ${PN} "Science;DataVisualization"

}
