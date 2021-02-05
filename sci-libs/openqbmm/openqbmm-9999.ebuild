# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN=OpenQBMM

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${MY_PN}/${MY_PN}.git"
	EGIT_BRANCH="development-openfoam.org"
else
	SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${MY_PN}_${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${MY_PN}_${PV}"
fi

DESCRIPTION="An open-source implementation of Quadrature-Based Moment Methods"
HOMEPAGE="https://github.com/${MY_PN}/${MY_PN}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples source test"

DEPEND="sci-libs/openfoam:7=[source]
		doc? ( app-doc/doxygen[dot] )"

DOCS=( "${S}/README.md" )

src_prepare() {

	INSDIR="usr/$(get_libdir)"

	default

	rm -rf "${S}/".git* "${S}/.travis.yml"

	sed -e 's/^curl/#&/' -i  "${S}/Allwmake"

	if use doc; then
		HTML_DOCS=( "${S}/doc/Doxygen/html/." )
		sed -e 's:/home/alberto/Desktop/OpenQBMM-Test/OpenQBMM/doc/::' -i "${S}/doc/Doxyfile"
	fi

	use examples || rm -rf "${S}/tutorials" "${S}/validation"

	if ! use test; then
		sed -e '/(cd test \&\& .\/Allwmake)/ s/^#*/#/' -i "${S}/Allwmake"
	fi

}

src_configure() {

	export FOAM_VERBOSE=1
	export PS1=1

	source "${EPREFIX}/${INSDIR}/OpenFOAM-7/etc/bashrc"

}

src_compile() {

	./Allwmake ${MAKEOPTS} || die "Build failure."

	mv "${HOME}/OpenFOAM/-7/platforms" "${S}/"

	if use doc ; then
		cd "${S}/doc" && doxygen Doxyfile && cd -
	fi

}

src_install() {

	einstalldocs
	rm README.md
	use source || rm -rf Allwclean Allwmake COPYING src

	mkdir -p "${ED}/${INSDIR}"
	mv "${S}" "${ED}/${INSDIR}/${PN}"

}
