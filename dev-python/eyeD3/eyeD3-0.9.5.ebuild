# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Module for manipulating ID3 (v1 + v2) tags in Python"
HOMEPAGE="http://eyed3.nicfit.net/"
SRC_URI="https://github.com/nicfit/eyeD3/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0.7"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/paver[${PYTHON_USEDEP}]
	dev-python/python-magic[${PYTHON_USEDEP}]"
