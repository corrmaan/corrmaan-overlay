# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_MULTILIB=yes
inherit xorg-3

DESCRIPTION="X.Org Print protocol headers"
HOMEPAGE="https://www.x.org"
SRC_URI="https://www.x.org/releases/individual/proto/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~mips ppc ppc64 ~s390 sparc x86 ~ppc-aix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND=""
RDEPEND="${DEPEND}"
