# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_PN="OpenFOAM"
MY_PV="$(ver_cut 1)"
MY_PP="$(ver_cut 3)"
MY_P="${MY_PN}-${MY_PV}-${MY_PP}"

DESCRIPTION="Open Source Field Operation and Manipulation toolbox"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenFOAM/OpenFOAM-dev.git"
else
	SRC_URI="https://github.com/${MY_PN}/${MY_PN}-${MY_PV}/archive/${MY_PP}.tar.gz -> ${MY_PN}-${PV}.tar.gz"
fi
HOMEPAGE="https://openfoam.org/"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="${MY_PV}"
IUSE="cgal doc examples fftw hypre gnuplot metis mpi paraview perftools scotch source"

RDEPEND="gnuplot? ( sci-visualization/gnuplot )
	paraview? ( sci-visualization/paraview[plugins] )"
DEPEND="dev-libs/boost
	|| ( >=sys-devel/gcc-4.8 >=sys-devel/clang-3.6 )
	sys-devel/flex
	sys-libs/ncurses
	sys-libs/readline
	sci-libs/vtk
	sys-libs/zlib
	x11-libs/libXt
	cgal? ( sci-mathematics/cgal )
	doc? ( app-doc/doxygen[dot] )
	fftw? ( sci-libs/fftw )
	hypre? ( sci-libs/hypre )
	metis? ( sci-libs/metis )
	mpi? ( sys-cluster/openmpi )
	perftools? ( dev-util/google-perftools )
	scotch? ( sci-libs/scotch[mpi?] )"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_unpack() {

	default

	mv "${WORKDIR}/${MY_PN}-${MY_PV}-${MY_PP}" "${S}"

}

