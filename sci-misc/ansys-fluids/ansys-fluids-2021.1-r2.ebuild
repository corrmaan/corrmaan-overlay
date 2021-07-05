# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs desktop xdg-utils multilib multilib-build

RELYEAR=$(ver_cut 1)
RELREV=$(ver_cut 2)
RELID="v${RELYEAR:(-2)}${RELREV}"

MY_P="FLUIDS_${RELYEAR}R${RELREV}_LINX64"
MY_P_DOC="ANSYSLOCALHELP_${RELYEAR}R${RELREV}_LINX64"

DESCRIPTION="A comprehensive product suite for modeling fluid flow"
SRC_URI="${MY_P}.tgz
		doc? ( ${MY_P_DOC}.tgz )"
HOMEPAGE="https://www.ansys.com/products/fluids"

LICENSE="Clickwrap-SLA"
KEYWORDS="~amd64"
SLOT="0"
IUSE="+X +cfx doc +fluent"
REQUIRED_USE="|| ( cfx fluent )"

RDEPEND="media-libs/freetype
	media-libs/libjpeg-turbo[${MULTILIB_USEDEP}]
	media-libs/libpng-compat:1.2
	>=sys-libs/glibc-2.33-r1"
DEPEND="${RDEPEND}
	app-arch/gzip
	app-arch/rpm[python]
	app-arch/tar
	media-gfx/icoutils"

RESTRICT="fetch"

S="${WORKDIR}/${MY_P}"
S_DOC="${WORKDIR}/${MY_P_DOC}"

INSTDIR="opt/ansys_inc"

QA_PREBUILT="${INSTDIR}/*"
addpredict "${EPREFIX}/var/lib/rpm/.dbenv.lock"

pkg_pretend() {

	use doc && CHECKREQS_DISK_BUILD="36G" || CHECKREQS_DISK_BUILD="30G"
	check-reqs_pkg_pretend

}

pkg_nofetch() {

	einfo "Please download"
	einfo " ${A}"
	einfo "from the ANSYS Customer portal and place it in your DISTDIR directory."

}

pkg_setup() {

	use doc && CHECKREQS_DISK_BUILD="36G" || CHECKREQS_DISK_BUILD="30G"
	check-reqs_pkg_setup

}

src_unpack() {

	mkdir -p "${S}"
	cd "${S}"
	unpack "${MY_P}.tgz"
	cd -

	if use doc; then

		mkdir -p "${S_DOC}"
		cd "${S_DOC}"
		unpack "${MY_P_DOC}.tgz"
		cd -

	fi

}

src_prepare() {

	default

	echo "SEARCH_DIRS_MASK=\"${EPREFIX}/${INSTDIR}"\" > "${T}/75-${PN}" || die

	mkdir -p "${T}/${MY_P}"
	use doc && 	mkdir -p "${T}/${MY_P_DOC}"

}

src_install() {

	insinto "/etc/revdep-rebuild"
	insopts -m0644
	doins "${T}/75-${PN}"

	local myargs=""

	use cfx && myargs+=" -cfx"
	use fluent && myargs+=" -fluent"

	"${S}/INSTALL" -usetempdir "${T}/${MY_P}" -silent${myargs} -install_dir "${ED}/${INSTDIR}"
	use doc && "${S_DOC}/INSTALL" -usetempdir "${T}/${MY_P_DOC}" -silent -install_dir "${ED}/${INSTDIR}"

	if use cfx; then

		sed -i "s,${ED},," "${ED}/${INSTDIR}/${RELID}/CFX/config/hostinfo.ccl"

		if use X; then

			icotool -x -p 0 -o . "${ED}/${INSTDIR}/${RELID}/CFX/etc/icons/CFX.ico"
			local i
			local j=6
			for i in 256 128 96 72 64 48 40 32 24 20 16; do
				case ${i} in
				16|22|24|32|36|48|64|72|96|128|192|256|512)
					newicon -s ${i} "CFX_${j}_${i}x${i}x32.png" "ansys-cfx-${PV}.png"
					;;
				*)
					;;
				esac
				j=$((j+1))
			done

			make_desktop_entry "${EPREFIX}/${INSTDIR}/${RELID}/CFX/bin/cfx5" "ANSYS CFX v${RELYEAR}R${RELREV}" "ansys-cfx-${PV}" "Science;Physics"

		fi

	fi

	if use fluent; then

		dosym "${EPREFIX}/${INSTDIR}/${RELID}/fluent/bin/fluent" /opt/bin/fluent

		if use X; then

			make_desktop_entry "${EPREFIX}/${INSTDIR}/${RELID}/fluent/bin/fluent" "ANSYS FLUENT v${RELYEAR}R${RELREV}" "ansys-fluent-${PV}" "Science;Physics"

		fi

	fi

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
