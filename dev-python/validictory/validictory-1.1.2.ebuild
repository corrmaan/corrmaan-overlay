# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="deprecated general purpose python data validator"
HOMEPAGE="https://github.com/jamesturk/validictory/"
SRC_URI="https://github.com/jamesturk/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="validictory"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
