# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

ESVN_REPO_URI="http://fqterm.googlecode.com/svn/trunk"
ESVN_PATCHES="${P}-as-needed.patch"
inherit cmake-utils subversion

DESCRIPTION="a modern terminal emulator for Linux"
HOMEPAGE="http://fqterm.googlecode.com"
SRC_URI="${HOMEPAGE}/files/QQWry.Dat.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="x11-libs/qt-core[ssl,qt3support]
	x11-libs/qt-gui
	media-libs/alsa-lib
	dev-libs/openssl"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_unpack() {
	subversion_src_unpack
	unpack ${A}
}

src_install() {
	cmake-utils_src_install
	insinto /usr/share/FQTerm
	doins "${S}"/QQWry.Dat  || die
}
