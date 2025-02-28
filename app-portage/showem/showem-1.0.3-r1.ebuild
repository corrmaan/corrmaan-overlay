# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="View output of a parallel emerge from a separate terminal"
HOMEPAGE="https://github.com/sakaki-/showem"
SRC_URI="https://github.com/sakaki-/showem/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

RESTRICT="mirror"

RDEPEND="${DEPEND}
	>=sys-libs/ncurses-5.9-r2
	>=app-shells/bash-4.2"

# ebuild function overrides
src_install() {
	dobin "${PN}"
	doman "${PN}.1"
}