src_configure() {

	append-cflags $(test-flags-CC -m64)
	append-cxxflags $(test-flags-CXX -m64)
	append-cxxflags $(test-flags-CXX -std=c++0x)
	append-ldflags -m64

	export FOAM_VERBOSE=1
	export PS1=1

	LIBDIR=$(get_libdir)

	use mpi || sed -i '/config.sh\/mpi/s/^/#/g' "${S}/etc/bashrc"
	use paraview || sed -i '/config.sh\/paraview/s/^/#/g' "${S}/etc/bashrc"
	sed -i '/config.sh\/ensight/s/^/#/g' "${S}/etc/bashrc"
	use perftools || sed -i '/config.sh\/gperftools/s/^/#/g' "${S}/etc/bashrc"

	sed -i "s/export WM_CC='gcc'/export WM_CC='$(tc-getCC)'/g" ${S}/etc/config.sh/settings
	sed -i "s/export WM_CXX='g++'/export WM_CXX='$(tc-getCXX)'/g" ${S}/etc/config.sh/settings
	sed -i "s/export WM_CFLAGS='-m64 -fPIC'/export WM_CFLAGS='${CFLAGS}'/g" ${S}/etc/config.sh/settings
	sed -i "s/export WM_CXXFLAGS='-m64 -fPIC -std=c++0x'/export WM_CXXFLAGS='${CXXFLAGS}'/g" ${S}/etc/config.sh/settings
	sed -i "s/export WM_LDFLAGS='-m64'/export WM_LDFLAGS='${LDFLAGS}'/g" ${S}/etc/config.sh/settings

#	if use cgal; then
#		sed -i "s/boost_version=boost_1_64_0/boost_version=boost-systen/g" ${S}/etc/config.sh/CGAL
#		sed -i "s:export BOOST_ARCH_PATH=\$WM_THIRD_PARTY_DIR/platforms/\$WM_ARCH\$WM_COMPILER/\$boost_version:export BOOST_ARCH_PATH=/usr:g" ${S}/etc/config.sh/CGAL

#		sed -i "s/cgal_version=CGAL-4.9.1/cgal_version=cgal-system/g" ${S}/etc/config.sh/CGAL
#		sed -i "s:export CGAL_ARCH_PATH=\$WM_THIRD_PARTY_DIR/platforms/\$WM_ARCH\$WM_COMPILER/\$cgal_version:export CGAL_ARCH_PATH=/usr:g" ${S}/etc/config.sh/CGAL
#	else
#		sed -i "s/boost_version=boost_1_64_0/boost_version=boost-none/g" ${S}/etc/config.sh/CGAL
#		sed -i "s/cgal_version=CGAL-4.9.1/cgal_version=cgal-none/g" ${S}/etc/config.sh/CGAL
#	fi

#	if use metis; then
#		sed -i "s/METIS_VERSION=metis-5.1.0/METIS_VERSION=metis-system/g" ${S}/etc/config.sh/metis
#		sed -i "s:export METIS_ARCH_PATH=\$WM_THIRD_PARTY_DIR/platforms/\$WM_ARCH\$WM_COMPILER\$WM_PRECISION_OPTION\$WM_LABEL_OPTION/\$METIS_VERSION:export METIS_ARCH_PATH=/usr:g" ${S}/etc/config.sh/metis
#	else
#		sed -i "s/METIS_VERSION=metis-5.1.0/METIS_VERSION=metis-none/g" ${S}/etc/config.sh/metis
#	fi

#	if use paraview; then
#		sed -i "s/ParaView_VERSION=5.6.0/ParaView_VERSION=system/g" ${S}/etc/config.sh/paraview
#		export ParaView_DIR=/usr
#		pv_api="$(emerge --info sci-visualization/paraview | \
#			grep 'was built with the following' | cut -d'/' -f2 | \
#			cut -d':' -f1 | cut -d'-' -f2)"
#		pv_api="${pv_api%.*}"
#		sed -i "s/pv_api=pv_api/pv_api=${pv_api}/g" ${S}/etc/config.sh/paraview
#	else
#		sed -i "s/ParaView_VERSION=5.6.0/ParaView_VERSION=none/g" ${S}/etc/config.sh/paraview
#	fi

#	if use perftools; then
#		sed -i "s/gperftools_version=gperftools-2.5/gperftools_version=gperftools-system/g" ${S}/etc/config.sh/gperftools
#		sed -i "s:GPERFTOOLS_ARCH_PATH=\$WM_THIRD_PARTY_DIR/platforms/\$WM_ARCH\$WM_COMPILER/\$gperftools_version:GPERFTOOLS_ARCH_PATH=/usr:g" ${S}/etc/config.sh/gperftools
#	else
#		sed -i "s/gperftools_version=gperftools-2.5/gperftools_version=gperftools-none/g" ${S}/etc/config.sh/gperftools
#	fi

#	if use scotch; then
#		sed -i "s/SCOTCH_VERSION=scotch_6.0.6/SCOTCH_VERSION=scotch-system/g" ${S}/etc/config.sh/scotch
#		sed -i "s:export SCOTCH_ARCH_PATH=\$WM_THIRD_PARTY_DIR/platforms/\$WM_ARCH\$WM_COMPILER\$WM_PRECISION_OPTION\$WM_LABEL_OPTION/\$SCOTCH_VERSION:export SCOTCH_ARCH_PATH=/usr:g" ${S}/etc/config.sh/scotch
#		sed -i "s:header=\$(findFirstFile \$SCOTCH_ARCH_PATH/include/\$header):header=\$(findFirstFile \$SCOTCH_ARCH_PATH/include/scotch/\$header):g" ${S}/wmake/scripts/have_scotch
#	else
#		sed -i "s/SCOTCH_VERSION=scotch_6.0.6/SCOTCH_VERSION=scotch-none/g" ${S}/etc/config.sh/scotch
#	fi

#	VTKVER=$(emerge --info sci-libs/vtk | grep 'was built with the following' | cut -d'/' -f2 | cut -d':' -f1 | cut -d'-' -f2)
#	sed -i "s/vtk_version=VTK-8.2.0/vtk_version=VTK-${VTKVER}/g" ${S}/etc/config.sh/vtk
#	sed -i "s:export VTK_DIR=\$WM_THIRD_PARTY_DIR/platforms/\$WM_ARCH\$WM_COMPILER/\$vtk_version:export VTK_DIR=/usr:g" ${S}/etc/config.sh/vtk
#	sed -i "s:_foamAddLib \$VTK_DIR/lib:_foamAddLib \$VTK_DIR/${LIBDIR}:g" ${S}/etc/config.sh/vtk

#	MESAVER=$(emerge --info media-libs/mesa | grep 'was built with the following' | cut -d'/' -f2 | cut -d':' -f1 | cut -d'-' -f2)
#	sed -i "s/mesa_version=mesa-17.1.1/mesa_version=mesa-${MESAVER}/g" ${S}/etc/config.sh/vtk
#	sed -i "s:export MESA_ARCH_PATH=\$WM_THIRD_PARTY_DIR/platforms/\$WM_ARCH\$WM_COMPILER/\$mesa_version:export MESA_ARCH_PATH=/usr:g" ${S}/etc/config.sh/vtk

	source "${S}/etc/bashrc"

#	find $WM_DIR -name dirToString -exec rm -rf {} +
#	find $WM_DIR -name wmkdep -exec rm -rf {}+
#	find $WM_DIR -name wmkdepend -exec rm -rf {}+

#	append-cflags $(test-flags-CC -fPIC)
#	append-cxxflags $(test-flags-CXX -fPIC)
#	append-cxxflags $(test-flags-CXX -std=c++11)
#	append-cxxflags $(test-flags-CXX -DNoRepository)
#	append-cxxflags $(test-flags-CXX -ftemplate-depth-100)
#	# Not sure if these are really necessary:
#	#append-cxxflags $(test-flags-CXX -m64)
#	#append-cflags $(test-flags-CC -m64)

#	if tc-ld-is-gold; then
#		# Need to disable gold linker https://bugs.openfoam.org/view.php?id=685
#		tc-ld-disable-gold 
#		# tc-ld-disable-gold only appends -fuse-ld=bfd to LDFLAGS, also need to 
#		# append it to C[XX]FLAGS:
#		append-cflags $(test-flags-CC -fuse-ld=bfd)
#		append-cxxflags $(test-flags-CXX -fuse-ld=bfd)
#	fi
#	
#	# wmake Rules Changes
#	COMPILER_TYPE=$(echo $WM_COMPILER | tr -d [:digit:])
#	GENERAL_RULES=$WM_DIR/rules/General
#	DEFAULT_RULES=$WM_DIR/rules/$WM_ARCH$COMPILER_TYPE
#	RULES=$WM_DIR/rules/$WM_ARCH$WM_COMPILER
#	WMAKE_BIN=$WM_DIR/platforms/$WM_ARCH$WM_COMPILER

#	sed -i "s/AR         = ar/AR         = $(tc-getAR)/g" ${GENERAL_RULES}/general
#	sed -i "s/RANLIB     = ranlib/RANLIB     = $(tc-getRANLIB)/g" ${GENERAL_RULES}/general
#	sed -i "s/CPP        = cpp/CPP        = $(tc-getCPP)/g" ${GENERAL_RULES}/general
#	sed -i "s/LD         = ld/LD         = $(tc-getLD)/g" ${GENERAL_RULES}/general

#	sed -i "s/CC          = g++ -std=c++11 -m64/CC          = $(tc-getCXX)/g" ${GENERAL_RULES}/Gcc/c++
#	sed -i "s/CC          = clang++ -std=c++11 -m64/CC          = $(tc-getCC)/g" ${GENERAL_RULES}/Clang/c++

#	# The command below is used instead of $(tc-getCPP) because that produces linking 
#	# errors as gcc -E
#	CPP=$(readlink -f `which cpp` | rev | cut -d'/' -f1 | rev)
#	sed -i "s/CPP        = cpp/CPP        = ${CPP}/g" ${DEFAULT_RULES}/general
#	sed -i "s/LD         = ld/LD         = $(tc-getLD)/g" ${DEFAULT_RULES}/general

#	sed -i "s/cc          = gcc -m64/cc          = $(tc-getCC)/g" ${DEFAULT_RULES}/c
#	sed -i "s/cc          = clang -m64/cc          = $(tc-getCC)/g" ${DEFAULT_RULES}/c
#	sed -i "s/cFLAGS      = \$(GFLAGS) \$(cWARN) \$(cOPT) \$(cDBUG) \$(LIB_HEADER_DIRS) -fPIC/cFLAGS      = \$(GFLAGS) ${CFLAGS} \$(LIB_HEADER_DIRS)/g" ${DEFAULT_RULES}/c
#	sed -i "s/-Xlinker --add-needed/-Xlinker --copy-dt-needed-entries/g" ${DEFAULT_RULES}/c
#	sed -i "s/-Xlinker nodefs/-Xlinker undefs/g" ${DEFAULT_RULES}/c

#	sed -i "s/CC          = g++ -std=c++11 -m64/CC          = $(tc-getCXX)/g" ${DEFAULT_RULES}/c++
#	sed -i "s/CC          = clang++ -std=c++11 -m64/CC          = $(tc-getCC)/g" ${DEFAULT_RULES}/c++
#	sed -i "s/c++FLAGS    = \$(GFLAGS) \$(c++WARN) \$(c++OPT) \$(c++DBUG) \$(ptFLAGS) \$(LIB_HEADER_DIRS) -fPIC/c++FLAGS    = \$(GFLAGS) ${CXXFLAGS} \$(LIB_HEADER_DIRS)/g" ${DEFAULT_RULES}/c++
#	sed -i "s/-Xlinker --add-needed/-Xlinker --copy-dt-needed-entries/g" ${DEFAULT_RULES}/c++

}

#src_compile() {

#	export WM_NCOMPPROCS=$(makeopts_jobs)

#	./Allwmake -j ${WM_NCOMPPROCS} || die "Build failure."

#	if use doc ; then
#		cd ${S}/doc && ./Allwmake && cd ${S}
#	fi

#}

#src_install() {

#	INSDIR="/usr/${LIBDIR}/${PN}-${MY_PV}"

#	insinto ${INSDIR}
#	doins -r bin
#	doins -r etc
#	doins -r platforms
#	doins -r wmake

#	use examples && doins -r tutorials

#	use source && doins -r src

#	dodoc README.md

#	use doc && dohtml -r doc/Doxygen/html/*

#}
