# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="The official elementary GTK theme designed to be smooth, attractive, fast, and usable."
HOMEPAGE="https://launchpad.net/egtk"
SRC_URI="https://launchpad.net/egtk/1.0/1.0/+download/eGTK.tar.gz -> eGTK-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~sh ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	x11-themes/dmz-cursor-theme
	x11-themes/elementary-icon-theme
	x11-themes/gtk-engines-aurora
	x11-themes/gtk-engines-murrine"

S="${WORKDIR}"
RESTRICT="binchecks mirror strip"

src_install() {
	insinto /usr/share/themes
	doins -r *
	mv "${D}"/usr/share/themes/{eGTK,elementary}
}