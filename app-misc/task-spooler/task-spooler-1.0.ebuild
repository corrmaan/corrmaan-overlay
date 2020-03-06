# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Unix batch system where the tasks spooled run one after the other."
HOMEPAGE="http://vicerveza.homeunix.net/~viric/soft/ts/"
LICENSE="GPL-2"
SLOT="0"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/corrmaan/task-spooler.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/corrmaan/task-spooler/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
