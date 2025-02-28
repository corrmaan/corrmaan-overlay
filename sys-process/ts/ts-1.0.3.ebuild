# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Unix batch system where the tasks spooled run one after the other."
HOMEPAGE="https://vicerveza.homeunix.net/~viric/soft/ts"
SRC_URI="https://vicerveza.homeunix.net/~viric/soft/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

DOCS=( Changelog OBJECTIVES PORTABILITY PROTOCOL README TRICKS )
HTML_DOCS=( web/. )

src_install() {
	exeinto /usr/bin
	doexe ts
	doman ts.1
	einstalldocs
}
