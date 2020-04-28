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

DEPEND="sci-libs/openfoam:7[gnuplot?,source]"

DOCS=( "${S}/INPUT.md" "${S}/README.md" "${S}/blastFoam_User_Guide.pdf" )

pkg_setup() {

	INSDIR="/usr/$(get_libdir)/${P}"

}

src_configure() {

	append-cflags $(test-flags-CC -m64)
	append-cflags $(test-flags-CC -fPIC)
	append-cxxflags $(test-flags-CXX -m64)
	append-cxxflags $(test-flags-CXX -fPIC)
	append-cxxflags $(test-flags-CXX -std=c++11)
	append-ldflags -m64

	if tc-ld-is-gold; then
		# Need to disable gold linker https://bugs.openfoam.org/view.php?id=685
		tc-ld-disable-gold
		# tc-ld-disable-gold only appends -fuse-ld=bfd to LDFLAGS, also need to 
		# append it to C[XX]FLAGS:
		append-cflags $(test-flags-CC -fuse-ld=bfd)
		append-cxxflags $(test-flags-CXX -fuse-ld=bfd)
	fi

	export FOAM_VERBOSE=1
	export PS1=1

	sed -i 's:export BLAST_DIR=$HOME/$WM_PROJECT/$BLAST_PROJECT:export BLAST_DIR=$(cd $(dirname ${BASH_SOURCE\:-$0})/../.. \&\& pwd -P):g' "${S}/etc/bashrc"

	source "/usr/$(get_libdir)/OpenFOAM-7/etc/bashrc"
	source "${S}/etc/bashrc"

}

src_compile() {

	./Allwmake ${MAKEOPTS} || die "Build failure."

}

src_install() {

#	insinto ${INSDIR}

#	doins -r applications
#	doins -r bin
#	doins -r etc
#	doins -r platforms

#	if use examples ; then
#		doins -r tutorials
#		doins -r validation
#	fi
#	use source && doins -r src

	use doc && einstalldocs

}

pkg_postinst() {

	elog "Please add the following to ~/.bashrc:"
	elog "source ${INSDIR}/etc/bashrc"

}
