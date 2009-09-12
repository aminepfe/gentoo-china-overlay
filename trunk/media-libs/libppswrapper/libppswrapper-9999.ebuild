# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_REPO_URI="git://anongit.freedesktop.org/~jinghua/libppswrapper"
inherit autotools flag-o-matic base git

DESCRIPTION="A libpps wrapper"
HOMEPAGE="http://cgit.freedesktop.org/~jinghua"
SRC_URI=""

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-tv/gmlive-extra[pps]"
RDEPEND="${DEPEND}"

pkg_setup() {
	filter-ldflags -Wl,--as-needed
}

src_prepare() {
	AT_M4DIR="m4" eautoreconf
}
