# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_PN="OpenFOAM"
MY_PV="$(ver_cut 1)"
MY_PP="$(ver_cut 3)"
if [ -z "${MY_PP}" ]; then
	MY_PP="version-${MY_PV}"
fi

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenFOAM/OpenFOAM-dev.git"
else
	SRC_URI="https://github.com/${MY_PN}/${MY_PN}-${MY_PV}/archive/${MY_PP}.tar.gz -> ${MY_PN}-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="The Open Source CFD Toolbox"
HOMEPAGE="https://openfoam.org/"
LICENSE="GPL-3"
SLOT="${MY_PV}"
IUSE="cgal doc examples gnuplot metis mpi paraview perftools scotch source test"

RDEPEND="gnuplot? ( sci-visualization/gnuplot )
	paraview? ( sci-visualization/paraview )"
DEPEND="dev-libs/boost[mpi?]
	|| ( >=sys-devel/gcc-4.8 >=sys-devel/clang-3.6 )
	sys-devel/flex
	sys-libs/ncurses
	sys-libs/readline
	sys-libs/zlib
	x11-libs/libXt
	cgal? ( sci-mathematics/cgal )
	doc? ( app-doc/doxygen[dot] )
	metis? ( sci-libs/metis )
	mpi? ( sys-cluster/openmpi )
	perftools? ( dev-util/google-perftools )
	scotch? ( sci-libs/scotch[mpi?] )"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_unpack() {

	default

	mv "${WORKDIR}/${MY_PN}-${MY_PV}-${MY_PP}" "${S}"

}

