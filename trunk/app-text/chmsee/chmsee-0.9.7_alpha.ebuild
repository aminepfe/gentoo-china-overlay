# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

DESCRIPTION="Utility for viewing Microsoft .chm files."
HOMEPAGE="http://chmsee.gro.clinux.org"
SRC_URI="http://chmsee.gro.clinux.org/${PN}-0.9.7-alpha.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"

IUSE="css"
RDEPEND=">=gnome-base/libglade-2.0
		 >=x11-libs/gtk+-2.8
		 >=gnome-extra/gtkhtml-2.6*
		 app-doc/chmlib
		 dev-libs/openssl
		 "
		 
DEPEND="${RDEPEND}"

src_compile() {
	cd ${WORKDIR}/${PN}-0.9.7-alpha
    econf ${use_enable css} || die "configure failed"
    emake || die "make failed"
}

src_install() {
	cd ${WORKDIR}/${PN}-0.9.7-alpha
    einstall || die
    dodoc COPYING AUTHORS README
}
