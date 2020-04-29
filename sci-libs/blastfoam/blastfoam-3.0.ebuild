# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A CFD solver for multi-component compressible flow"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/synthetik-technologies/${PN}.git"
else
	SRC_URI="https://github.com/synthetik-technologies/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi
HOMEPAGE="https://github.com/synthetik-technologies/blastfoam"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="${PV}"
IUSE="examples gnuplot source"

DEPEND="sci-libs/openfoam:7=[gnuplot?,source]"

DOCS=( "${S}/INPUT.md" "${S}/README.md" "${S}/blastFoam_User_Guide.pdf" )

pkg_setup() {

	INSDIR="/usr/$(get_libdir)"

}

src_unpack() {

	default

	rm "${S}/.gitignore"

}

src_configure() {

	export FOAM_VERBOSE=1
	export PS1=1

	sed -i 's:export BLAST_DIR=$HOME/$WM_PROJECT/$BLAST_PROJECT:export BLAST_DIR=$(cd $(dirname ${BASH_SOURCE\:-$0})/.. \&\& pwd -P):g' "${S}/etc/bashrc"

	source "/usr/$(get_libdir)/OpenFOAM-7/etc/bashrc"
	source "${S}/etc/bashrc"

}

src_compile() {

	./Allwmake ${MAKEOPTS} || die "Build failure."

}

src_install() {

	einstalldocs

	mkdir -p "${ED}${INSDIR}"

	mv "${S}" "${ED}${INSDIR}/${P}"

	mv "${HOME}/OpenFOAM/-7/platforms" "${ED}${INSDIR}/${P}"

	cd "${ED}${INSDIR}/${P}"

	rm INPUT.md README.md blastFoam_User_Guide.pdf media svgs

	use examples || rm -rf tutorials validation
	use source || rm -rf Allwclean Allwmake COPYING src

}

pkg_postinst() {

	elog "Please add the following to ~/.bashrc:"
	elog "source ${INSDIR}/${P}/etc/bashrc"

}