src_prepare() {

	INSDIR="usr/$(get_libdir)"
	DOCS=( "${S}/README.org" "${S}/doc/Guides" "${S}/doc/codingStyleGuide.org" )

	default

	use examples || rm -rf "${S}/tutorials"

	use doc && HTML_DOCS=( "${S}/doc/Doxygen/html/." )

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

	use mpi || sed -i '/config.sh\/mpi/s/^/#/g' "${S}/etc/bashrc"
	sed -i '/config.sh\/paraview/s/^/#/g' "${S}/etc/bashrc"
	sed -i '/config.sh\/ensight/s/^/#/g' "${S}/etc/bashrc"

	sed -i "s/export WM_CC='gcc'/export WM_CC='$(tc-getCC)'/g" "${S}/etc/config.sh/settings"
	sed -i "s/export WM_CXX='g++'/export WM_CXX='$(tc-getCXX)'/g" "${S}/etc/config.sh/settings"
	sed -i "s/export WM_CFLAGS='-m64 -fPIC'/export WM_CFLAGS='${CFLAGS}'/g" "${S}/etc/config.sh/settings"
	sed -i "s/export WM_CXXFLAGS='-m64 -fPIC -std=c++0x'/export WM_CXXFLAGS='${CXXFLAGS}'/g" "${S}/etc/config.sh/settings"
	sed -i "s/export WM_LDFLAGS='-m64'/export WM_LDFLAGS='${LDFLAGS}'/g" "${S}/etc/config.sh/settings"

	use cgal && export FOAMY_HEX_MESH=yes

	if use metis; then
		sed -i "s/METIS_VERSION=metis-.*/METIS_VERSION=metis-system/g" "${S}/etc/config.sh/metis"
		sed -i "s:export METIS_ARCH_PATH=\$WM_THIRD_PARTY_DIR/platforms/\$WM_ARCH\$WM_COMPILER\$WM_PRECISION_OPTION\$WM_LABEL_OPTION/\$METIS_VERSION:export METIS_ARCH_PATH=/usr:g" "${S}/etc/config.sh/metis"
	else
		sed -i "s/METIS_VERSION=metis-.*/METIS_VERSION=metis-none/g" "${S}/etc/config.sh/metis"
		sed -i "s:export METIS_ARCH_PATH=\$WM_THIRD_PARTY_DIR/platforms/\$WM_ARCH\$WM_COMPILER\$WM_PRECISION_OPTION\$WM_LABEL_OPTION/\$METIS_VERSION:export METIS_ARCH_PATH=:g" "${S}/etc/config.sh/metis"
	fi

	if use perftools; then
		sed -i "s/version=svn/version=system/g" "${S}/etc/config.sh/gperftools"
		sed -i "s:GPERFTOOLS_ARCH_PATH=\$gperftools_install/\$GPERFTOOLS_VERSION:GPERFTOOLS_ARCH_PATH=/usr:g" "${S}/etc/config.sh/gperftools"
	else
		sed -i "s/version=svn/version=none/g" "${S}/etc/config.sh/gperftools"
	fi

	if use scotch; then
		sed -i "s/export SCOTCH_VERSION=scotch_.*/export SCOTCH_VERSION=scotch-system/g" "${S}/etc/config.sh/scotch"
		sed -i "s:export SCOTCH_ARCH_PATH=\$WM_THIRD_PARTY_DIR/platforms/\$WM_ARCH\$WM_COMPILER\$WM_PRECISION_OPTION\$WM_LABEL_OPTION/\$SCOTCH_VERSION:export SCOTCH_ARCH_PATH=/usr:g" "${S}/etc/config.sh/scotch"
	else
		sed -i "s/export SCOTCH_VERSION=scotch_.*/export SCOTCH_VERSION=scotch-none/g" "${S}/etc/config.sh/scotch"
	fi

	source "${S}/etc/bashrc"

	# wmake Rules Changes
	COMPILER_TYPE=$(echo $WM_COMPILER | tr -d [:digit:])
	GENERAL_RULES="${WM_DIR}/rules/General"
	DEFAULT_RULES="${WM_DIR}/rules/${WM_ARCH}${COMPILER_TYPE}"
	RULES="${WM_DIR}/rules/${WM_ARCH}${WM_COMPILER}"
	WMAKE_BIN="${WM_DIR}/platforms/${WM_ARCH}${WM_COMPILER}"

	sed -i "s/AR         = ar/AR         = $(tc-getAR)/g" ${GENERAL_RULES}/general
	sed -i "s/RANLIB     = ranlib/RANLIB     = $(tc-getRANLIB)/g" ${GENERAL_RULES}/general
	sed -i "s/CPP        = cpp/CPP        = $(tc-getCPP)/g" ${GENERAL_RULES}/general
	sed -i "s/LD         = ld/LD         = $(tc-getLD)/g" ${GENERAL_RULES}/general

	# The command below is used instead of $(tc-getCPP) because that produces linking 
	# errors as gcc -E
	CPP=$(readlink -f `which cpp` | rev | cut -d'/' -f1 | rev)
	sed -i "s/CPP        = cpp/CPP        = ${CPP}/g" "${DEFAULT_RULES}/general"

	sed -i "s/cc          = gcc -m64/cc          = $(tc-getCC)/g" "${DEFAULT_RULES}/c"
	sed -i "s/cc          = clang -m64/cc          = $(tc-getCC)/g" "${DEFAULT_RULES}/c"
	sed -i "s/cOPT        = -O3/cOPT        = ${CFLAGS}/g" "${DEFAULT_RULES}/cOpt"

	sed -i "s/CC          = g++ -std=c++11 -m64/CC          = $(tc-getCXX)/g" "${DEFAULT_RULES}/c++"
	sed -i "s/CC          = clang++ -std=c++11 -m64/CC          = $(tc-getCXX)/g" "${DEFAULT_RULES}/c++"
	sed -i "s/c++OPT      = -O3/c++OPT      = ${CXXFLAGS}/g" "${DEFAULT_RULES}/c++Opt"

}

src_compile() {

	./Allwmake ${MAKEOPTS} || die "Build failure."

	if use doc ; then
		cd "${S}/doc/Doxygen" && ./Allwmake && cd -
	fi

}

src_test() {

	if use test ; then
		cd "${S}/test"
		./Allrun || die "Test failure."
		./Allclean
		cd -
	fi

}

src_install() {

	einstalldocs
	rm -rf doc README.org
	use source || rm -rf COPYING src test wmake

	mkdir -p "${ED}/${INSDIR}"
	mv "${S}" "${ED}/${INSDIR}/${MY_PN}-${MY_PV}"

}

pkg_postinst() {

	elog "Please add the following to ~/.bashrc:"
	elog "source ${EPREFIX}/${INSDIR}/${MY_PN}-${MY_PV}/etc/bashrc"

}
