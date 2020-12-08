# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_MULTILIB=yes
inherit xorg-3

DESCRIPTION="X.Org Xp library"
HOMEPAGE="https://xorg.freedesktop.org"
SRC_URI="https://xorg.freedesktop.org/releases/individual/lib/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 hppa ~mips ppc ppc64 ~s390 sparc x86 ~ppc-aix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"

DEPEND=">=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXau-1.0.7-r1[${MULTILIB_USEDEP}]
	>=x11-proto/printproto-1.0.5[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"
