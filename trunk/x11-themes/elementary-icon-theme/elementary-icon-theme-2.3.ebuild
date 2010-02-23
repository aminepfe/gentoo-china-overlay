# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2-utils

DESCRIPTION="Elementary icons is an icon theme designed to be smooth, sexy, clear, and efficient."
HOMEPAGE="https://launchpad.net/elementaryicons"
SRC_URI="
	https://launchpad.net/elementaryicons/2.0/2.3/+download/elementary-monochrome.tar.gz -> elementary-monochrome-${PV}.tar.gz
	https://launchpad.net/elementaryicons/2.0/2.3/+download/elementary.tar.gz -> elementary-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	>=x11-misc/icon-naming-utils-0.8.90
	media-gfx/imagemagick
	>=gnome-base/librsvg-2.26.0
	>=x11-themes/hicolor-icon-theme-0.10"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

S="${WORKDIR}"
RESTRICT="binchecks mirror strip"

src_install() {
	insinto /usr/share/icons
	doins -r *
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
