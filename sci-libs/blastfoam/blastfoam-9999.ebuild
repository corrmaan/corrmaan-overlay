# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/synthetik-technologies/${PN}.git"
else
	SRC_URI="https://github.com/synthetik-technologies/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="A CFD solver for multi-component compressible flow"
HOMEPAGE="https://github.com/synthetik-technologies/${PN}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples gnuplot qbmm source"

DEPEND="sci-libs/openfoam:7=[gnuplot?,source]
		qbmm? ( sci-libs/openqbmm:=[source] )"

DOCS=( "${S}/INPUT.md" "${S}/README.md" "${S}/BlastFoam_User_Guide.pdf" )

src_prepare() {

	INSDIR="usr/$(get_libdir)"

	default

	rm -rf "${S}"/.git* "${S}/media" "${S}/svgs"

	use examples || rm -rf "${S}/tutorials" "${S}/validation"

}

src_configure() {

	export FOAM_VERBOSE=1
	export PS1=1

	source "${EPREFIX}/${INSDIR}/OpenFOAM-7/etc/bashrc"

	if use qbmm; then
		export QBMM_INST_DIR="${WM_PROJECT_INST_DIR}/openqbmm"
		sed -e "s:export QBMM_LIBBIN=\$FOAM_USER_LIBBIN:export QBMM_LIBBIN=${QBMM_INST_DIR}/platforms/${WM_OPTIONS}/lib:" -i "${S}/etc/bashrc"
		sed -e "s:export QBMM_APPBIN=\$FOAM_USER_APPBIN:export QBMM_APPBIN=${QBMM_INST_DIR}/platforms/${WM_OPTIONS}/bin:" -i "${S}/etc/bashrc"
		# Fix for ld missing library errors
		sed -e 's:export QBMM_LIBS="-L\\\$(QBMM_LIBBIN) -leigenSolver -lquadratureNode -lmomentSets -lmomentInversion -lfieldMomentInversion -lquadratureApproximation -lmomentAdvection -lPDFTransportModel -lmixing -lpopulationBalance\":export QBMM_LIBS=\"-L\\\$(QBMM_LIBBIN) -leigenSolver -lvandermonde -lquadratureNode -lmomentSets -lmomentInversion -lfieldMomentInversion -lquadratureApproximation -lmomentAdvection -lPDFTransportModel -lmixing -lpopulationBalance":' -i "${S}/etc/bashrc"
	fi
	source "${S}/etc/bashrc"

}

src_compile() {

	./Allwmake ${MAKEOPTS} || die "Build failure."

	mv "${HOME}/OpenFOAM/-7/platforms" "${S}/"

}

src_install() {

	einstalldocs
	rm INPUT.md README.md BlastFoam_User_Guide.pdf
	use source || rm -rf Allwclean Allwmake COPYING src

	mkdir -p "${ED}/${INSDIR}"
	mv "${S}" "${ED}/${INSDIR}/${PN}"

}

pkg_postinst() {

	elog "Please add the following to ~/.bashrc:"
	elog "source ${EPREFIX}/${INSDIR}/${PN}/etc/bashrc"

}
