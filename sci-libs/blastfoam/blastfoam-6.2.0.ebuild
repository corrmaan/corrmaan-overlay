# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRC_URI="https://github.com/synthetik-technologies/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="A CFD solver for multi-component compressible flow"
HOMEPAGE="https://github.com/synthetik-technologies/blastfoam"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples source"

RDEPEND=""
DEPEND="sci-libs/openfoam:9=[source]"

DOCS=( "${S}/INPUT.md" "${S}/README.md" "${S}/BlastFoam_User_Guide.pdf" )

src_prepare() {

	default

	rm -rf "${S}/.dockerignore" "${S}/.github" "${S}/.gitignore" \
		"${S}/.releaserc" "${S}/.updateDeb.sh" "${S}/debian" \
		"${S}/Dockerfile" "${S}/Makefile"

}

src_configure() {

	export FOAM_VERBOSE=1
	export PS1=1

	sed -i 's:export BLAST_DIR=$HOME/$WM_PROJECT/$BLAST_PROJECT:export BLAST_DIR=$(cd $(dirname ${BASH_SOURCE\:-$0})/.. \&\& pwd -P):g' "${S}/etc/bashrc"

	source "${EPREFIX}/usr/$(get_libdir)/OpenFOAM-9/etc/bashrc"
	source "${S}/etc/bashrc"

}

src_compile() {

	./Allwmake ${MAKEOPTS} || die "Build failure."

	mv "${HOME}/OpenFOAM/-9/platforms" "${S}/"

}

src_install() {

	einstalldocs

	INSDIR="usr/$(get_libdir)"

	mkdir -p "${ED}/${INSDIR}"

	mv "${S}" "${ED}/${INSDIR}/${PN}"

	cd "${ED}/${INSDIR}/${PN}"

	rm -rf INPUT.md README.md BlastFoam_User_Guide.pdf media svgs

	use examples || rm -rf tutorials validation
	use source || rm -rf Allwclean Allwmake COPYING src

}

pkg_postinst() {

	elog "Please add the following to ~/.bashrc:"
	elog "source ${EPREFIX}/${INSDIR}/${PN}/etc/bashrc"

}
