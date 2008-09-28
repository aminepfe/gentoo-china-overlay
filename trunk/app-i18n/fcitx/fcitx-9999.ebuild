# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="http://fcitx.googlecode.com/svn/trunk"
# We never need an empty /usr/share/fcitx/xpm dir. So remove it from system.
ESVN_PATCHES="remove-empty-xpm-dir.patch"

inherit autotools subversion

DESCRIPTION="Free Chinese Input Toy for X. Another Chinese XIM Input Method"
HOMEPAGE="http://fcitx.googlecode.com"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="truetype"

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXrender
	x11-libs/libXt
	truetype? ( x11-libs/libXft )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	subversion_src_unpack
	# Quick and dirty hack, ensure we never install
	# the empty "/usr/share/fcitx/xpm" dir.
	sed -i -e 's:xpm[[:space:]]::g' Makefile.am
	eautoreconf
}

src_compile() {
	econf $(use_enable truetype xft)
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README THANKS TODO

	rm -rf "${D}"/usr/share/fcitx/doc/
	dodoc doc/pinyin.txt doc/cjkvinput.txt
	dohtml doc/wb_fh.htm
}

pkg_postinst() {
	elog "You should export the following variables to use fcitx"
	elog " export XMODIFIERS=\"@im=fcitx\""
	elog " export XIM=fcitx"
	elog " export XIM_PROGRAM=fcitx"
	elog ""
	elog "If you want to use WuBi or ErBi"
	elog " cp /usr/share/fcitx/data/wbx.mb ~/.fcitx"
	elog " cp /usr/share/fcitx/data/erbi.mb ~/.fcitx"
	elog " cp /usr/share/fcitx/data/tables.conf ~/.fcitx"
	elog ""
}
