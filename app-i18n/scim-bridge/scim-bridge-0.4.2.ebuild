# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="Scim-bridge is yet another IM client of SCIM"
HOMEPAGE="http://www.scim-im.org/projects/scim_bridge"
SRC_URI="mirror://sourceforge/scim/${P}.tar.gz
	http://freedesktop.org/~scim/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug agent gtk2 qt3 doc"

RDEPEND=">=app-i18n/scim-1.4.2
	virtual/libintl
	gtk2? ( =x11-libs/gtk+-2* )
	qt3? ( =x11-libs/qt-3.3* )
	doc? ( app-doc/doxygen )"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig"

RESTRICT="primaryuri"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {

	# due to the buggy configure script, "--enable-agent" disable the
	# feature in actual , so I must handle them ugly.
	DISABLE=""
	use agent || DISABLE="$DISABLE --disable-agent "
	use gtk2 || DISABLE="$DISABLE --disable-gtk2-immodule "
	use qt3 || DISABLE="$DISABLE --disable-qt3-immodule "
	use doc || DISABLE="$DISABLE --disable-documents "
	#use test || DISABLE="$DISABLE --disable-tests"

	# "--disable-debug" will enable debug
	ENABLE=""
	use debug && ENABLE="$ENABLE --enable-debug "

	econf \
		$ENABLE \
		$DISABLE \
		--disable-static \
		--enable-shared \
		--disable-dependency-tracking || die "econf failed"

	emake || die "make failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog README NEWS TODO
}

pkg_postinst() {
	einfo
	einfo "After you emerged ${PN}, use right click to switch immodules for GTK2."
	einfo "If you would like to use ${PN} as default instead of XIM, set"
	einfo "	% export GTK_IM_MODULE=scim-bridge"
	einfo
}
